#' # Darwin Core mapping
#' 
#' Peter Desmet, Quentin Groom, Lien Reyserhove
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
#' Map the source data to [Darwin Core Occurence](http://rs.gbif.org/core/dwc_occurrence.xml):
#' 
#' #### eventID
#' #### samplingProtocol
#' #### samplingEffort
#' #### eventDate
#' #### eventTime
#' #### startDayOfYear
#' #### endDayofYear
#' #### year
#' #### month
#' #### day
#' #### verbatimEventDate
#' #### hatbitat
#' #### fieldNumber
#' #### fieldNotes
#' #### eventRemarks
#' #### geologicalContextID
#' #### earliestEonOrLowestEonothem
#' #### latestEonOrHighestEonothem
#' #### earliestEraOrLowestErathem
#' #### latestEraOrHighestErathem
#' #### earliestPeriodOrLowestSystem
#' #### latestPeriodOrHighestSystem
#' #### earliestEpochOrLowestSeries
#' #### latestAgeOrHighestStage
#' #### lowestBiostratigraphicZone
#' #### highestBiostratigraphicZone
#' #### lithostratigraphicTerms
#' #### group
#' #### formation
#' #### member
#' #### bed
#' #### identificationID
#' #### identifiedBy
#' #### dateIdentified
#' #### identificationReferences	
#' #### identificationRemarks
#' #### identificationQualifier
#' #### identificationVerificationStatus	
#' #### typeStatus
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
#' #### verbatimElevation
#' #### minimumElevationInMeters
#' #### maximumElevationInMeters
#' #### verbatimDepth
#' #### minimumDepthInMeters
#' #### maximumDepthInMeters
#' #### minimumDistanceAboveSurfaceInMeters
#' #### maximumDistanceAboveSurfaceInMeters
#' #### locationAccordingTo
#' #### locationRemarks	
#' #### verbatimCoordinates
#' #### verbatimLatitude
#' #### verbatimLongitude
#' #### verbatimCoordinateSystem
#' #### verbatimSRS
#' #### decimalLatitude
#' #### decimalLongitude
#' #### geodeticDatum
#' #### coordinateUncertaintyInMeters
#' #### coordinatePrecision
#' #### pointRadiusSpatialFit
#' #### footprintWKT
#' #### footprintSRS
#' #### footprintSpatialFit
#' #### georeferencedBy
#' #### georeferencedDate
#' #### georeferenceProtocol
#' #### georeferenceSources
#' #### georeferenceVerificationStatus
#' #### georeferenceRemarks
#' #### materialSampleID
#' #### occurrenceID
#' #### catalogNumber
#' #### occurrenceRemarks
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
#' #### otherCatalogNumbers
#' #### associatedMedia
#' #### associatedReferences
#' #### associatedSequences
#' #### associatedTaxa
#' #### organismID
#' #### organismName
#' #### organismScope
#' #### associatedOccurrences
#' #### associatedOrganisms
#' #### previousIdentifications
#' #### organismRemarks
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
