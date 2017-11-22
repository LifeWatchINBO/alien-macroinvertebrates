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
library(stringr)   # For string manipulation

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/denormalized_observations.csv"
dwc_occurrence_file = "../data/processed/dwc_occurrence/occurrence.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM", stringsAsFactors = F) 

#' Clean data somewhat: remove empty rows if present
raw_data %<>%  remove_empty_rows() 

#' Add prefix `raw_` to all column names, this to avoid name clashes with Darwin Core terms:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Save those column names as a vector (makes it easier to remove them all later):
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
occurrence %<>% mutate(language = "en")

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
#' 
#' Checking whether occurrenceID is a unique code (TRUE)
n_distinct(occurrence $ raw_taxon_occurrence_comment) == nrow(occurrence)

#' mapping:
occurrence %<>% mutate(occurrenceID = raw_taxon_occurrence_comment)

#' #### catalogNumber
#' #### recordNumber
#' #### recordedBy
#' 
#' give all unique name/group/organization records in raw_survey_event_comment (base column for recordedBy and identifiedBy)
occurrence %>% select (raw_survey_event_comment) %>%
  distinct(raw_survey_event_comment) %>%
  arrange (raw_survey_event_comment) %>%
  kable()

#' replace these records by a (list of) person(s), in the recommended best format for [recordedBy](https://terms.tdwg.org/wiki/dwc:recordedBy)  
occurrence %<>% mutate (
  recordedBy = recode (raw_survey_event_comment,
                       "2004_KreeftenBBICalc_Warmoes" = "Warmoes T", 
                       "VMM, 2004_KreeftenBBICalc_Warmoes" = " ",
                       "2004_niet_BBICacl - Warmoes" = " ",
                       "Claudio Salvo" = "Salvo C",
                       "D'udekem D'Acoz" = "d'Udekem d'Acoz",
                       "databank VMM" = "VMM",
                       "Dirk en Walda Hennebel" = "Hennebel D | Hennebel W",
                       "eigen data VMM" = "VMM",
                       "extra stalen" = "Boets P",
                       "Frank de Block-Burij" = "de Block-Burij F",
                       "Geert Vanloot" = "Vanloot G",
                       "Gérard" = "Gérard",
                       "Gérard, 1986" = "Gérard",
                       "Gunter Flipkens" = "Flipkens G",
                       "Hans de Blauwe" = "de Blauwe H",
                       "Herwig Mees" = "Mees H",
                       "IRSNB-Karel Wouters, 2002" = "Wouters K",
                       "Johan Auwerx" = "Auwerx J",
                       "Joost Mertens" = "Mertens J",
                       "Kobe Janssen" = "Janssen K",
                       "koen" = "Lock K",
                       "Koen Maes" = "Maes K",
                       "Leloup L." = "Leloup L",
                       "LIN - Belpaire - Cammaerts" = "Belpaire | Cammaerts",
                       "LISEC - Neven & Beckers" = "Neven | Beckers",
                       "Lot Hebbelinck" = "Hebbelinck L",
                       "Luc Van Assche" = "Van Assche L",
                       "Marjolein" = "Messiaen M",
                       "NULL" = "",
                       "Paul van sanden" = "Van Sanden P",
                       "Pieter Cox" = "Cox P",
                       "Pieter Van Dorsselaer" = "Van Dorsselaer P",
                       "Rik Clicque" = "Clicque R",
                       "Roeland Croket" = "Croket R",
                       "Thomas Gyselinck" = "Gyselinck T",
                       "Tom Van den Neucker" = "Van den Neucker T",
                       "Verslycke Tim" = "Verslycke T",
                       "VMM" = "VMM",
                       "VMM - Joost" = "Mertens J",
                       "VMM - Joost, 2004_KreeftenBBICalc_Warmoes" = "",
                       "VMM - Wim Gabriels" = "Gabriels W",
                       "VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes" = "Gabriels W",
                       "VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes, VMM - Joost" = "Gabriels W",
                       "waarnemingen" = "waarnemingen.be",
                       "waarnemingen - Dirk Hennebel" = "Hennebel D",
                       "waarnemingen - Hans de Blauwe" = "de Blauwe H",
                       "waarnemingen - Hans De Blauwe" = "de Blauwe H",
                       "Waarnemingen - Kevin Lambeets" = "Lambeets K",
                       "waarnemingen - Tom Van de Neucker" = "Van de Neucker T",
                       "Warmoes Thierry" = "Warmoes T",
                       "Wouters" = "Wouters K",
                       "Wouters, 2002" = "Wouters K",
                       "Xavier Vermeersch" = "Vermeersch X",
                       "zeehavens" = "Boets P",
                       .default = "",
                       .missing = ""))

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
occurrence %<>% mutate(otherCatalogNumbers = 
                         paste0("INBO:NBN:",raw_taxon_occurrence_key))

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
#'  Dates can be found both in `raw_sample_vague_date_start` and `raw_sample_vague_date_end`
#'  Both variables are imported in Rstudio as character vectors and need to be converted to an object of class "date".
occurrence %<>% 
  mutate(Date_start = as.Date (raw_sample_vague_date_start,"%Y-%m-%d")) %<>% 
  mutate(Date_end = as.Date (raw_sample_vague_date_end,"%Y-%m-%d")) 

