# Darwin Core mapping for checklist dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-23

This document describes how we map the checklist data to Darwin Core.

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
library(readxl)    # To read excel files
```

Set file paths (all paths should be relative to this script):


```r
raw_data_file = "../data/raw/AI_2016_Boets_etal_Supplement.xls"
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
```

## Read data

Read the source data:


```r
raw_data <- read_excel(raw_data_file, sheet = "checklist") 
```

Clean data somewhat: remove empty rows if present


```r
raw_data %<>%
  remove_empty_rows() %>%     # Remove empty rows
  clean_names()               # Have sensible (lowercase) column names
```

Add prefix `raw_` to all column names to avoid name clashes with Darwin Core terms:


```r
colnames(raw_data) <- paste0("raw_", colnames(raw_data))
```

Save those column names as a vector (makes it easier to remove them all later):


```r
raw_colnames <- colnames(raw_data)
```

Preview data:


```r
kable(head(raw_data))
```



|raw_phylum |raw_order   |raw_family   |raw_species              |raw_origin                 |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_salinity_zone |raw_reference           |
|:----------|:-----------|:------------|:------------------------|:--------------------------|:--------------------------------|:---------------------------|:-----------------|:-----------------------|
|Annelida   |Sabellida   |Sabellidae   |Laonome calida           |Australia                  |2014                             |shipping                    |F/B               |This study              |
|Annelida   |Sabellida   |Serpulidae   |Ficopomatus enigmaticus  |Asia                       |1950                             |shipping                    |F/B               |Leloup and Lefevre 1952 |
|Annelida   |Spionida    |Spionidae    |Marenzelleria viridis    |North-America              |1995                             |shipping                    |B                 |Ysebaert et al. 1997    |
|Annelida   |Spionida    |Spionidae    |Marenzelleria neglecta   |North-America              |2008                             |shipping                    |B                 |Soors et al. 2013       |
|Annelida   |Terebellida |Ampharetidae |Hypania invalida         |Ponto-Caspian              |2000                             |shipping                    |F                 |Vercauteren et al. 2005 |
|Annelida   |Tubficida   |Naididae     |Branchiodrilus hortensis |Asia, Africa and Australia |2010                             |shipping, corridors         |F                 |Soors et al. 2013       |

## Create taxon core


```r
taxon <- raw_data
```

### Pre-processing
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
taxon %<>% mutate("Ghent University Aquatic Ecology")
```

#### accessRights


```r
taxon %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")
```

#### bibliographicCitation
#### informationWithheld
#### datasetID


```r
taxon  %<>% mutate(datasetID = "")
```

#### datasetName


```r
taxon %<>% mutate(datasetName = "Checklist of alien macroinvertebrates in Flanders, Belgium")
```

#### references


```r
taxon%<>% mutate(references = "http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf")
```

#### taxonID
To be completed!
#### scientificNameID
#### acceptedNameUsageID
#### parentNameUsageID
#### originalNameUsageID
#### nameAccordingToID
#### namePublishedInID
#### taxonConceptID
#### scientificName


```r
taxon %<>% mutate(scientificName = raw_species)
#
```

verification if scientificName contains unique values:


```r
any(duplicated(taxon $scientificName))
```

```
## [1] FALSE
```

#### namePublishedInYear
#### higherClassification
#### kingdom


```r
taxon %<>% mutate(kingdom = "Animalia")
```

#### phylum


```r
taxon %<>% mutate(phylum = raw_phylum)
```

#### class
#### order


```r
taxon %<>% mutate(order = raw_order)
```

#### family


```r
taxon %<>% mutate(family = raw_family)
```

#### genus
#### subgenus
#### specificEpithet
#### infraspecificEpithet
#### taxonRank


```r
taxon %<>% mutate(taxonRank = "species")
```

#### verbatimTaxonRank
#### scientificNameAuthorship
To be completed!
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



