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
#' Preview data:
#' Save to CSV:



#' ## Create distribution extension
#' 
#' ### Pre-processing
#' ### Term mapping

#' #### id
#' #### locationID
#' #### locality
#' #### countryCode
#' #### lifeStage
#' #### occurrenceStatus
#' #### threatStatus
#' #### establishmentMeans
#' #### appendixCITES
#' #### eventDate
#' #### startDayOfYear
#' #### endDayOfYear
#' #### source
#' #### occurrenceRemarks
#' #### datasetID

#' ### Post-processing
#' 
#' Remove the original columns:
#' Preview data:
#' Save to CSV:
#' ## Summary
#' 
#' ### Number of records
#' 
#' * Source file: `r nrow(raw_data)`
#' * Taxon core: `r nrow(taxon)`
#' * Distribution extension: `r nrow(distribution)`
#' * Description extension: `TODO`
#'
#' ### Taxon core
#' 
#' Number of duplicates: `r anyDuplicated(taxon[["taxonID"]])` (should be 0)
#' 
#' The following numbers are expected to be the same:
#' 
#' * Number of records: `r nrow(taxon)`
#' * Number of distinct `taxonID`: `r n_distinct(taxon[["taxonID"]], na.rm = TRUE)`
#' * Number of distinct `scientificName`: `r n_distinct(taxon[["scientificName"]], na.rm = TRUE)`
