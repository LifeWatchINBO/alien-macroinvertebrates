#' # Darwin Core mapping for checklist dataset
#' 
#' Lien Reyserhove, Dimitri Brosens, Peter Desmet
#' 
#' `r Sys.Date()`
#'
#' This document describes how we map the checklist data to Darwin Core.
#' 
#' ## Setup
#' 
#+ configure_knitr, include = FALSE
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

#' Set locale (so we use UTF-8 character encoding):
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

#' Load libraries:
library(tidyverse) # For data transformations

# None core tidyverse packages:
library(magrittr)  # For %<>% pipes

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
library(readxl)    # To read excel files
library(stringr)   # To perform string operations
library(digest)    # To generate hashes

#' Set file paths (all paths should be relative to this script):
#' 
#' raw files: 
raw_data_file = "../data/raw/AI_2016_Boets_etal_Supplement.xls"
sources_file = "../data/raw/sources.tsv"

#' processed files: 
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
dwc_distribution_file = "../data/processed/dwc_checklist/distribution.csv"
dwc_description_file = "../data/processed/dwc_checklist/description.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read_excel(raw_data_file, sheet = "checklist", na = "NA") 
sources <- read.table(sources_file, sep = "\t", quote="", colClasses = "character",  fileEncoding = "UTF8", header = T)

#' Clean data somewhat: remove empty rows if present
raw_data %<>%
  remove_empty_rows() %>%     # Remove empty rows
  clean_names()               # Have sensible (lowercase) column names

#' Distributions will have a start date and end date. The start date is the year of first observation (`first occurrence in Flanders`), but for the end date we have to assume when the presence of the species was last verified. 
#' We'll use the publication year of Boets et al. 2016:
raw_data %<>% mutate(end_year = "2016")

#' We need to integrate the DwC term `taxonID` in each of the generated files (Taxon Core and Extensions).
#' For this reason, it is easier to generate `taxonID` in the raw file. 
#' First, we vectorize the digest function (The digest() function isn't vectorized. 
#' So if you pass in a vector, you get one value for the whole vector rather than a digest for each element of the vector):
vdigest <- Vectorize(digest)

#' Generate `taxonID`:
raw_data %<>% mutate(taxonID = paste("alien-macroinvertebrates", "taxon", vdigest (species, algo="md5"), sep=":"))

#' Add prefix `raw_` to all column names to avoid name clashes with Darwin Core terms:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Save those column names as a vector (makes it easier to remove them all later):
raw_colnames <- colnames(raw_data)

#' Preview data:
kable(head(raw_data))

#' ## Create taxon core
taxon <- raw_data

#' ### Pre-processing
#' ### Term mapping
#' 
#' Map the source data to [Darwin Core Taxon](http://rs.gbif.org/core/dwc_taxon_2015-04-24.xml):
#' 
#' #### modified
#' #### language
taxon %<>% mutate(language = "en")

#' #### license
taxon %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
  
#' #### rightsHolder
taxon %<>% mutate(rightsHolder = "Ghent University Aquatic Ecology")
    
#' #### accessRights
taxon %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")

#' #### bibliographicCitation
#' #### informationWithheld
#' #### datasetID
taxon  %<>% mutate(datasetID = "")
 
#' #### datasetName
taxon %<>% mutate(datasetName = "Checklist of alien macroinvertebrates in Flanders, Belgium")

#' #### references
#' #### taxonID
taxon%<>% mutate(taxonID = raw_taxonID)
  
#' #### scientificNameID
#' #### acceptedNameUsageID
#' #### parentNameUsageID
#' #### originalNameUsageID
#' #### nameAccordingToID
#' #### namePublishedInID
#' #### taxonConceptID
#' #### scientificName
taxon %<>% mutate(scientificName = raw_species)

#' verification if scientificName contains unique values:
any(duplicated(taxon $scientificName))

#' #### namePublishedInYear
#' #### higherClassification
#' #### kingdom
taxon %<>% mutate(kingdom = "Animalia")