|language |license                                           |"Ghent University Aquatic Ecology" |accessRights                             |datasetID |datasetName                                                |references                                                  |scientificName           |kingdom  |phylum   |order       |family       |taxonRank |nomenclaturalCode |
|:--------|:-------------------------------------------------|:----------------------------------|:----------------------------------------|:---------|:----------------------------------------------------------|:-----------------------------------------------------------|:------------------------|:--------|:--------|:-----------|:------------|:---------|:-----------------|
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Laonome calida           |Animalia |Annelida |Sabellida   |Sabellidae   |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Ficopomatus enigmaticus  |Animalia |Annelida |Sabellida   |Serpulidae   |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Marenzelleria viridis    |Animalia |Annelida |Spionida    |Spionidae    |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Marenzelleria neglecta   |Animalia |Annelida |Spionida    |Spionidae    |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Hypania invalida         |Animalia |Annelida |Terebellida |Ampharetidae |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology   |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf |Branchiodrilus hortensis |Animalia |Annelida |Tubficida   |Naididae     |species   |ICZN              |

Save to CSV:


```r
write.csv(taxon, file = dwc_taxon_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Create distribution extension

### Pre-processing


```r
distribution <- raw_data
```

### Term mapping

Map the source data to [Species Distribution](http://rs.gbif.org/extension/gbif/1.0/distribution.xml):
#### taxonID


```r
# to be determined!
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
distribution %<>% mutate(occurrenceStatus = "Present")
```

#### threatStatus
#### establishmentMeans
#### appendixCITES
#### eventDate

Inspect content of `raw_first_occurrence_in_flanders`:


```r
distribution %>%
  distinct(raw_first_occurrence_in_flanders) %>%
  arrange(raw_first_occurrence_in_flanders) %>%
  kable()
```



|raw_first_occurrence_in_flanders |
|:--------------------------------|
|< 1700                           |
|<1600                            |
|1730-1732                        |
|1834                             |
|1835                             |
|1869                             |
|1895                             |
|1899                             |
|1911                             |
|1924                             |
|1925                             |
|1927                             |
|1931                             |
|1933                             |
|1937                             |
|1945                             |
|1950                             |
|1952                             |
|1969                             |
|1977                             |
|1986                             |
|1987                             |
|1990                             |
|1991                             |
|1992                             |
|1993                             |
|1995                             |
|1996                             |
|1997                             |
|1998                             |
|1999                             |
|2000                             |
|2001                             |
|2002                             |
|2003                             |
|2004                             |
|2005                             |
|2006                             |
|2007                             |
|2008                             |
|2009                             |
|2010                             |
|2014                             |
|before 1700                      |

`eventDate` will be of format `start_year`- `current_year` (yyyy-yyyy).
`start_year` (yyyy) will contain the information from the following formats in `raw_first_occurrence_in_flanders`: "yyyy", "< yyyy", "<yyyy" and "before yyyy" OR the first year of the interval "yyyy-yyyy":
`current_year` (yyyy) will contain the current year OR the last year of the interval "yyyy-yyyy":
Before further processing, `raw_first_occurrence_in_flanders` needs to be cleaned, i.e. remove "<","< " and "before ":


```r
distribution %<>% mutate(year = str_replace_all(raw_first_occurrence_in_flanders, "(< |before |<)", ""))
```

Create `start_year`:


```r
distribution %<>%
  mutate(start_year = 
           case_when(
             str_detect(year, "-") == "TRUE" ~ "1730",   # when `year` = range --> pick first year (1730 in 1730-1732)
             str_detect(year, "-") == "FALSE" ~ year))   
```

Create `current_year`:


```r
distribution %<>%
  mutate (current_year = 
            case_when(
              str_detect(year, "-") == TRUE ~ "1732",    # when `year` = range --> pick last year (1730 in 1730-1732)
              str_detect(year, "-") == FALSE ~ format(Sys.Date(), "%Y")))
```

Create `eventDate` by binding `start_year` and `current_year`:


```r
distribution %<>% 
  mutate (eventDate = paste (start_year, current_year, sep ="-")) 
