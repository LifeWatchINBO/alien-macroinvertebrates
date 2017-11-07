# Darwin Core mapping for occurrence dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-07

This document describes how we map the occurrence data to Darwin Core.

## Setup




Set locale (so we use UTF-8 character encoding):


```r
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
```

```
## [1] "en_US.UTF-8"
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
dwc_occurrence_file = "../data/processed/dwc_occurrence/occurrence.csv"
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



|raw_occurrenceID  |raw_recordedBy |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality |raw_verbatimLongitude | raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude|raw_geodeticDatum | raw_coordinateUncertaintyInMeters|raw_identifiedBy |raw_scientificName |raw_taxonRank |raw_scientificNameAuthorship |
|:-----------------|:--------------|:-------------------------|:-------------|:----------------|:--------------------|:---------------------|--------------------:|-------------------:|--------------------:|:-----------------|---------------------------------:|:----------------|:------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:1815 |T. Warmoes     |INBO:NBN:BFN0017900009QRS |2002-08-13    |Weert            |                     |234845.0              |               212540|            51.21656|              5.58311|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1831 |T. Warmoes     |INBO:NBN:BFN0017900009QRT |2003-06-04    |Dilsen-Stokkem   |                     |246938.0              |               191042|            51.02145|              5.75043|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1806 |T. Warmoes     |INBO:NBN:BFN0017900009QRW |2002-05-28    |Ham              |                     |203772.0              |               199046|            51.09901|              5.13642|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1808 |T. Warmoes     |INBO:NBN:BFN0017900009QRX |2002-06-03    |Lanaken          |                     |238936.0              |               175218|            50.88051|              5.63255|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1834 |T. Warmoes     |INBO:NBN:BFN0017900009QRZ |2003-06-18    |Lanaken          |                     |242465.0              |               176457|            50.89109|              5.68300|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1833 |T. Warmoes     |INBO:NBN:BFN0017900009QS0 |2003-06-18    |Lanaken          |                     |242676.0              |               177913|            50.90414|              5.68637|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |

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
occurrence %<>% mutate(language = "en")
```

#### license


```r
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
```

#### rightsHolder


```r
occurrence %<>% mutate(rightsHolder = "Ugent; Aquatic ecolo")
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
occurrence %<>% mutate(occurrenceID = raw_occurrenceID)
```

#### catalogNumber
#### recordNumber
#### recordedBy


```r
occurrence %<>% mutate(recordedBy = raw_recordedBy)
```

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
occurrence %<>% mutate(otherCatalogNumbers = raw_otherCatalogNumbers)
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


```r
occurrence %<>% mutate(eventDate = raw_eventDate)
```

#### eventTime
#### startDayOfYear
#### endDayOfYear
#### year
#### month
#### day
#### verbatimEventDate


```r
occurrence %<>% mutate(verbatimEventDate = raw_eventDate)
```

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


```r
occurrence %<>% mutate(municipality = raw_municipality)
```

#### locality
#### verbatimLocality


```r
occurrence %<>% mutate(verbatimLocality = raw_verbatimLocality)
```

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


```r
occurrence %<>% mutate(decimalLatitude = raw_decimalLatitude)
```

#### decimalLongitude


```r
occurrence %<>% mutate(decimalLongitude = raw_decimalLongitude)
```

#### geodeticDatum


```r
occurrence %<>% mutate(geodeticDatum = "WGS84")
```

#### coordinateUncertaintyInMeters


```r
occurrence %<>% mutate(coordinateUncertaintyInMeters = raw_coordinateUncertaintyInMeters)
```

#### coordinatePrecision
#### pointRadiusSpatialFit
#### verbatimCoordinates
#### verbatimLatitude


```r
occurrence %<>% mutate(verbatimLatitude = raw_verbatimLatitude)
```

#### verbatimLongitude


```r
occurrence %<>% mutate(verbatimLongitude = raw_verbatimLongitude)
```

#### verbatimCoordinateSystem


```r
occurrence %<>% mutate(verbatimCoordinateSystem = "Belgium Lambert 72")
```

#### verbatimSRS


```r
occurrence %<>% mutate(verbatimSRS = "Belgium Datum 1972")
```

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


