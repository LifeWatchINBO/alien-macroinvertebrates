# Darwin Core mapping

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-10-31

This document describes how we map the checklist data to Darwin Core.

## Setup




Set locale (so we use UTF-8 character encoding):


```r
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "English_Australia.1252")
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
raw_data_file = "../data/raw/alien_macroinvertebrates_occurrences.tsv"
```

## Read data

Read the source data:


```r
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", fileEncoding = "UTF-8-BOM") 
```

Clean data somewhat: remove empty rows if present


```r
raw_data %<>%  remove_empty_rows() 
```

Add prefix `raw_` to all column names. Although the column names already contain Darwin Core terms, new columns will have to be added between the current columns. To put all columns in the right order, it is easier to create new columns (some of them will be copies of the columns in the raw dataset) and then remove the columns of the raw occurrences dataset:


```r
colnames(raw_data) <- paste0("raw_", colnames(raw_data))
```

Preview data:


```r
kable(head(raw_data))
```



|raw_occurrenceID  |raw_recordedBy |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality | raw_verbatimLongitude| raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude|raw_geodeticDatum | raw_coordinateUncertaintyInMeters|raw_identifiedBy |raw_scientificName |raw_taxonRank |raw_scientificNameAuthorship |
|:-----------------|:--------------|:-------------------------|:-------------|:----------------|:--------------------|---------------------:|--------------------:|-------------------:|--------------------:|:-----------------|---------------------------------:|:----------------|:------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:1815 |T. Warmoes     |INBO:NBN:BFN0017900009QRS |2002-08-13    |Weert            |                     |                234845|               212540|            51.21656|              5.58311|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1831 |T. Warmoes     |INBO:NBN:BFN0017900009QRT |2003-06-04    |Dilsen-Stokkem   |                     |                246938|               191042|            51.02145|              5.75043|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1806 |T. Warmoes     |INBO:NBN:BFN0017900009QRW |2002-05-28    |Ham              |                     |                203772|               199046|            51.09901|              5.13642|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1808 |T. Warmoes     |INBO:NBN:BFN0017900009QRX |2002-06-03    |Lanaken          |                     |                238936|               175218|            50.88051|              5.63255|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1834 |T. Warmoes     |INBO:NBN:BFN0017900009QRZ |2003-06-18    |Lanaken          |                     |                242465|               176457|            50.89109|              5.68300|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1833 |T. Warmoes     |INBO:NBN:BFN0017900009QS0 |2003-06-18    |Lanaken          |                     |                242676|               177913|            50.90414|              5.68637|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |

## Create occurrence core


```r
occurrence <- raw_data
```

### Term mapping

Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):

#### type
#### modified
#### language
#### license
#### rightsHolder
#### accessRights
#### bibliographicCitation
#### references
#### institutionID
#### collectionID
#### datasetID
#### institutionCode
#### collectionCode
#### datasetName
#### ownerInstitutionCode
#### basisOfRecord
#### informationWithheld
#### dataGeneralizations
#### dynamicProperties

---

#### occurrenceID
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
#### waterBody
#### islandGroup
#### island
#### country
#### countryCode
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