#' `Date_start` and `Date_end`are not always identical: 
with (occurrence, identical(Date_start, Date_end))

#' Thus: dates will be expressed as: 
#' yyy-mm-dd when `Date_start` = `Date_end`
#' yyy-mm-dd / yy-mm-dd when `Date_start` != `Date_end`
#' 
#' creating new column `Date_interval`  when `Date_start` != `Date_end`
occurrence %<>% mutate(Date_interval = paste (Date_start, Date_end, sep ="/"))  

#' As it is unsure if GBIF can handle `/`in `EventDate`:
#' we always use `Date_start` for `eventDate`
#' when `Date_start` != `Date_end`, we use `Date_interval` for `verbatimEventDate` OR
#' when `Date_start` = `Date_end`, we define no value for `verbatimEventDate` 
#' 
#' EventDate:
occurrence %<>% mutate(eventDate = Date_start)

#' verbatimEventDate:
occurrence %<>% mutate (verbatimEventDate =
                          case_when (
                            raw_sample_vague_date_start == raw_sample_vague_date_end ~ "",
                            raw_sample_vague_date_start != raw_sample_vague_date_end ~ Date_interval
                          ))


#' Remove the `Date_start`, `Date_end` and `Date_interval` (only intermediate steps):
occurrence %<>% select (- c(Date_start, Date_end, Date_interval))

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
occurrence %<>% mutate(continent = "Europe")
  
#' #### waterBody
#' #### islandGroup
#' #### island
#' #### country
#' #### countryCode
occurrence %<>% mutate(countryCode = "BE")

#' #### stateProvince
#' #### county
#' #### municipality
occurrence %<>% mutate(municipality = raw_location_name_item_name)

#' #### locality
#' #### verbatimLocality
occurrence %<>% mutate(verbatimLocality = raw_survey_event_location_name)

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
occurrence %<>% 
  mutate (coordinate = str_replace (raw_sample_lat, ",", ".")) %>%  # Change "," to "."
  mutate (decimalLatitude = round (as.numeric(coordinate), 5)) %>%  # round to 5 decimals
  select (-coordinate)                                              # remove intermediary vector "coordinate"

#' #### decimalLongitude
occurrence %<>%
  mutate (coordinate = str_replace (raw_sample_long, ",", ".")) %<>%  # Change "," to "."
  mutate (decimalLongitude = round (as.numeric(coordinate), 5)) %<>%  # round to 5 decimals
  select (-coordinate)                                                # remove intermediary vector "coordinate"

#' #### geodeticDatum
occurrence %<>% mutate (geodeticDatum = "WGS84")

#' #### coordinateUncertaintyInMeters
#' #### coordinatePrecision
#' #### pointRadiusSpatialFit
#' #### verbatimCoordinates
#' #### verbatimLatitude
#' #### verbatimLongitude
#' #### verbatimCoordinateSystem
occurrence %<>% mutate(verbatimCoordinateSystem = "decimal degrees")

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
#' 
#' give all unique name/group/organization records in raw_survey_event_comment (base for recordedBy and identifiedBy)
occurrence %>% select (raw_survey_event_comment) %>%
  distinct(raw_survey_event_comment) %>%
  arrange (raw_survey_event_comment) %>%
  kable()

