# Darwin Core mapping for occurrence dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-14

This document describes how we map the occurrence data to Darwin Core.

## Setup




Set locale (so we use UTF-8 character encoding):


```r
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
```

```
## [1] ""
```

Load libraries:


```r
library(tidyverse) # For data transformations

# None core tidyverse packages:
library(magrittr)  # For %<>% pipes

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
```

Set file paths (all paths should be relative to this script):


```r
raw_data_file = "../data/raw/denormalized_observations.csv"
dwc_occurrence_file = "../data/processed/dwc_occurrence/occurrence.csv"
```

## Read data

Read the source data:


```r
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM", stringsAsFactors = F) 
```

Clean data somewhat: remove empty rows if present


```r
raw_data %<>%  remove_empty_rows() 
```

Add prefix `raw_` to all column names. Although the column names already contain Darwin Core terms, new columns will have to be added between the current columns. To put all columns in the right order, it is easier to create new columns (some of them will be copies of the columns in the raw dataset) and then remove the columns of the raw occurrence dataset:


```r
colnames(raw_data) <- paste0("raw_", colnames(raw_data))
```

Save those column names as a list (makes it easier to remove them all later):


```r
raw_colnames <- colnames(raw_data)
```

Preview data:


```r
kable(head(raw_data))
```



|raw_taxon_occurrence_key |raw_taxon_occurrence_comment |raw_nameserver_recommended_scientific_name |raw_nameserver_recommended_name_authority |raw_nameserver_recommended_name_rank |raw_sample_vague_date_start |raw_sample_vague_date_end |raw_sample_vague_date_type |raw_survey_event_comment |raw_location_name_item_name |raw_survey_event_location_name                               |raw_sample_lat   |raw_sample_long  |raw_sample_spatial_ref |raw_sample_spatial_ref_system |raw_sample_spatial_ref_qualifier |
|:------------------------|:----------------------------|:------------------------------------------|:-----------------------------------------|:------------------------------------|:---------------------------|:-------------------------|:--------------------------|:------------------------|:---------------------------|:------------------------------------------------------------|:----------------|:----------------|:----------------------|:-----------------------------|:--------------------------------|
|BFN0017900009RTD         |PB:Ugent:AqE:2706            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |2001-05-18 00:00:00.000     |2001-05-18 00:00:00.000   |D                          |eigen data VMM           |Sint-Gillis-Waas            |Wlp: Maatbeek-De Linie, De Klinge, Rode Moerpolder, opw brug |51,2493067145728 |4,10541780302292 |131613.0,215521.0      |BD72                          |Imported                         |
|BFN0017900009RTO         |PB:Ugent:AqE:2711            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |1999-06-10 00:00:00.000     |1999-06-10 00:00:00.000   |D                          |eigen data VMM           |Sint-Gillis-Waas            |De Klinge, afw St. Gillisbroekpolder, opw weg                |51,2374250902656 |4,12700536600239 |133116.0,214194.0      |BD72                          |Imported                         |
|BFN0017900009RV3         |PB:Ugent:AqE:2750            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |2005-09-29 00:00:00.000     |2005-09-29 00:00:00.000   |D                          |eigen data VMM           |Sint-Laureins               |St-Jan-in-Eremo, Zonnestraat, Zuidzijde                      |51,2560396558302 |3,57535960263105 |94612.0,216533.0       |BD72                          |Imported                         |
|BFN0017900009SF7         |PB:Ugent:AqE:2716            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |2002-08-11 00:00:00.000     |2002-08-11 00:00:00.000   |D                          |eigen data VMM           |Beveren (Beveren)           |Verrebroek, Duikeldamse Dijk, afw brug                       |51,2414829501799 |4,16776684064578 |135964.0,214637.0      |BD72                          |Imported                         |
|BFN0017900009SMZ         |PB:Ugent:AqE:2741            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |1999-06-25 00:00:00.000     |1999-06-25 00:00:00.000   |D                          |eigen data VMM           |Zonnebeke                   |Mispelarestraat                                              |50,8727871787077 |3,02208697062554 |55218.0,174460.0       |BD72                          |Imported                         |
|BFN0017900009QYG         |PB:Ugent:AqE:2701            |Proasellus coxalis                         |(Dollfus, 1892)                           |Spp                                  |2003-08-21 00:00:00.000     |2003-08-21 00:00:00.000   |D                          |eigen data VMM           |Terneuzen                   |Mosselhuisstraat, Grenspaal 314                              |51,2561139824236 |3,79550073079471 |109980.0,216400.0      |BD72                          |Imported                         |

## Create occurrence core

### Pre-processing


```r
occurrence <- raw_data
```

### Term mapping

Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):

#### type


```r
occurrence %<>% mutate(type = "Event")
```

#### modified
#### language


```r
occurrence %<>% mutate(language ="en")
```

#### license


```r
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0")
```

#### rightsHolder


```r
occurrence %<>% mutate(rightsHolder = "Ghent University")
```

#### accessRights


```r
occurrence %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")
```

#### bibliographicCitation
#### references
#### institutionID
#### collectionID
#### datasetID


```r
occurrence %<>% mutate(datasetID = "https://doi.org/10.15468/xjtfoo")
```

#### institutionCode


```r
occurrence %<>% mutate(institutionCode = "INBO")
```

#### collectionCode
#### datasetName


```r
occurrence %<>% mutate(datasetName = "Alien macroinvertebrates in Flanders, Belgium")
```

#### ownerInstitutionCode
#### basisOfRecord


```r
occurrence %<>% mutate(basisOfRecord = "HumanObservation")
```

#### informationWithheld
#### dataGeneralizations
#### dynamicProperties

---

#### occurrenceID


```r
n_distinct(occurrence $ raw_taxon_occurrence_comment)  # Checking whether occurrenceID is a unique code
```

