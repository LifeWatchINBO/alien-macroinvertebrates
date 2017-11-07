# Darwin Core mapping for checklist dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-07

This document describes how we map the checklist data to Darwin Core.

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
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
dwc_distribution_file = "../data/processed/dwc_checklist/distribution.csv"
dwc_description_file = "../data/processed/dwc_checklist/description.csv"
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

## Group by species

Group the occurrence data as species data (= one record for each scientific name):


```r
raw_species <- raw_data # replace by dplyr groupby on taxonID, scientificName, taxonRank and scientificNameAuthorship
```

Order by raw_taxonID:


```r
# raw_species %<>% arrange(raw_taxonID)
```

Save the raw column names as a list (makes it easier to remove them all later):


```r
raw_colnames <- colnames(raw_species)
```

Preview data:


```r
kable(head(raw_species))
```



|raw_occurrenceID  |raw_recordedBy |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality |raw_verbatimLongitude | raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude|raw_geodeticDatum | raw_coordinateUncertaintyInMeters|raw_identifiedBy |raw_scientificName |raw_taxonRank |raw_scientificNameAuthorship |
|:-----------------|:--------------|:-------------------------|:-------------|:----------------|:--------------------|:---------------------|--------------------:|-------------------:|--------------------:|:-----------------|---------------------------------:|:----------------|:------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:1815 |T. Warmoes     |INBO:NBN:BFN0017900009QRS |2002-08-13    |Weert            |                     |234845.0              |               212540|            51.21656|              5.58311|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1831 |T. Warmoes     |INBO:NBN:BFN0017900009QRT |2003-06-04    |Dilsen-Stokkem   |                     |246938.0              |               191042|            51.02145|              5.75043|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1806 |T. Warmoes     |INBO:NBN:BFN0017900009QRW |2002-05-28    |Ham              |                     |203772.0              |               199046|            51.09901|              5.13642|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1808 |T. Warmoes     |INBO:NBN:BFN0017900009QRX |2002-06-03    |Lanaken          |                     |238936.0              |               175218|            50.88051|              5.63255|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1834 |T. Warmoes     |INBO:NBN:BFN0017900009QRZ |2003-06-18    |Lanaken          |                     |242465.0              |               176457|            50.89109|              5.68300|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |
|PB:Ugent:AqE:1833 |T. Warmoes     |INBO:NBN:BFN0017900009QS0 |2003-06-18    |Lanaken          |                     |242676.0              |               177913|            50.90414|              5.68637|WGS84             |                                30|T. Warmoes       |Orconectes limosus |species       |(Rafinesque, 1817)           |

## Create taxon core


```r
taxon <- raw_species
```

### Term mapping

Map the source data to [Darwin Core Taxon](http://rs.gbif.org/core/dwc_taxon_2015-04-24.xml):

#### modified
#### language


```r
taxon %<>% mutate(language = "en")
```

#### license


```r
taxon %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
```

#### rightsHolder


```r
taxon %<>% mutate(rightsHolder = "Ugent; Aquatic ecolo")
```

#### accessRights


```r
taxon %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")
```

#### bibliographicCitation
#### informationWithheld
#### datasetID


```r
taxon %<>% mutate(datasetID = "")
```

#### datasetName


```r
taxon %<>% mutate(datasetName = "Alien macroinvertebrates checklist for Flanders, Belgium")
```

#### references
#### taxonID


```r
taxon %<>% mutate(taxonID = "") # Should be taken from source
```

#### scientificNameID
#### acceptedNameUsageID
#### parentNameUsageID
#### originalNameUsageID
#### nameAccordingToID
#### namePublishedInID
#### taxonConceptID
#### scientificName


```r
taxon %<>% mutate(scientificName = raw_scientificName)
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
taxon %<>% mutate(kingdom = "Animalia")
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
taxon %<>% mutate(taxonRank = raw_taxonRank)
```

#### verbatimTaxonRank
#### scientificNameAuthorship


```r
taxon %<>% mutate(scientificNameAuthorship = raw_scientificNameAuthorship)
```

#### vernacularName
#### nomenclaturalCode


```r
taxon %<>% mutate(nomenclaturalCode = "ICZN")
```

#### taxonomicStatus
#### nomenclaturalStatus
#### taxonRemarks

### Post-processing

Remove the original columns:


```r
taxon %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
kable(head(taxon))
```



|language |license                                           |rightsHolder         |accessRights                             |datasetID |datasetName                                              |taxonID |scientificName     |kingdom  |taxonRank |scientificNameAuthorship |nomenclaturalCode |
|:--------|:-------------------------------------------------|:--------------------|:----------------------------------------|:---------|:--------------------------------------------------------|:-------|:------------------|:--------|:---------|:------------------------|:-----------------|
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Orconectes limosus |Animalia |species   |(Rafinesque, 1817)       |ICZN              |

Save to CSV:


```r
write.csv(taxon, file = dwc_taxon_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Create distribution extension

### Pre-processing


```r
distribution <- raw_species
```

### Term mapping
#### id


```r
distribution %<>% mutate(id = "")
```

#### locationID


```r
distribution %<>% mutate(locationID = "ISO_3166-2:BE-VLG")
```

#### locality


```r
distribution %<>% mutate(locality = "Flanders")
```

#### countryCode


```r
distribution %<>% mutate(countryCode = "BE")
```

#### lifeStage
#### occurrenceStatus


```r
distribution %<>% mutate(occurrenceStatus = "present")
```

#### threatStatus
#### establishmentMeans
#### appendixCITES
#### eventDate
#### startDayOfYear
#### endDayOfYear
#### source
#### occurrenceRemarks
#### datasetID
### Post-processing

Remove the original columns:


```r
distribution %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
kable(head(distribution))
```



|id |locationID        |locality |countryCode |occurrenceStatus |
|:--|:-----------------|:--------|:-----------|:----------------|
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |
|   |ISO_3166-2:BE-VLG |Flanders |BE          |present          |

Save to CSV:


```r
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Summary

### Number of records

* Source file: 2856
* Taxon core: 2856
* Distribution extension: 2856
* Description extension: `TODO`

### Taxon core

Number of duplicates: 2 (should be 0)

The following numbers are expected to be the same:

* Number of records: 2856
* Number of distinct `taxonID`: 1
* Number of distinct `scientificName`: 42
