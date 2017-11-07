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

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/alien_macroinvertebrates_occurrences.tsv"
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
dwc_distribution_file = "../data/processed/dwc_checklist/distribution.csv"
dwc_description_file = "../data/processed/dwc_checklist/description.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM") 

#' Clean data somewhat: remove empty rows if present
raw_data %<>%  remove_empty_rows() 

#' Add prefix `raw_` to all column names. Although the column names already contain Darwin Core terms, new columns will have to be added between the current columns. To put all columns in the right order, it is easier to create new columns (some of them will be copies of the columns in the raw dataset) and then remove the columns of the raw occurrence dataset:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Preview data:
kable(head(raw_data))

#' ## Group by species
#' 
#' Group the occurrence data as species data (= one record for each scientific name):
raw_species <- raw_data # replace by dplyr groupby on taxonID, scientificName, taxonRank and scientificNameAuthorship

#' Order by raw_taxonID:
# raw_species %<>% arrange(raw_taxonID)

#' Save the raw column names as a list (makes it easier to remove them all later):
raw_colnames <- colnames(raw_species)

#' Preview data:
kable(head(raw_species))

#' ## Create taxon core
#' 
#' ### Pre-processing
taxon <- raw_species

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
taxon %<>% mutate(rightsHolder = "Ugent; Aquatic ecolo")
  
#' #### accessRights
taxon %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")

#' #### bibliographicCitation
#' #### informationWithheld
#' #### datasetID
taxon %<>% mutate(datasetID = "")

#' #### datasetName
taxon %<>% mutate(datasetName = "Alien macroinvertebrates checklist for Flanders, Belgium")

#' #### references
#' #### taxonID
taxon %<>% mutate(taxonID = "") # Should be taken from source

#' #### scientificNameID
#' #### acceptedNameUsageID
#' #### parentNameUsageID
#' #### originalNameUsageID
#' #### nameAccordingToID
#' #### namePublishedInID
#' #### taxonConceptID
#' #### scientificName
taxon %<>% mutate(scientificName = raw_scientificName)

#' #### acceptedNameUsage
#' #### parentNameUsage
#' #### originalNameUsage
#' #### nameAccordingTo
#' #### namePublishedIn
#' #### namePublishedInYear
#' #### higherClassification
#' #### kingdom
taxon %<>% mutate(kingdom = "Animalia")

#' #### phylum
#' #### class
#' #### order
#' #### family
#' #### genus
#' #### subgenus
#' #### specificEpithet
#' #### infraspecificEpithet
#' #### taxonRank
taxon %<>% mutate(taxonRank = raw_taxonRank)

#' #### verbatimTaxonRank
#' #### scientificNameAuthorship
taxon %<>% mutate(scientificNameAuthorship = raw_scientificNameAuthorship)

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
distribution <- raw_species

#' ### Term mapping

#' #### id
distribution %<>% mutate(id = "")

#' #### locationID
distribution %<>% mutate(locationID = "ISO_3166-2:BE-VLG")

#' #### locality
distribution %<>% mutate(locality = "Flanders")

#' #### countryCode
distribution %<>% mutate(countryCode = "BE")

#' #### lifeStage
#' #### occurrenceStatus
distribution %<>% mutate(occurrenceStatus = "present")

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

distribution %<>% select(-one_of(raw_colnames))

#' Preview data:
kable(head(distribution))

#' Save to CSV:
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")

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
