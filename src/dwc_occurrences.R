#' # Darwin Core mapping
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
Sys.setlocale("LC_CTYPE", "English_Australia.1252")

#' Load libraries:
library(tidyverse) # For data transformations

# None core tidyverse packages:
library(magrittr)  # For %<>% pipes

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/alien_macroinvertebrates_occurrences.tsv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM") 

#' Clean data somewhat: remove empty rows if present
raw_data %<>%  remove_empty_rows() 

#' Add prefix `raw_` to all column names. Although the column names already contain Darwin Core terms, new columns will have to be added between the current columns. To put all columns in the right order, it is easier to create new columns (some of them will be copies of the columns in the raw dataset) and then remove the columns of the raw occurrences dataset:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Preview data:
kable(head(raw_data))

#' ## Create occurrence core
occurrence <- raw_data

#' ### Term mapping
#' 
#' Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):
#' 
#' #### type
#' #### modified
#' #### language
#' #### license
#' #### rightsHolder
#' #### accessRights
#' #### bibliographicCitation
#' #### references
#' #### institutionID
#' #### collectionID
#' #### datasetID
#' #### institutionCode
#' #### collectionCode
#' #### datasetName
#' #### ownerInstitutionCode
#' #### basisOfRecord
#' #### informationWithheld
#' #### dataGeneralizations
#' #### dynamicProperties
#' 
#' ---
#' 
#' #### occurrenceID
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
