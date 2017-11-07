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



|raw_occurrenceID |raw_recordedBy              |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality                               |raw_verbatimLongitude | raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude| raw_coordinateUncertaintyInMeters|raw_identifiedBy            |raw_scientificName    |raw_taxonRank |raw_scientificNameAuthorship |
|:----------------|:---------------------------|:-------------------------|:-------------|:----------------|:--------------------------------------------------|:---------------------|--------------------:|-------------------:|--------------------:|---------------------------------:|:---------------------------|:---------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:2   |F. de Block-Burij           |INBO:NBN:BFN0017900009Z2W |2011-04-25    |Hoeleden         |De Pinte-Hageland                                  |50.862224N            |         5.015018e+00|            50.86222|              5.01502|                                30|F. de Block-Burij           |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:3   |waarnemingen - D. Hennebel  |INBO:NBN:BFN0017900009SZ3 |2009-02-26    |Linkebeek        |Linkebeek (Drève des Etangs)                       |147461.0              |         1.619600e+05|            50.76813|              4.33276|                                30|waarnemingen - D. Hennebel  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:4   |waarnemingen - H. de Blauwe |INBO:NBN:BFN0017900009SZ4 |2009-09-28    |Damme            |Damme (Damse Vaart)                                |74141.0               |         2.165490e+05|            51.25386|              3.28216|                                30|waarnemingen - H. de Blauwe |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:5   |Gérard                      |INBO:NBN:BFN0017900009Z2R |1985          |Brugge           |Damse vaart                                        |51.22617778N          |         3.214800e+00|            51.22618|              3.21480|                                30|Gérard                      |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:6   |Wouters K.                  |INBO:NBN:BFN0017900009Z34 |1985          |Hoeilaart        |Hoeilaart (Duboislaan)                             |50.765825N            |         4.432371e+00|            50.76582|              4.43237|                              3536|Wouters K.                  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:7   |D'udekem D'Acoz             |INBO:NBN:BFN0017900009Z2X |1985          |Oud-Heverlee     |Oud-Heverlee (Langerodestraat, hazenfonteinstraat) |50.845565N            |         4.665830e+00|            50.84557|              4.66583|                              3536|D'udekem D'Acoz             |Astacus leptodactylus |species       |Eschscholtz, 1823            |

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



|type  |language |license                                           |rightsHolder         |accessRights                             |datasetID                       |institutionCode |datasetName                                   |basisOfRecord    |occurrenceID   |recordedBy                  |otherCatalogNumbers       |eventDate  |verbatimEventDate |continent |countryCode |municipality |verbatimLocality                                   | decimalLatitude| decimalLongitude|geodeticDatum | coordinateUncertaintyInMeters| verbatimLatitude|verbatimLongitude |verbatimCoordinateSystem |verbatimSRS        |identifiedBy                |scientificName        |kingdom  |taxonRank |scientificNameAuthorship |nomenclaturalCode |
|:-----|:--------|:-------------------------------------------------|:--------------------|:----------------------------------------|:-------------------------------|:---------------|:---------------------------------------------|:----------------|:--------------|:---------------------------|:-------------------------|:----------|:-----------------|:---------|:-----------|:------------|:--------------------------------------------------|---------------:|----------------:|:-------------|-----------------------------:|----------------:|:-----------------|:------------------------|:------------------|:---------------------------|:---------------------|:--------|:---------|:------------------------|:-----------------|
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:2 |F. de Block-Burij           |INBO:NBN:BFN0017900009Z2W |2011-04-25 |2011-04-25        |Europe    |BE          |Hoeleden     |De Pinte-Hageland                                  |        50.86222|          5.01502|WGS84         |                            30|     5.015018e+00|50.862224N        |Belgium Lambert 72       |Belgium Datum 1972 |F. de Block-Burij           |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:3 |waarnemingen - D. Hennebel  |INBO:NBN:BFN0017900009SZ3 |2009-02-26 |2009-02-26        |Europe    |BE          |Linkebeek    |Linkebeek (Drève des Etangs)                       |        50.76813|          4.33276|WGS84         |                            30|     1.619600e+05|147461.0          |Belgium Lambert 72       |Belgium Datum 1972 |waarnemingen - D. Hennebel  |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:4 |waarnemingen - H. de Blauwe |INBO:NBN:BFN0017900009SZ4 |2009-09-28 |2009-09-28        |Europe    |BE          |Damme        |Damme (Damse Vaart)                                |        51.25386|          3.28216|WGS84         |                            30|     2.165490e+05|74141.0           |Belgium Lambert 72       |Belgium Datum 1972 |waarnemingen - H. de Blauwe |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:5 |Gérard                      |INBO:NBN:BFN0017900009Z2R |1985       |1985              |Europe    |BE          |Brugge       |Damse vaart                                        |        51.22618|          3.21480|WGS84         |                            30|     3.214800e+00|51.22617778N      |Belgium Lambert 72       |Belgium Datum 1972 |Gérard                      |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:6 |Wouters K.                  |INBO:NBN:BFN0017900009Z34 |1985       |1985              |Europe    |BE          |Hoeilaart    |Hoeilaart (Duboislaan)                             |        50.76582|          4.43237|WGS84         |                          3536|     4.432371e+00|50.765825N        |Belgium Lambert 72       |Belgium Datum 1972 |Wouters K.                  |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:7 |D'udekem D'Acoz             |INBO:NBN:BFN0017900009Z2X |1985       |1985              |Europe    |BE          |Oud-Heverlee |Oud-Heverlee (Langerodestraat, hazenfonteinstraat) |        50.84557|          4.66583|WGS84         |                          3536|     4.665830e+00|50.845565N        |Belgium Lambert 72       |Belgium Datum 1972 |D'udekem D'Acoz             |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |

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
