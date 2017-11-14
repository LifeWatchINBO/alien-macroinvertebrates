#' # Darwin Core mapping for occurrence dataset
#' 
#' Lien Reyserhove, Dimitri Brosens, Peter Desmet
#' 
#' `r Sys.Date()`
#'
#' This document describes how we map the occurrence data to Darwin Core.
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
raw_data_file = "../data/raw/denormalized_observations.csv"
dwc_occurrence_file = "../data/processed/dwc_occurrence/occurrence.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM", stringsAsFactors = F) 

#' Clean data somewhat: remove empty rows if present
raw_data %<>%  remove_empty_rows() 

#' Add prefix `raw_` to all column names. Although the column names already contain Darwin Core terms, new columns will have to be added between the current columns. To put all columns in the right order, it is easier to create new columns (some of them will be copies of the columns in the raw dataset) and then remove the columns of the raw occurrence dataset:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Save those column names as a list (makes it easier to remove them all later):
raw_colnames <- colnames(raw_data)

#' Preview data:
kable(head(raw_data))

#' ## Create occurrence core
#' 
#' ### Pre-processing
occurrence <- raw_data

#' ### Term mapping
#' 
#' Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):
#' 
#' #### type
occurrence %<>% mutate(type = "Event")
  
#' #### modified
#' #### language
occurrence %<>% mutate(language ="en")

#' #### license
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0")

#' #### rightsHolder
occurrence %<>% mutate(rightsHolder = "Ghent University")

#' #### accessRights
occurrence %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")

#' #### bibliographicCitation
#' #### references
#' #### institutionID
#' #### collectionID
#' #### datasetID
occurrence %<>% mutate(datasetID = "https://doi.org/10.15468/xjtfoo")

#' #### institutionCode
occurrence %<>% mutate(institutionCode = "INBO")

#' #### collectionCode
#' #### datasetName
occurrence %<>% mutate(datasetName = "Alien macroinvertebrates in Flanders, Belgium")

#' #### ownerInstitutionCode
#' #### basisOfRecord
occurrence %<>% mutate(basisOfRecord = "HumanObservation")

#' #### informationWithheld
#' #### dataGeneralizations
#' #### dynamicProperties
#' 
#' ---
#' 
#' #### occurrenceID
n_distinct(occurrence $ raw_taxon_occurrence_comment)  # Checking whether occurrenceID is a unique code
occurrence %<>% mutate(occurrenceID = raw_taxon_occurrence_comment)


#' #### catalogNumber
#' #### recordNumber
#' #### recordedBy
#' #### individualCount
#' #### organismQuantity
#' #### organismQuantityType
#' #### sex
#' #### lifeStage
#' #### reproductiveCondition
#' #### behavior
#' #### establishmentMeans
#' #### occurrenceStatus
#' #### preparations
#' #### disposition
#' #### associatedMedia
#' #### associatedReferences
#' #### associatedSequences
#' #### associatedTaxa
#' #### otherCatalogNumbers
occurrence %<>% mutate(otherCatalogNumbers = raw_taxon_occurrence_key)

#' #### occurrenceRemarks
#' 
#' ---
#' 
#' #### organismID
#' #### organismName
#' #### organismScope
#' #### associatedOccurrences
#' #### associatedOrganisms
#' #### previousIdentifications
#' #### organismRemarks
#' 
#' ---
#' 
#' #### materialSampleID
#' 
#' ---
#' 
#' #### eventID
#' #### parentEventID
#' #### fieldNumber
#' #### eventDate
#' 
#' `eventDate` data can be found both in `raw_sample_vague_date_start` and `raw_sample_vague_date_end`
#'  Both variables are imported as character vectors and need to be converted to an object of class "date".

occurrence %<>% 
  mutate(eventDate_start = as.Date (raw_sample_vague_date_start,"%Y-%m-%d")) %<>% 
  mutate(eventDate_end = as.Date (raw_sample_vague_date_end,"%Y-%m-%d")) 

#' `eventDate_start` and `eventDate_end`are not always identical: 
with (occurrence, identical(eventDate_start, eventDate_end))

#' Thus: `eventDate`` will be expressed as: 
#' yyy-mm-dd when `eventDate_start` = `eventDate_end`
#' yyy-mm-dd / yy-mm-dd when `eventDate_start` != `eventDate_end`

#' new column `eventDate_interval` for when `eventDate_start` != `eventDate_end`
occurrence %<>% mutate(eventDate_interval = paste (eventDate_start, eventDate_end, sep ="/"))  

