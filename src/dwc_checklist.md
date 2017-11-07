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



|raw_occurrenceID |raw_recordedBy              |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality                               |raw_verbatimLongitude | raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude| raw_coordinateUncertaintyInMeters|raw_identifiedBy            |raw_scientificName    |raw_taxonRank |raw_scientificNameAuthorship |
|:----------------|:---------------------------|:-------------------------|:-------------|:----------------|:--------------------------------------------------|:---------------------|--------------------:|-------------------:|--------------------:|---------------------------------:|:---------------------------|:---------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:2   |F. de Block-Burij           |INBO:NBN:BFN0017900009Z2W |2011-04-25    |Hoeleden         |De Pinte-Hageland                                  |50.862224N            |         5.015018e+00|            50.86222|              5.01502|                                30|F. de Block-Burij           |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:3   |waarnemingen - D. Hennebel  |INBO:NBN:BFN0017900009SZ3 |2009-02-26    |Linkebeek        |Linkebeek (Drève des Etangs)                       |147461.0              |         1.619600e+05|            50.76813|              4.33276|                                30|waarnemingen - D. Hennebel  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:4   |waarnemingen - H. de Blauwe |INBO:NBN:BFN0017900009SZ4 |2009-09-28    |Damme            |Damme (Damse Vaart)                                |74141.0               |         2.165490e+05|            51.25386|              3.28216|                                30|waarnemingen - H. de Blauwe |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:5   |Gérard                      |INBO:NBN:BFN0017900009Z2R |1985          |Brugge           |Damse vaart                                        |51.22617778N          |         3.214800e+00|            51.22618|              3.21480|                                30|Gérard                      |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:6   |Wouters K.                  |INBO:NBN:BFN0017900009Z34 |1985          |Hoeilaart        |Hoeilaart (Duboislaan)                             |50.765825N            |         4.432371e+00|            50.76582|              4.43237|                              3536|Wouters K.                  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:7   |D'udekem D'Acoz             |INBO:NBN:BFN0017900009Z2X |1985          |Oud-Heverlee     |Oud-Heverlee (Langerodestraat, hazenfonteinstraat) |50.845565N            |         4.665830e+00|            50.84557|              4.66583|                              3536|D'udekem D'Acoz             |Astacus leptodactylus |species       |Eschscholtz, 1823            |

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



|raw_occurrenceID |raw_recordedBy              |raw_otherCatalogNumbers   |raw_eventDate |raw_municipality |raw_verbatimLocality                               |raw_verbatimLongitude | raw_verbatimLatitude| raw_decimalLatitude| raw_decimalLongitude| raw_coordinateUncertaintyInMeters|raw_identifiedBy            |raw_scientificName    |raw_taxonRank |raw_scientificNameAuthorship |
|:----------------|:---------------------------|:-------------------------|:-------------|:----------------|:--------------------------------------------------|:---------------------|--------------------:|-------------------:|--------------------:|---------------------------------:|:---------------------------|:---------------------|:-------------|:----------------------------|
|PB:Ugent:AqE:2   |F. de Block-Burij           |INBO:NBN:BFN0017900009Z2W |2011-04-25    |Hoeleden         |De Pinte-Hageland                                  |50.862224N            |         5.015018e+00|            50.86222|              5.01502|                                30|F. de Block-Burij           |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:3   |waarnemingen - D. Hennebel  |INBO:NBN:BFN0017900009SZ3 |2009-02-26    |Linkebeek        |Linkebeek (Drève des Etangs)                       |147461.0              |         1.619600e+05|            50.76813|              4.33276|                                30|waarnemingen - D. Hennebel  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:4   |waarnemingen - H. de Blauwe |INBO:NBN:BFN0017900009SZ4 |2009-09-28    |Damme            |Damme (Damse Vaart)                                |74141.0               |         2.165490e+05|            51.25386|              3.28216|                                30|waarnemingen - H. de Blauwe |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:5   |Gérard                      |INBO:NBN:BFN0017900009Z2R |1985          |Brugge           |Damse vaart                                        |51.22617778N          |         3.214800e+00|            51.22618|              3.21480|                                30|Gérard                      |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:6   |Wouters K.                  |INBO:NBN:BFN0017900009Z34 |1985          |Hoeilaart        |Hoeilaart (Duboislaan)                             |50.765825N            |         4.432371e+00|            50.76582|              4.43237|                              3536|Wouters K.                  |Astacus leptodactylus |species       |Eschscholtz, 1823            |
|PB:Ugent:AqE:7   |D'udekem D'Acoz             |INBO:NBN:BFN0017900009Z2X |1985          |Oud-Heverlee     |Oud-Heverlee (Langerodestraat, hazenfonteinstraat) |50.845565N            |         4.665830e+00|            50.84557|              4.66583|                              3536|D'udekem D'Acoz             |Astacus leptodactylus |species       |Eschscholtz, 1823            |

## Create taxon core

### Pre-processing


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



|language |license                                           |rightsHolder         |accessRights                             |datasetID |datasetName                                              |taxonID |scientificName        |kingdom  |taxonRank |scientificNameAuthorship |nomenclaturalCode |
|:--------|:-------------------------------------------------|:--------------------|:----------------------------------------|:---------|:--------------------------------------------------------|:-------|:---------------------|:--------|:---------|:------------------------|:-----------------|
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ugent; Aquatic ecolo |http://www.inbo.be/en/norms-for-data-use |          |Alien macroinvertebrates checklist for Flanders, Belgium |        |Astacus leptodactylus |Animalia |species   |Eschscholtz, 1823        |ICZN              |

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