```
## [1] 2856
```

```r
occurrence %<>% mutate(occurrenceID = raw_taxon_occurrence_comment)
```

#### catalogNumber
#### recordNumber
#### recordedBy
#### individualCount
#### organismQuantity
#### organismQuantityType
#### sex
#### lifeStage
#### reproductiveCondition
#### behavior
#### establishmentMeans
#### occurrenceStatus
#### preparations
#### disposition
#### associatedMedia
#### associatedReferences
#### associatedSequences
#### associatedTaxa
#### otherCatalogNumbers


```r
occurrence %<>% mutate(otherCatalogNumbers = raw_taxon_occurrence_key)
```

#### occurrenceRemarks

---

#### organismID
#### organismName
#### organismScope
#### associatedOccurrences
#### associatedOrganisms
#### previousIdentifications
#### organismRemarks

---

#### materialSampleID

---

#### eventID
#### parentEventID
#### fieldNumber
#### eventDate

`eventDate` data can be found both in `raw_sample_vague_date_start` and `raw_sample_vague_date_end`
 Both variables are imported as character vectors and need to be converted to an object of class "date".


```r
occurrence %<>% 
  mutate(eventDate_start = as.Date (raw_sample_vague_date_start,"%Y-%m-%d")) %<>% 
  mutate(eventDate_end = as.Date (raw_sample_vague_date_end,"%Y-%m-%d")) 
```

`eventDate_start` and `eventDate_end`are not always identical: 


```r
with (occurrence, identical(eventDate_start, eventDate_end))
```

```
## [1] FALSE
```

Thus: `eventDate`` will be expressed as: 
yyy-mm-dd when `eventDate_start` = `eventDate_end`
yyy-mm-dd / yy-mm-dd when `eventDate_start` != `eventDate_end`
new column `eventDate_interval` for when `eventDate_start` != `eventDate_end`


```r
occurrence %<>% mutate(eventDate_interval = paste (eventDate_start, eventDate_end, sep ="/"))  
```

Create `eventDate`, which contains `eventDate_start` when `eventDate_start` = `eventDate_end`, or else `eventDate_interval` when `eventDate_start` != `eventDate_end`


```r
occurrence %<>% mutate (eventDate =
           case_when (
             raw_sample_vague_date_start == raw_sample_vague_date_end ~ as.character (eventDate_start),
             raw_sample_vague_date_start != raw_sample_vague_date_end ~ eventDate_interval
           ))
```

Remove the extra columns:


```r
occurrence %<>% select (- c(eventDate_start, eventDate_end, eventDate_interval))
```

#### eventTime
#### startDayOfYear
#### endDayOfYear
#### year
#### month
#### day
#### verbatimEventDate
#### habitat
#### samplingProtocol
#### sampleSizeValue
#### sampleSizeUnit
#### samplingEffort
#### fieldNotes
#### eventRemarks

---

#### locationID
#### higherGeographyID
#### higherGeography
#### continent


```r
occurrence %<>% mutate(continent = "Europe")
```

#### waterBody
#### islandGroup
#### island
#### country
#### countryCode


```r
occurrence %<>% mutate(countryCode = "BE")
```

#### stateProvince
#### county
#### municipality
#### locality
#### verbatimLocality
#### minimumElevationInMeters
#### maximumElevationInMeters
#### verbatimElevation
#### minimumDepthInMeters
#### maximumDepthInMeters
#### verbatimDepth
#### minimumDistanceAboveSurfaceInMeters
#### maximumDistanceAboveSurfaceInMeters
#### locationAccordingTo
#### locationRemarks
#### decimalLatitude
#### decimalLongitude
#### geodeticDatum
#### coordinateUncertaintyInMeters
#### coordinatePrecision
#### pointRadiusSpatialFit
#### verbatimCoordinates
#### verbatimLatitude
#### verbatimLongitude
#### verbatimCoordinateSystem
#### verbatimSRS
#### footprintWKT
#### footprintSRS
#### footprintSpatialFit
#### georeferencedBy
#### georeferencedDate
#### georeferenceProtocol
#### georeferenceSources
#### georeferenceVerificationStatus
#### georeferenceRemarks

---

#### geologicalContextID
#### earliestEonOrLowestEonothem
#### latestEonOrHighestEonothem
#### earliestEraOrLowestErathem
#### latestEraOrHighestErathem
#### earliestPeriodOrLowestSystem
#### latestPeriodOrHighestSystem
#### earliestEpochOrLowestSeries
#### latestEpochOrHighestSeries
#### earliestAgeOrLowestStage
#### latestAgeOrHighestStage
#### lowestBiostratigraphicZone
#### highestBiostratigraphicZone
#### lithostratigraphicTerms
#### group
#### formation
#### member
#### bed

---

#### identificationID
#### identificationQualifier
#### typeStatus
#### identifiedBy
#### dateIdentified
#### identificationReferences
#### identificationVerificationStatus
#### identificationRemarks

---

#### taxonID
#### scientificNameID
#### acceptedNameUsageID
#### parentNameUsageID
#### originalNameUsageID
#### nameAccordingToID
#### namePublishedInID
#### taxonConceptID
#### scientificName
#### acceptedNameUsage
#### parentNameUsage
#### originalNameUsage
#### nameAccordingTo
#### namePublishedIn
#### namePublishedInYear
#### higherClassification
#### kingdom
#### phylum
#### class
#### order
#### family
#### genus
#### subgenus
#### specificEpithet
#### infraspecificEpithet
#### taxonRank
#### verbatimTaxonRank
#### scientificNameAuthorship
#### vernacularName 
#### nomenclaturalCode
#### taxonomicStatus
#### nomenclaturalStatus
#### taxonRemarks

### Post-processing

