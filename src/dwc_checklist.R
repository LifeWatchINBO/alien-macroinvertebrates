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

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/AI_2016_Boets_etal_Supplement.xls"
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read_excel(raw_data_file, sheet = "checklist") 

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
#' In the description extension we want to include **native range** (`raw_origin`), **pathway** (`raw_pathway_of_introduction`) and **salinity zone** (`raw_salinity_zone`) information. We'll create a separate data frame for each and then combine these with union.
#' 
#' ### Pre-processing
#' 