```r
occurrence %<>% mutate(identifiedBy = raw_identifiedBy)
```

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


```r
occurrence %<>% mutate(scientificName = raw_scientificName)
```

#### acceptedNameUsage
#### parentNameUsage
#### originalNameUsage
#### nameAccordingTo
#### namePublishedIn
#### namePublishedInYear
#### higherClassification
#### kingdom


```r
occurrence %<>% mutate(kingdom = "Animalia")
```

#### phylum
#### class
#### order
#### family
#### genus
#### subgenus
#### specificEpithet
#### infraspecificEpithet
#### taxonRank


```r
occurrence %<>% mutate(taxonRank = raw_taxonRank)
```

#### verbatimTaxonRank
#### scientificNameAuthorship


```r
occurrence %<>% mutate(scientificNameAuthorship = raw_scientificNameAuthorship)
```

#### vernacularName 
#### nomenclaturalCode


```r
occurrence %<>% mutate(nomenclaturalCode = "ICZN")
```

#### taxonomicStatus
#### nomenclaturalStatus
#### taxonRemarks

### Post-processing

Remove the original columns:


```r
occurrence %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
kable(head(occurrence))
```



|type  |language |license                                           |rightsHolder         |accessRights                             |datasetID                       |institutionCode |datasetName                                   |basisOfRecord    |occurrenceID      |recordedBy |otherCatalogNumbers       |eventDate  |verbatimEventDate |continent |countryCode |municipality   |verbatimLocality | decimalLatitude| decimalLongitude|geodeticDatum | coordinateUncertaintyInMeters| verbatimLatitude|verbatimLongitude |verbatimCoordinateSystem |verbatimSRS        |identifiedBy |scientificName     |kingdom  |taxonRank |scientificNameAuthorship |nomenclaturalCode |
|:-----|:--------|:-------------------------------------------------|:--------------------|:----------------------------------------|:-------------------------------|:---------------|:---------------------------------------------|:----------------|:-----------------|:----------|:-------------------------|:----------|:-----------------|:---------|:-----------|:--------------|:----------------|---------------:|----------------:|:-------------|-----------------------------:|----------------:|:-----------------|:------------------------|:------------------|:------------|:------------------|:--------|:---------|:------------------------|:-----------------|
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1815 |T. Warmoes |INBO:NBN:BFN0017900009QRS |2002-08-13 |2002-08-13        |Europe    |BE          |Weert          |                 |        51.21656|          5.58311|WGS84         |                            30|           212540|234845.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1831 |T. Warmoes |INBO:NBN:BFN0017900009QRT |2003-06-04 |2003-06-04        |Europe    |BE          |Dilsen-Stokkem |                 |        51.02145|          5.75043|WGS84         |                            30|           191042|246938.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1806 |T. Warmoes |INBO:NBN:BFN0017900009QRW |2002-05-28 |2002-05-28        |Europe    |BE          |Ham            |                 |        51.09901|          5.13642|WGS84         |                            30|           199046|203772.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1808 |T. Warmoes |INBO:NBN:BFN0017900009QRX |2002-06-03 |2002-06-03        |Europe    |BE          |Lanaken        |                 |        50.88051|          5.63255|WGS84         |                            30|           175218|238936.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1834 |T. Warmoes |INBO:NBN:BFN0017900009QRZ |2003-06-18 |2003-06-18        |Europe    |BE          |Lanaken        |                 |        50.89109|          5.68300|WGS84         |                            30|           176457|242465.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1833 |T. Warmoes |INBO:NBN:BFN0017900009QS0 |2003-06-18 |2003-06-18        |Europe    |BE          |Lanaken        |                 |        50.90414|          5.68637|WGS84         |                            30|           177913|242676.0          |Belgium Lambert 72       |Belgium Datum 1972 |T. Warmoes   |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |

Save to CSV:


```r
write.csv(occurrence, file = dwc_occurrence_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Summary

### Number of records

* Source file: 2856
* Occurrence core: 2856

### Occurrence core

Number of duplicates: 0 (should be 0)

The following numbers are expected to be the same:

* Number of records: 2856
* Number of distinct `occurrenceID`: 2856