#' Create `eventDate`, which contains `eventDate_start` when `eventDate_start` = `eventDate_end`, or else `eventDate_interval` when `eventDate_start` != `eventDate_end`
occurrence %<>% mutate (eventDate =
           case_when (
             raw_sample_vague_date_start == raw_sample_vague_date_end ~ as.character (eventDate_start),
             raw_sample_vague_date_start != raw_sample_vague_date_end ~ eventDate_interval
           ))

#' Remove the extra columns:
occurrence %<>% select (- c(eventDate_start, eventDate_end, eventDate_interval))

#' #### eventTime
#' #### startDayOfYear
#' #### endDayOfYear
#' #### year
#' #### month
#' #### day
#' #### verbatimEventDate
#' #### habitat
#' #### samplingProtocol
#' #### sampleSizeValue
#' #### sampleSizeUnit
#' #### samplingEffort
#' #### fieldNotes
#' #### eventRemarks
#' 
#' ---
#' 
#' #### locationID
#' #### higherGeographyID
#' #### higherGeography
#' #### continent
#' #### waterBody
#' #### islandGroup
#' #### island
#' #### country
#' #### countryCode
#' #### stateProvince
#' #### county
#' #### municipality
#' #### locality
#' #### verbatimLocality
#' #### minimumElevationInMeters
#' #### maximumElevationInMeters
#' #### verbatimElevation
#' #### minimumDepthInMeters
#' #### maximumDepthInMeters
#' #### verbatimDepth
#' #### minimumDistanceAboveSurfaceInMeters
#' #### maximumDistanceAboveSurfaceInMeters
#' #### locationAccordingTo
#' #### locationRemarks
#' #### decimalLatitude
#' #### decimalLongitude
#' #### geodeticDatum
#' #### coordinateUncertaintyInMeters
#' #### coordinatePrecision
#' #### pointRadiusSpatialFit
#' #### verbatimCoordinates
#' #### verbatimLatitude
#' #### verbatimLongitude
#' #### verbatimCoordinateSystem
#' #### verbatimSRS
#' #### footprintWKT
#' #### footprintSRS
#' #### footprintSpatialFit
#' #### georeferencedBy
#' #### georeferencedDate
#' #### georeferenceProtocol
#' #### georeferenceSources
#' #### georeferenceVerificationStatus
#' #### georeferenceRemarks
#' 
#' ---
#' 
#' #### geologicalContextID
#' #### earliestEonOrLowestEonothem
#' #### latestEonOrHighestEonothem
#' #### earliestEraOrLowestErathem
#' #### latestEraOrHighestErathem
#' #### earliestPeriodOrLowestSystem
#' #### latestPeriodOrHighestSystem
#' #### earliestEpochOrLowestSeries
#' #### latestEpochOrHighestSeries
#' #### earliestAgeOrLowestStage
#' #### latestAgeOrHighestStage
#' #### lowestBiostratigraphicZone
#' #### highestBiostratigraphicZone
#' #### lithostratigraphicTerms
#' #### group
#' #### formation
#' #### member
#' #### bed
#' 
#' ---
#' 
#' #### identificationID
#' #### identificationQualifier
#' #### typeStatus
#' #### identifiedBy
#' #### dateIdentified
#' #### identificationReferences
#' #### identificationVerificationStatus
#' #### identificationRemarks
#' 
#' ---
#' 
#' #### taxonID
#' #### scientificNameID
#' #### acceptedNameUsageID
#' #### parentNameUsageID
#' #### originalNameUsageID
#' #### nameAccordingToID
#' #### namePublishedInID
#' #### taxonConceptID
#' #### scientificName
#' #### acceptedNameUsage
#' #### parentNameUsage
#' #### originalNameUsage
#' #### nameAccordingTo
#' #### namePublishedIn
#' #### namePublishedInYear
#' #### higherClassification
#' #### kingdom
#' #### phylum
#' #### class
#' #### order
#' #### family
#' #### genus
#' #### subgenus
#' #### specificEpithet
#' #### infraspecificEpithet
#' #### taxonRank
#' #### verbatimTaxonRank
#' #### scientificNameAuthorship
#' #### vernacularName 
#' #### nomenclaturalCode
#' #### taxonomicStatus
#' #### nomenclaturalStatus
#' #### taxonRemarks
#' 
#' ### Post-processing
#' 