```

Compare formatted dates with `raw_first_occurrence_in_flanders`:


```r
distribution %>% 
  select (raw_first_occurrence_in_flanders, eventDate) %>%
  kable()
```



|raw_first_occurrence_in_flanders |eventDate |
|:--------------------------------|:---------|
|2014                             |2014-2017 |
|1950                             |1950-2017 |
|1995                             |1995-2017 |
|2008                             |2008-2017 |
|2000                             |2000-2017 |
|2010                             |2010-2017 |
|2002                             |2002-2017 |
|1931                             |1931-2017 |
|2009                             |2009-2017 |
|2002                             |2002-2017 |
|2009                             |2009-2017 |
|2008                             |2008-2017 |
|1996                             |1996-2017 |
|2006                             |2006-2017 |
|1998                             |1998-2017 |
|1990                             |1990-2017 |
|1993                             |1993-2017 |
|1992                             |1992-2017 |
|2003                             |2003-2017 |
|1997                             |1997-2017 |
|1925                             |1925-2017 |
|2009                             |2009-2017 |
|1937                             |1937-2017 |
|1991                             |1991-2017 |
|1996                             |1996-2017 |
|1996                             |1996-2017 |
|1927                             |1927-2017 |
|1986                             |1986-2017 |
|1986                             |1986-2017 |
|1895                             |1895-2017 |
|2008                             |2008-2017 |
|1977                             |1977-2017 |
|1991                             |1991-2017 |
|1999                             |1999-2017 |
|1993                             |1993-2017 |
|1933                             |1933-2017 |
|2003                             |2003-2017 |
|2006                             |2006-2017 |
|1998                             |1998-2017 |
|1945                             |1945-2017 |
|2005                             |2005-2017 |
|2000                             |2000-2017 |
|1999                             |1999-2017 |
|2005                             |2005-2017 |
|1950                             |1950-2017 |
|1952                             |1952-2017 |
|before 1700                      |1700-2017 |
|1998                             |1998-2017 |
|1997                             |1997-2017 |
|1997                             |1997-2017 |
|2007                             |2007-2017 |
|1987                             |1987-2017 |
|1911                             |1911-2017 |
|< 1700                           |1700-2017 |
|1730-1732                        |1730-1732 |
|<1600                            |1600-2017 |
|1924                             |1924-2017 |
|1927                             |1927-2017 |
|1969                             |1969-2017 |
|1998                             |1998-2017 |
|1937                             |1937-2017 |
|1869                             |1869-2017 |
|1999                             |1999-2017 |
|1992                             |1992-2017 |
|1992                             |1992-2017 |
|1834                             |1834-2017 |
|2009                             |2009-2017 |
|1835                             |1835-2017 |
|2004                             |2004-2017 |
|1899                             |1899-2017 |
|1933                             |1933-2017 |
|2004                             |2004-2017 |
|2001                             |2001-2017 |

remove intermediary steps `year`, `start_year`, `current_year`:


```r
distribution %<>% select (-c(year, start_year, current_year))
```

#### startDayOfYear
#### endDayOfYear
#### source


```r
distribution %<>% mutate (source = raw_reference)
```

#### occurrenceRemarks
### Post-processing

Remove the original columns:


```r
distribution %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
kable(head(distribution))
```



|locationID        |locality |countryCode |occurrenceStatus |eventDate |source                  |
|:-----------------|:--------|:-----------|:----------------|:---------|:-----------------------|
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |2014-2017 |This study              |
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |1950-2017 |Leloup and Lefevre 1952 |
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |1995-2017 |Ysebaert et al. 1997    |
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |2008-2017 |Soors et al. 2013       |
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |2000-2017 |Vercauteren et al. 2005 |
|ISO_3166-2:BE-VLG |Flanders |BE          |Present          |2010-2017 |Soors et al. 2013       |

Save to CSV:


```r
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