#' #### phylum
#' 
#' Crustacea is not a phylum but a subphylum. The phylum to which crustaceans belong is "Arthropoda"
taxon %<>% mutate (phylum = recode (raw_phylum, "Crustacea" = "Arthropoda"))
  
#' #### class
#' #### order
taxon %<>% 
  mutate(order = recode(raw_order, 
                        "Veneroidea" = "Venerida")) %<>%
  mutate (order = str_trim(order))

#' #### family
taxon %<>% mutate(family = raw_family)

#' #### genus
#' #### subgenus
#' #### specificEpithet
#' #### infraspecificEpithet
#' #### taxonRank
taxon %<>% mutate(taxonRank = case_when(
  raw_species == "Dreissena rostriformis bugensis" ~ "subspecies",
  raw_species != "Dreissena rostriformis bugensis" ~ "species")
  )

#' #### verbatimTaxonRank
#' #### scientificNameAuthorship
#' #### vernacularName
#' #### nomenclaturalCode
taxon %<>% mutate(nomenclaturalCode = "ICZN")

#' #### taxonomicStatus
#' #### nomenclaturalStatus
#' #### taxonRemarks
#' 
#' ### Post-processing
#' 
#' Remove the original columns:
taxon %<>% select(-one_of(raw_colnames))

#' Preview data:
kable(head(taxon))