#' replace these records by a (list of) person(s), in the recommended best format for [identifiedBy](https://terms.tdwg.org/wiki/dwc:identifiedBy)  
occurrence %<>% mutate (
  identifiedBy = recode (raw_survey_event_comment,
                         "2004_KreeftenBBICalc_Warmoes" = "Warmoes T", 
                         "VMM, 2004_KreeftenBBICalc_Warmoes" = "",
                         "2004_niet_BBICacl - Warmoes" = "",
                         "Claudio Salvo" = "Salvo C",
                         "D'udekem D'Acoz" = "d'Udekem d'Acoz",
                         "databank VMM" = "Boets P",
                         "Dirk en Walda Hennebel" = "Hennebel D | Hennebel W",
                         "eigen data VMM" = "Boets P",
                         "extra stalen" = "Boets P",
                         "Frank de Block-Burij" = "de Block-Burij F",
                         "Geert Vanloot" = "Vanloot G",
                         "Gérard" = "Gérard",
                         "Gérard, 1986" = "Gérard",
                         "Gunter Flipkens" = "Flipkens G",
                         "Hans de Blauwe" = "de Blauwe H",
                         "Herwig Mees" = "Mees H",
                         "IRSNB-Karel Wouters, 2002" = "Wouters K",
                         "Johan Auwerx" = "Boets P",
                         "Joost Mertens" = "Mertens J",
                         "Kobe Janssen" = "Janssen K",
                         "koen" = "Lock K",
                         "Koen Maes" = "Maes K",
                         "Leloup L." = "Leloup L",
                         "LIN - Belpaire - Cammaerts" = "Belpaire | Cammaerts",
                         "LISEC - Neven & Beckers" = "Neven | Beckers",
                         "Lot Hebbelinck" = "Hebbelinck L",
                         "Luc Van Assche" = "Van Assche L",
                         "Marjolein" = "Messiaen M",
                         "NULL" = "",
                         "Paul van sanden" = "Van Sanden P",
                         "Pieter Cox" = "Cox P",
                         "Pieter Van Dorsselaer" = "Van Dorsselaer P",
                         "Rik Clicque" = "Clicque R",
                         "Roeland Croket" = "Croket R",
                         "Thomas Gyselinck" = "Gyselinck T",
                         "Tom Van den Neucker" = "Van den Neucker T",
                         "Verslycke Tim" = "Verslycke T",
                         "VMM" = "Boets P",
                         "VMM - Joost" = "Mertens J",
                         "VMM - Joost, 2004_KreeftenBBICalc_Warmoes" = "",
                         "VMM - Wim Gabriels" = "Gabriels W",
                         "VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes" = "Gabriels W",
                         "VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes, VMM - Joost" = "Gabriels W",
                         "waarnemingen" = "waarnemingen.be",
                         "waarnemingen - Dirk Hennebel" = "Hennebel D",
                         "waarnemingen - Hans de Blauwe" = "de Blauwe H",
                         "waarnemingen - Hans De Blauwe" = "de Blauwe H",
                         "Waarnemingen - Kevin Lambeets" = "Lambeets K",
                         "waarnemingen - Tom Van de Neucker" = "Van de Neucker T",
                         "Warmoes Thierry" = "Warmoes T",
                         "Wouters" = "Wouters K",
                         "Wouters, 2002" = "Wouters K",
                         "Xavier Vermeersch" = "Vermeersch X",
                         "zeehavens" = "Boets P",
                         .default = "",
                         .missing = ""))


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
#' 
#' Dreissena (Dreissena) polymorpha is the only scientific name with the subgenus mentioned in the name. This doesn't add much information and is removed (see [issue #9](https://github.com/trias-project/alien-macroinvertebrates/issues/9))
occurrence %<>% mutate (scientificName = 
                          case_when (
                            raw_nameserver_recommended_scientific_name == "Dreissena (Dreissena) polymorpha" ~ "Dreissena polymorpha",
                            raw_nameserver_recommended_scientific_name != "Dreissena (Dreissena) polymorpha" ~ raw_nameserver_recommended_scientific_name
                          ) )

#' #### acceptedNameUsage
#' #### parentNameUsage
#' #### originalNameUsage
#' #### nameAccordingTo
#' #### namePublishedIn
#' #### namePublishedInYear
#' #### higherClassification
#' #### kingdom
occurrence %<>% mutate (kingdom = "Animalia")

#' #### phylum
#' #### class
#' #### order
#' #### family
#' #### genus
#' #### subgenus
#' #### specificEpithet
#' #### infraspecificEpithet
#' #### taxonRank
#' 
#' raw_nameserver_recommended_name_rank contains two values: "Spp" and "SubSpp"
#' --> This should be "Species" and "Subspecies":
occurrence %<>% mutate (taxonRank = 
                          case_when (
                            raw_nameserver_recommended_name_rank == "Spp" ~ "species",
                            raw_nameserver_recommended_name_rank == "SubSpp" ~ "subspecies"
                          ) )

#' #### verbatimTaxonRank
#' #### scientificNameAuthorship
occurrence %<>% mutate (scientificNameAuthorship = raw_nameserver_recommended_name_authority)

#' #### vernacularName 
#' #### nomenclaturalCode
occurrence %<>% mutate (nomenclaturalCode = "ICZN")

#' #### taxonomicStatus
#' #### nomenclaturalStatus
#' #### taxonRemarks
#' 
#' ### Post-processing
#' 
#' Remove the original columns:
occurrence %<>% select(-one_of(raw_colnames))

#' Preview data:
kable(head(occurrence))

#' Save to CSV:
write.csv(occurrence, file = dwc_occurrence_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
