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
library(stringr)   # to perform string operations

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/AI_2016_Boets_etal_Supplement.xls"
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
dwc_distribution_file = "../data/processed/dwc_checklist/distribution.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read_excel(raw_data_file, sheet = "checklist", na = "NA") 

#' Clean data somewhat: remove empty rows if present
raw_data %<>%
  remove_empty_rows() %>%     # Remove empty rows
  clean_names()               # Have sensible (lowercase) column names

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
taxon %<>% mutate("Ghent University Aquatic Ecology")
    
#' #### accessRights
taxon %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")

#' #### bibliographicCitation
#' #### informationWithheld
#' #### datasetID
taxon  %<>% mutate(datasetID = "")
 
#' #### datasetName
taxon %<>% mutate(datasetName = "Checklist of alien macroinvertebrates in Flanders, Belgium")

#' #### references
taxon%<>% mutate(references = "http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf")

#' #### taxonID

#' To be completed!

#' #### scientificNameID
#' #### acceptedNameUsageID
#' #### parentNameUsageID
#' #### originalNameUsageID
#' #### nameAccordingToID
#' #### namePublishedInID
#' #### taxonConceptID
#' #### scientificName
taxon %<>% mutate(scientificName = raw_species)
#
#' verification if scientificName contains unique values:
any(duplicated(taxon $scientificName))

#' #### namePublishedInYear
#' #### higherClassification
#' #### kingdom
taxon %<>% mutate(kingdom = "Animalia")

#' #### phylum
taxon %<>% mutate(phylum = raw_phylum)
  
#' #### class
#' #### order
taxon %<>% mutate(order = raw_order)

#' #### family
taxon %<>% mutate(family = raw_family)

#' #### genus
#' #### subgenus
#' #### specificEpithet
#' #### infraspecificEpithet
#' #### taxonRank
taxon %<>% mutate(taxonRank = "species")

#' #### verbatimTaxonRank
#' #### scientificNameAuthorship

#' To be completed!

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
# to be determined!

#' #### locationID
distribution %<>% mutate(locationID = "ISO_3166-2:BE-VLG")

#' #### locality
distribution %<>% mutate(locality = "Flanders")

#' #### countryCode
distribution %<>% mutate(countryCode = "BE")

#' #### lifeStage
#' #### occurrenceStatus
distribution %<>% mutate(occurrenceStatus = "Present")

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

#' `eventDate` will be of format `start_year`- `current_year` (yyyy-yyyy).
#' `start_year` (yyyy) will contain the information from the following formats in `raw_first_occurrence_in_flanders`: "yyyy", "< yyyy", "<yyyy" and "before yyyy" OR the first year of the interval "yyyy-yyyy":
#' `current_year` (yyyy) will contain the current year OR the last year of the interval "yyyy-yyyy":
#' Before further processing, `raw_first_occurrence_in_flanders` needs to be cleaned, i.e. remove "<","< " and "before ":
distribution %<>% mutate(year = str_replace_all(raw_first_occurrence_in_flanders, "(< |before |<)", ""))

#' Create `start_year`:
distribution %<>%
  mutate(start_year = 
           case_when(
             str_detect(year, "-") == "TRUE" ~ "1730",   # when `year` = range --> pick first year (1730 in 1730-1732)
             str_detect(year, "-") == "FALSE" ~ year))   

#' Create `current_year`:
distribution %<>%
  mutate (current_year = 
            case_when(
              str_detect(year, "-") == TRUE ~ "1732",    # when `year` = range --> pick last year (1730 in 1730-1732)
              str_detect(year, "-") == FALSE ~ format(Sys.Date(), "%Y")))

#' Create `eventDate` by binding `start_year` and `current_year`:
distribution %<>% 
  mutate (eventDate = paste (start_year, current_year, sep ="-")) 

#' Compare formatted dates with `raw_first_occurrence_in_flanders`:
distribution %>% 
  select (raw_first_occurrence_in_flanders, eventDate) %>%
  kable()

#' remove intermediary steps `year`, `start_year`, `current_year`:
distribution %<>% select (-c(year, start_year, current_year))

#' #### startDayOfYear
#' #### endDayOfYear
#' #### source
distribution %<>% mutate (source = raw_reference)

#' #### occurrenceRemarks

#' ### Post-processing
#' 
#' Remove the original columns:
distribution %<>% select(-one_of(raw_colnames))

#' Preview data:
kable(head(distribution))

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

#' HERE: SORT ON TAXONID

#' Manually cleaning of `value` to make them more standardized
native_range %<>% 
  mutate(mapped_value = recode(
    value,
    "East-Asia" = "Eastern Asia",
    "East-Europe" = "Eastern Europe",
    "North-Africa" = "Northern Africa",
    "North-America" = "Northern America",
    "Northeast-Asia" = "North-eastern Asia",
    "South-America" = "South America",
    "South-Europe" = "Southern Europe",
    "Southeast-Asia" = "South-eastern Asia",
    "West-Africa" = "Western Africa"))

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
#' `raw_pathway_of_introduction` contains information on the pathway of introduction (e.g. `aquaculture`). We'll separate, clean, map and combine these values.
#' 
#' Create new data frame:
pathway <- raw_data

#' Inspect `pathway`:
pathway %>%
  distinct(raw_pathway_of_introduction) %>%
  arrange(raw_pathway_of_introduction) %>%
  kable()

#' Similar as for `native_range`, we create a new variable `description` in `pathway` from `raw_pathway_of_introduction`:
pathway %<>% mutate(description = raw_pathway_of_introduction)

#' Separate `description` on column in 3 columns.
# In case there are more than 3 values, these will be merged in pathway_3. 
# The dataset currently contains no more than 3 values per record.
pathway %<>% 
  separate(description, 
           into = c("pathway_1", "pathway_2", "pathway_3"),
           sep = ", ",
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

#' HERE: SORT ON TAXONID

#' In `value`, both `other` and `others` is given as a pathway of introduction.
#' We clean `value` by changing `others` --> `other`
pathway %<>% mutate(value = recode(value, "others" = "other"))

#' Show new values:
pathway %>%
  distinct(value) %>%
  arrange(value) %>%
  kable()

#' Drop `key` column and rename `value`:
pathway %<>% select(-key)
pathway %<>% rename(description = value)

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

#' HERE: SORT ON TAXONID

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