#' Save to CSV:
write.csv(taxon, file = dwc_taxon_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")


#' ## Create distribution extension
#' 
#' ### Pre-processing
distribution <- raw_data

#' ### Term mapping
#' 
#' Map the source data to [Species Distribution](http://rs.gbif.org/extension/gbif/1.0/distribution.xml):

#' #### taxonID
distribution %<>% mutate(taxonID = raw_taxonID)
  
#' #### locationID
distribution %<>% mutate(locationID = "ISO_3166-2:BE-VLG")

#' #### locality
distribution %<>% mutate(locality = "Flemish Region")

#' #### countryCode
distribution %<>% mutate(countryCode = "BE")

#' #### lifeStage
#' #### occurrenceStatus
distribution %<>% mutate(occurrenceStatus = "present")

#' #### threatStatus
#' #### establishmentMeans
#' #### appendixCITES
#' #### eventDate
#'
#' Inspect content of `raw_first_occurrence_in_flanders`:
distribution %>%
  distinct(raw_first_occurrence_in_flanders) %>%
  arrange(raw_first_occurrence_in_flanders) %>%
  kable()

#' `eventDate` will be of format `start_year`/`end_year` (yyyy/yyyy).
#' `start_year` (yyyy) will contain the information from the following formats in `raw_first_occurrence_in_flanders`: "yyyy", "< yyyy", "<yyyy" and "before yyyy" OR the first year of the interval "yyyy-yyyy":
#' `end_year` (yyyy) is `2016` OR will contain the last year of the interval "yyyy-yyyy" in `raw_first_occurrence_in_flanders`:
#' Before further processing, `raw_first_occurrence_in_flanders` needs to be cleaned, i.e. remove "<","< " and "before ":
distribution %<>% mutate(year = str_replace_all(raw_first_occurrence_in_flanders, "(< |before |<)", ""))

#' Create `start_year`:
distribution %<>%
  mutate(start_year = 
           case_when(
             str_detect(year, "-") == "TRUE" ~ "1730",   # when `year` = range --> pick first year (1730 in 1730-1732)
             str_detect(year, "-") == "FALSE" ~ year))   

#' Create `end_year`:
distribution %<>%
  mutate (end_year = 
            case_when(
              str_detect(year, "-") == TRUE ~ "1732",    # when `year` = range --> pick last year (1730 in 1730-1732)
              str_detect(year, "-") == FALSE ~ raw_end_year))

#' Create `eventDate` by binding `start_year` and `end_year`:
distribution %<>% 
  mutate (eventDate = paste (start_year, end_year, sep ="/")) 

#' Compare formatted dates with `raw_first_occurrence_in_flanders`:
distribution %>% 
  select (raw_first_occurrence_in_flanders, eventDate) %>%
  kable()

#' remove intermediary steps `year`, `start_year`, `end_year`:
distribution %<>% select (-c(year, start_year, end_year))

#' #### startDayOfYear
#' #### endDayOfYear
#' #### source
#'
#' Clean `raw_reference` somewhat:
distribution %<>% mutate (raw_reference = recode(
raw_reference,
"Adam  and Leloup 1934" = "Adam and Leloup 1934",  # remove whitespace
"Van  Haaren and Soors 2009" = "van Haaren and Soors 2009", # remove whitespace and lowercase "van"
"This study" = "Boets et al. 2016",
"Nyst 1835; Adam 1947" = "Nyst 1835 | Adam 1947" ))

#' The full reference for source can be found in the raw file `sources`.
#' We will combine `sources` with `distribution`, based on their respective columns `citation` and `raw_reference`. 
#' For this, `citation` must be equal to `raw_reference`:
sort(unique(distribution $ raw_reference)) == sort(unique(sources $ citation)) # --> Yes!

#' Merge `sources` with `distribution`:
distribution %<>% 
  left_join(sources, by = c("raw_reference" = "citation")) %<>% 
  rename(source = reference)

#' Visualisation of this merge. 
#' (`Boets. et al. unpub data` and `Collection RBINS` full references were lacking in `source`)
distribution %>% 
  mutate (source = substr(source, 1,10)) %>%  # shorten full reference to make it easier to display 
  rename (citation = raw_reference) %>%
  select (citation, source) %>%
  group_by(citation, source) %>%
  summarise(records = n()) %>%
  arrange (citation) %>%
  kable()

#' #### occurrenceRemarks

#' ### Post-processing
#' 
#' Remove the original columns:
distribution %<>% select(-one_of(raw_colnames))

#' Preview data:
distribution %>% 
  mutate (source = substr(source, 1,10)) %>%
  head() %>%
  kable()

#' Save to CSV:
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")

#' ## Create description extension
#' 
#' In the description extension we want to include **native range** (`raw_origin`), **pathway** (`raw_pathway_of_introduction`) and **habitat** (`raw_salinity_zone`) information. We'll create a separate data frame for each and then combine these with union.
#' 
#' ### Pre-processing
#' 
#' #### Native range
#' 
#' `raw_origin` contains native range information (e.g. `South-America`). We'll separate, clean, map and combine these values.
#' 
#' Create new data frame:
native_range <- raw_data

#' Inspect native_range:
native_range %>%
  distinct(raw_origin) %>%
  arrange(raw_origin) %>%
  kable()


#' Create `description` from `raw_origin`:
native_range %<>% mutate(description = raw_origin)

#' Separate `description` on column in 3 columns.
# In case there are more than 3 values, these will be merged in native_range_3. 
# The dataset currently contains no more than 3 values per record.
native_range %<>% 
  separate(description, 
           into = c("native_range_1", "native_range_2", "native_range_3"),
           sep = ", ",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )

#' Gather native ranges in a key and value column:
native_range %<>% gather(
  key, value,
  native_range_1, native_range_2, native_range_3,
  na.rm = TRUE, # Also removes records for which there is no native_range_1
  convert = FALSE
)

#' Manually cleaning of `value` to make them more standardized
native_range %<>% mutate(mapped_value = recode(value,
    "East-Asia" = "East Asia",
    "East-Europe" = "Eastern Europe",
    "Indio-Pacific" = "Indo-Pacific",
    "North-Africa" = "North Africa",
    "North-America" = "Northern America",
    "Northeast-Asia" = "Northeast Asia",
    "South-America" = "South America",
    "South-Europe" = "Southern Europe",
    "Southeast-Asia" = "Southeast Asia",
    "Southern hemisphere" = "Southern Hemisphere",
    "USA" = "United States",
    "West-Africa" = "West Africa",
    "West-Atlantic" = "Western Atlantic"
))

#' Show mapped values:
native_range %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()

#' Drop `key` and `value` column and rename `mapped value`:
native_range %<>% select(-key, -value)
native_range %<>% rename(description = mapped_value)

#' Keep only non-empty descriptions:
native_range %<>% filter(!is.na(description) & description != "")

#' Create a `type` field to indicate the type of description:
native_range %<>% mutate(type = "native range")

#' Preview data:
kable(head(native_range))

#' #### Pathway (pathway of introduction)
#' 
#' `raw_pathway_of_introduction` contains the raw information on the pathway of introduction (e.g. `aquaculture`).
#' `raw_pathway_mapping` contains the interpretation of this pathway information bij @timadriaens. We will use this information to further process our mapping to DwC Archive.
#' (Remarks on this interpretation are given in `raw_pathway_mapping_remarks`)
#'  We'll separate, clean, map and combine these values.
#' 
#' Create new data frame:
pathway <- raw_data

#' Similar as for `native_range`, we create a new variable `description` in `pathway` from `raw_pathway_mapping`:
pathway %<>% mutate(description = raw_pathway_mapping)

#' Separate `description` on column in 3 columns.
# In case there are more than 3 values, these will be merged in pathway_3. 
# The dataset currently contains no more than 3 values per record.
pathway %<>% 
  separate(description, 
           into = c("pathway_1", "pathway_2", "pathway_3"),
           sep = " \\| ",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )

#' Gather pathways in a key and value column:
pathway %<>% gather(
  key, value,
  pathway_1, pathway_2, pathway_3,
  na.rm = TRUE, # Also removes records for which there is no pathway_1
  convert = FALSE
)

#' Inspect values:
pathway %>%
  distinct(value) %>%
  arrange(value) %>%
  kable()

#' For `pathway` information, we use the suggested vocabulary for introduction pathways used in the TrIAS project, summarized [here](https://github.com/trias-project/vocab/tree/master/vocabulary/pathway).
#' This standardized vocabulary is based on the [CBD 2014 standard](https://www.cbd.int/doc/meetings/sbstta/sbstta-18/official/sbstta-18-09-add1-en.pdf)

#' recode values:
pathway %<>% mutate (cbd_stand = recode (value,
  "Aquaculture" = "escape_aquaculture",
  "Aquaculture / mariculture" = "escape_aquaculture",
  "Contaminant on animals (except parasites, species transported by host/vector)" = "contaminant_on_animals",
  "Interconnected waterways/basins/seas" = "corridor_water",
  "Mariculture" = "escape_aquaculture",
  "Other means of transport" = "stowaway_other",
  "Pet/aquarium/terrarium species (including live food for such species )" = "escape_pet",
  "Ship/boat ballast water" = "stowaway_ballast_water",
  "Ship/boat hull fouling" = "stowaway_hull_fouling"))

#' Add prefix `cbd_2014_pathway`:
pathway %<>% mutate(mapped_value = paste ("cbd_2014_pathway", cbd_stand, sep = ":"))

#' Inspect new_pathways:
pathway %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()


#' Drop `key`, `value` and `cbd_stand` column and rename `mapped_value`:
pathway %<>% select(-key, - value, -cbd_stand)
pathway %<>% rename(description = mapped_value)

#' Keep only non-empty descriptions:
pathway %<>% filter(!is.na(description) & description != "")

#' Create a `type` field to indicate the type of description:
pathway %<>% mutate(type = "pathway")

#' Preview data:
kable(head(pathway))

#' #### Habitat
#' 
#' `raw_salinity_zone` contains information on the habitat of the species ("B" = brackish, "M" = marine, "freshwater"). We'll separate, clean, map and combine these values.
#' 
#' Create new data frame:
habitat <- raw_data

#' Inspect native_range:
habitat %>%
  distinct(raw_salinity_zone) %>%
  arrange(raw_salinity_zone) %>%
  kable()

#' Similar as for `native_range` and `pathway`, we create a new variable `description` in `habitat` from `raw_salinity_zone`:
habitat %<>% mutate(description = raw_salinity_zone)

#' Separate `description` on column in 2 columns.
# In case there are more than 2 values, these will be merged in habitat_2. 
# The dataset currently contains no more than 2 values per record.
habitat %<>% 
  separate(description, 
           into = c("habitat_1", "habitat_2"),
           sep = "/",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )

#' Gather habitats in a key and value column:
habitat %<>% gather(
  key, value,
  habitat_1, habitat_2,
  na.rm = TRUE, # Also removes records for which there is no habitat_1
  convert = FALSE
)

#' `value now contains` the abbreviations `B`, `M` and `F` --> we substitute these by `brackish`, `marine` and `freshwater` respectively.
habitat %<>% 
  mutate(mapped_value = recode(
    value,
    "B" = "brackish",
    "M" = "marine",
    "F" = "freshwater"))

#' Show mapped values:
habitat %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()

#' Drop `key` and `value` column and rename `mapped value`:
habitat %<>% select(-key, -value)
habitat %<>% rename(description = mapped_value)

#' Keep only non-empty descriptions:
habitat %<>% filter(!is.na(description) & description != "")

#' Create a `type` field to indicate the type of description:
habitat %<>% mutate(type = "habitat")

#' Preview data:
kable(head(habitat))

#' #### Union native range, pathway and habitat:
description_ext <- bind_rows(native_range, pathway, habitat)

#' ### Term mapping
#' 
#' Map the source data to [Taxon Description](http://rs.gbif.org/extension/gbif/1.0/description.xml):

#' #### taxonID
description_ext %<>% mutate(taxonID = raw_taxonID)

#' #### description
description_ext %<>% mutate(description = description)

#' #### type
description_ext %<>% mutate(type = type)

#' #### source
#' 
#' Clean `raw_reference` somewhat:
description_ext %<>% mutate (raw_reference = recode(
  raw_reference,
  "Adam  and Leloup 1934" = "Adam and Leloup 1934",  # remove whitespace
  "Van  Haaren and Soors 2009" = "van Haaren and Soors 2009", # remove whitespace and lowercase "van"
  "This study" = "Boets et al. 2016",
  "Nyst 1835; Adam 1947" = "Nyst 1835 | Adam 1947" ))

#' The full reference for source can be found in the raw file `sources`.
#' We will combine `sources` with `description_ext`, based on their respective columns `citation` and `raw_reference`. 
#' For this, `citation` must be equal to `raw_reference`:
sort(unique(description_ext $ raw_reference)) == sort(unique(sources $ citation)) # --> Yes!

#' Merge `sources` with `description_ext`:
description_ext %<>% 
  left_join(sources, by = c("raw_reference" = "citation")) %<>% 
  rename(source = reference)

#' Visualisation of this merge. 
#' (`Boets. et al. unpub data` and `Collection RBINS` full references are lacking in `source`)
description_ext %>% 
  mutate (source = substr(source, 1,10)) %>%  # shorten full reference to make it easier to display 
  rename (citation = raw_reference) %>%
  select (citation, source) %>%
  group_by(citation, source) %>%
  summarise(records = n()) %>%
  arrange (citation) %>%
  kable()

#' #### language
description_ext %<>% mutate(language = "en")

#' #### created
#' #### creator
#' #### contributor
#' #### audience
#' #### license
#' #### rightsHolder
#' #### datasetID


#' ### Post-processing
#' 
#' Remove the original columns:
description_ext %<>% select(-one_of(raw_colnames))

#' Move `taxonID` to the first position:
description_ext %<>% select(taxonID, everything())

#' Sort on `taxonID`:
description_ext %<>% arrange(taxonID)

#' Preview data:
description_ext %>% 
  mutate (source = substr(source, 1,10)) %>%
  head() %>%
  kable()

#' Save to CSV:
write.csv(description_ext, file = dwc_description_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
