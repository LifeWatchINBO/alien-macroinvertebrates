# Darwin Core mapping for checklist dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-28

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
library(stringr)   # to perform string operations
```

Set file paths (all paths should be relative to this script):

raw files: 


```r
raw_data_file = "../data/raw/AI_2016_Boets_etal_Supplement.xls"
sources_file = "../data/raw/sources.tsv"
```

processed files: 


```r
dwc_taxon_file = "../data/processed/dwc_checklist/taxon.csv"
dwc_distribution_file = "../data/processed/dwc_checklist/distribution.csv"
dwc_description_file = "../data/processed/dwc_checklist/description.csv"
```

## Read data

Read the source data:


```r
raw_data <- read_excel(raw_data_file, sheet = "checklist", na = "NA") 
sources <- read.table(sources_file, sep = "\t", quote="", colClasses = "character",  fileEncoding = "UTF8", header = T)
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



|raw_id                                     |raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_salinity_zone |raw_reference               |
|:------------------------------------------|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:-----------------|:---------------------------|
|alien-macroinvertebrates-checklist:taxon:1 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |
|alien-macroinvertebrates-checklist:taxon:2 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |M                 |Kerckhof and Catrijsse 2001 |
|alien-macroinvertebrates-checklist:taxon:3 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |
|alien-macroinvertebrates-checklist:taxon:4 |Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |F                 |Gerard 1986                 |
|alien-macroinvertebrates-checklist:taxon:5 |Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |F                 |Wouters 2002                |
|alien-macroinvertebrates-checklist:taxon:6 |Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |M                 |Leloup and Lefevre 1952     |

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
taxon %<>% mutate(rightsHolder = "Ghent University Aquatic Ecology")
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
#### taxonID


```r
taxon%<>% mutate(taxonID = raw_id)
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
taxon %<>% mutate(scientificName = raw_species)
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

Crustacea is not a phylum but a subphylum. The phylum to which crustaceans belong is "Arthropoda"


```r
taxon %<>% mutate (phylum = recode (raw_phylum, "Crustacea" = "Arthropoda"))
```

#### class
#### order


```r
taxon %<>% 
  mutate(order = recode(raw_order, 
                        "Tubficida" = "Haplotaxida",
                        "Veneroidea" = "Venerida")) %<>%
  mutate (order = str_trim(order))
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
taxon %<>% mutate(taxonRank = case_when(
  raw_species == "Dreissena rostriformis bugensis" ~ "subspecies",
  raw_species != "Dreissena rostriformis bugensis" ~ "species")
  )
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



|language |license                                           |rightsHolder                     |accessRights                             |datasetID |datasetName                                                |taxonID                                    |scientificName           |kingdom  |phylum     |order    |family          |taxonRank |nomenclaturalCode |
|:--------|:-------------------------------------------------|:--------------------------------|:----------------------------------------|:---------|:----------------------------------------------------------|:------------------------------------------|:------------------------|:--------|:----------|:--------|:---------------|:---------|:-----------------|
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:1 |Amphibalanus amphitrite  |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:2 |Amphibalanus improvisus  |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:3 |Amphibalanus reticulatus |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:4 |Astacus leptodactylus    |Animalia |Arthropoda |Decapoda |Astacidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:5 |Atyaephyra desmaresti    |Animalia |Arthropoda |Decapoda |Atyidae         |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |          |Checklist of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:6 |Austrominius modestus    |Animalia |Arthropoda |Sessilia |Austrobalanidae |species   |ICZN              |

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
distribution %<>% mutate(taxonID = raw_id)
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

`eventDate` will be of format `start_year`/`current_year` (yyyy/yyyy).
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
  mutate (eventDate = paste (start_year, current_year, sep ="/")) 
```

Compare formatted dates with `raw_first_occurrence_in_flanders`:


```r
distribution %>% 
  select (raw_first_occurrence_in_flanders, eventDate) %>%
  kable()
```



|raw_first_occurrence_in_flanders |eventDate |
|:--------------------------------|:---------|
|1952                             |1952/2017 |
|before 1700                      |1700/2017 |
|1997                             |1997/2017 |
|1986                             |1986/2017 |
|1895                             |1895/2017 |
|1950                             |1950/2017 |
|2010                             |2010/2017 |
|1931                             |1931/2017 |
|2002                             |2002/2017 |
|1993                             |1993/2017 |
|1998                             |1998/2017 |
|1990                             |1990/2017 |
|1992                             |1992/2017 |
|1992                             |1992/2017 |
|1992                             |1992/2017 |
|1969                             |1969/2017 |
|1911                             |1911/2017 |
|2001                             |2001/2017 |
|1997                             |1997/2017 |
|1834                             |1834/2017 |
|2009                             |2009/2017 |
|2004                             |2004/2017 |
|1925                             |1925/2017 |
|2009                             |2009/2017 |
|1987                             |1987/2017 |
|1933                             |1933/2017 |
|1937                             |1937/2017 |
|1950                             |1950/2017 |
|1937                             |1937/2017 |
|1991                             |1991/2017 |
|2006                             |2006/2017 |
|2003                             |2003/2017 |
|1999                             |1999/2017 |
|2000                             |2000/2017 |
|1996                             |1996/2017 |
|2000                             |2000/2017 |
|2014                             |2014/2017 |
|2009                             |2009/2017 |
|2005                             |2005/2017 |
|1924                             |1924/2017 |
|2008                             |2008/2017 |
|1995                             |1995/2017 |
|1997                             |1997/2017 |
|1998                             |1998/2017 |
|1996                             |1996/2017 |
|1998                             |1998/2017 |
|1933                             |1933/2017 |
|1993                             |1993/2017 |
|2002                             |2002/2017 |
|< 1700                           |1700/2017 |
|1835                             |1835/2017 |
|1927                             |1927/2017 |
|1977                             |1977/2017 |
|1986                             |1986/2017 |
|1999                             |1999/2017 |
|1899                             |1899/2017 |
|1869                             |1869/2017 |
|1927                             |1927/2017 |
|2009                             |2009/2017 |
|1998                             |1998/2017 |
|1945                             |1945/2017 |
|2008                             |2008/2017 |
|2008                             |2008/2017 |
|<1600                            |1600/2017 |
|1996                             |1996/2017 |
|2004                             |2004/2017 |
|1991                             |1991/2017 |
|1999                             |1999/2017 |
|2007                             |2007/2017 |
|2005                             |2005/2017 |
|2003                             |2003/2017 |
|2006                             |2006/2017 |
|1730-1732                        |1730/1732 |

remove intermediary steps `year`, `start_year`, `current_year`:


```r
distribution %<>% select (-c(year, start_year, current_year))
```

#### startDayOfYear
#### endDayOfYear
#### source

Clean `raw_reference` somewhat:


```r
distribution %<>% mutate (raw_reference = recode(
raw_reference,
"Adam  and Leloup 1934" = "Adam and Leloup 1934",  # remove whitespace
"Van  Haaren and Soors 2009" = "van Haaren and Soors 2009", # remove whitespace and lowercase "van"
"This study" = "Boets et al. 2016",
"Nyst 1835; Adam 1947" = "Nyst 1835 | Adam 1947" ))
```

The full reference for source can be found in the raw file `sources`.
We will combine `sources` with `distribution`, based on their respective columns `citation` and `raw_reference`. 
For this, `citation` must be equal to `raw_reference`:


```r
sort(unique(distribution $ raw_reference)) == sort(unique(sources $ citation)) # --> Yes!
```

```
##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [29] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [43] TRUE TRUE TRUE
```

Merge `sources` with `distribution`:


```r
distribution %<>% 
  left_join(sources, by = c("raw_reference" = "citation")) %<>% 
  rename(source = reference)
```

Visualisation of this merge. 
`Boets. et al. unpub data`, `Collection RBINs` and `Dumoulin 2004` full references were lacking and should thus be empty fields in `source`


```r
distribution %>% 
  mutate (source = substr(source, 1,10)) %>%  # shorten full reference to make it easier to display 
  rename (citation = raw_reference) %>%
  select (citation, source) %>%
  group_by(citation, source) %>%
  summarise(records = n()) %>%
  arrange (citation) %>%
  kable()
```



|citation                    |source     | records|
|:---------------------------|:----------|-------:|
|Adam 1947                   |Adam W (19 |       4|
|Adam and Leloup 1934        |Adam W, Le |       1|
|Backeljau 1986              |Backeljau  |       1|
|Boets et al. 2009           |Boets P, L |       1|
|Boets et al. 2010b          |Boets P, L |       1|
|Boets et al. 2011b          |Boets P, L |       1|
|Boets et al. 2012c          |Boets P, L |       1|
|Boets et al. 2016           |Boets P, B |       1|
|Boets et al. unpub data     |           |       1|
|Collection RBINS            |           |       2|
|Cook et al. 2007            |Cook EJ, J |       1|
|Damas 1938                  |Damas H (1 |       1|
|Dewicke 2002                |Dewicke A  |       1|
|Dumoulin 2004               |           |       1|
|Faasse and Van Moorsel 2003 |Faasse M,  |       2|
|Gerard 1986                 |Gérard P ( |       2|
|Keppens and Mienis 2004     |Keppens M, |       1|
|Kerckhof and Catrijsse 2001 |Kerckhof F |       5|
|Kerckhof and Dumoulin 1987  |Kerckhof F |       1|
|Kerckhof et al. 2007        |Kerckhof F |       1|
|Leloup 1971                 |Leloup E ( |       1|
|Leloup and Lefevre 1952     |Leloup E,  |       2|
|Lock et al. 2007            |Lock K, Va |       1|
|Loppens 1902                |Loppens K  |       1|
|Messiaen et al. 2010        |Messiaen M |       3|
|Nuyttens et al. 2006        |Nuyttens F |       1|
|Nyst 1835 &#124; Adam 1947  |Nyst HJP ( |       1|
|Sablon et al. 2010a         |Sablon R,  |       1|
|Sablon et al. 2010b         |Sablon R,  |       1|
|Sellius 1733                |Sellius G  |       1|
|Seys et al. 1999            |Seys J, Vi |       1|
|Soors et al. 2010           |Soors J, F |       1|
|Soors et al. 2013           |Soors J, v |       8|
|Swinnen et al. 1998         |Swinnen F, |       2|
|Van Damme and Maes 1993     |Van Damme  |       1|
|Van Damme et al. 1992       |Van Damme  |       1|
|Van Goethem and Sablon 1986 |Van Goethe |       1|
|van Haaren and Soors 2009   |van Haaren |       1|
|Vandepitte et al. 2012      |Vandepitte |       1|
|Vercauteren et al. 2005     |Vercautere |       2|
|Vercauteren et al. 2006     |Vercautere |       2|
|Verslycke et al. 2000       |Verslycke  |       1|
|Verween et al. 2006         |Verween A, |       1|
|Wouters 2002                |Wouters K  |       6|
|Ysebaert et al. 1997        |Ysebaert T |       1|

#### occurrenceRemarks
### Post-processing

Remove the original columns:


```r
distribution %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
distribution %>% 
  mutate (source = substr(source, 1,10)) %>%
  head() %>%
  kable()
```



|taxonID                                    |locationID        |locality |countryCode |occurrenceStatus |eventDate |source     |
|:------------------------------------------|:-----------------|:--------|:-----------|:----------------|:---------|:----------|
|alien-macroinvertebrates-checklist:taxon:1 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1952/2017 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:2 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1700/2017 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:3 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1997/2017 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:4 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1986/2017 |Gérard P ( |
|alien-macroinvertebrates-checklist:taxon:5 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1895/2017 |Wouters K  |
|alien-macroinvertebrates-checklist:taxon:6 |ISO_3166-2:BE-VLG |Flanders |BE          |present          |1950/2017 |Leloup E,  |

Save to CSV:


```r
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Create description extension

In the description extension we want to include **native range** (`raw_origin`), **pathway** (`raw_pathway_of_introduction`) and **habitat** (`raw_salinity_zone`) information. We'll create a separate data frame for each and then combine these with union.

### Pre-processing

#### Native range

`raw_origin` contains native range information (e.g. `South-America`). We'll separate, clean, map and combine these values.

Create new data frame:


```r
native_range <- raw_data
```

Inspect native_range:


```r
native_range %>%
  distinct(raw_origin) %>%
  arrange(raw_origin) %>%
  kable()
```



|raw_origin                      |
|:-------------------------------|
|Asia                            |
|Asia, Africa, Australia         |
|Australia                       |
|Australia, Asia                 |
|East-Asia                       |
|East-Europe                     |
|New Zealand                     |
|North-Africa                    |
|North-America                   |
|Northeast-Asia                  |
|Ponto-Caspian                   |
|South-America                   |
|South-Europe                    |
|Southeast-Asia                  |
|Southern hemisphere, China, USA |
|Tropical and warm seas          |
|West-Africa, Indio-Pacific      |
|West-Atlantic                   |
|NA                              |

Create `description` from `raw_origin`:


```r
native_range %<>% mutate(description = raw_origin)
```

Separate `description` on column in 3 columns.


```r
# In case there are more than 3 values, these will be merged in native_range_3. 
# The dataset currently contains no more than 3 values per record.
native_range %<>% 
  separate(description, 
           into = c("native_range_1", "native_range_2", "native_range_3"),
           sep = ", ",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )
```

Gather native ranges in a key and value column:


```r
native_range %<>% gather(
  key, value,
  native_range_1, native_range_2, native_range_3,
  na.rm = TRUE, # Also removes records for which there is no native_range_1
  convert = FALSE
)
```

Manually cleaning of `value` to make them more standardized


```r
native_range %<>% 
  mutate(mapped_value = recode(
    value,
    "East-Asia" = "Eastern Asia",
    "East-Europe" = "Eastern Europe",
    "Indio-Pacific" = "Indo-Pacific",
    "North-Africa" = "Northern Africa",
    "North-America" = "Northern America",
    "Northeast-Asia" = "North-eastern Asia",
    "South-America" = "South America",
    "South-Europe" = "Southern Europe",
    "Southeast-Asia" = "South-eastern Asia",
    "USA" = "United States of America",
    "West-Africa" = "Western Africa",
    "West-Atlantic" = "Western Atlantic"))
```

Show mapped values:


```r
native_range %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()
```



|value                  |mapped_value             | records|
|:----------------------|:------------------------|-------:|
|Africa                 |Africa                   |       1|
|Asia                   |Asia                     |       7|
|Australia              |Australia                |       3|
|China                  |China                    |       1|
|East-Asia              |Eastern Asia             |       1|
|East-Europe            |Eastern Europe           |       1|
|Indio-Pacific          |Indo-Pacific             |       1|
|New Zealand            |New Zealand              |       2|
|North-Africa           |Northern Africa          |       1|
|North-America          |Northern America         |      27|
|Northeast-Asia         |North-eastern Asia       |       1|
|Ponto-Caspian          |Ponto-Caspian            |      15|
|South-America          |South America            |       1|
|South-Europe           |Southern Europe          |       6|
|Southeast-Asia         |South-eastern Asia       |       3|
|Southern hemisphere    |Southern hemisphere      |       1|
|Tropical and warm seas |Tropical and warm seas   |       1|
|USA                    |United States of America |       1|
|West-Africa            |Western Africa           |       1|
|West-Atlantic          |Western Atlantic         |       1|

Drop `key` and `value` column and rename `mapped value`:


```r
native_range %<>% select(-key, -value)
native_range %<>% rename(description = mapped_value)
```

Keep only non-empty descriptions:


```r
native_range %<>% filter(!is.na(description) & description != "")
```

Create a `type` field to indicate the type of description:


```r
native_range %<>% mutate(type = "native range")
```

Preview data:


```r
kable(head(native_range))
```



|raw_id                                     |raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_salinity_zone |raw_reference               |description            |type         |
|:------------------------------------------|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:-----------------|:---------------------------|:----------------------|:------------|
|alien-macroinvertebrates-checklist:taxon:1 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |Southern Europe        |native range |
|alien-macroinvertebrates-checklist:taxon:2 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |M                 |Kerckhof and Catrijsse 2001 |Western Atlantic       |native range |
|alien-macroinvertebrates-checklist:taxon:3 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |Tropical and warm seas |native range |
|alien-macroinvertebrates-checklist:taxon:4 |Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |F                 |Gerard 1986                 |Eastern Europe         |native range |
|alien-macroinvertebrates-checklist:taxon:5 |Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |F                 |Wouters 2002                |Southern Europe        |native range |
|alien-macroinvertebrates-checklist:taxon:6 |Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |M                 |Leloup and Lefevre 1952     |Australia              |native range |

#### Pathway (pathway of introduction)

`raw_pathway_of_introduction` contains information on the pathway of introduction (e.g. `aquaculture`). We'll separate, clean, map and combine these values.

Create new data frame:


```r
pathway <- raw_data
```

Inspect `pathway`:


```r
pathway %>%
  distinct(raw_pathway_of_introduction) %>%
  arrange(raw_pathway_of_introduction) %>%
  kable()
```



|raw_pathway_of_introduction |
|:---------------------------|
|aquaculture                 |
|aquaculture, aquarium trade |
|aquaculture, other          |
|aquarium trade              |
|corridors                   |
|other                       |
|shipping                    |
|shipping, aquaculture       |
|shipping, corridors         |
|shipping, corridors, other  |
|shipping, other             |
|shipping, others            |

Similar as for `native_range`, we create a new variable `description` in `pathway` from `raw_pathway_of_introduction`:


```r
pathway %<>% mutate(description = raw_pathway_of_introduction)
```

Separate `description` on column in 3 columns.


```r
# In case there are more than 3 values, these will be merged in pathway_3. 
# The dataset currently contains no more than 3 values per record.
pathway %<>% 
  separate(description, 
           into = c("pathway_1", "pathway_2", "pathway_3"),
           sep = ", ",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )
```

Gather pathways in a key and value column:


```r
pathway %<>% gather(
  key, value,
  pathway_1, pathway_2, pathway_3,
  na.rm = TRUE, # Also removes records for which there is no pathway_1
  convert = FALSE
)
```

In `value`, both `other` and `others` is given as a pathway of introduction.
We clean `value` by changing `others` --> `other`


```r
pathway %<>% mutate(value = recode(value, "others" = "other"))
```

Show new values:


```r
pathway %>%
  distinct(value) %>%
  arrange(value) %>%
  kable()
```



|value          |
|:--------------|
|aquaculture    |
|aquarium trade |
|corridors      |
|other          |
|shipping       |

Drop `key` column and rename `value`:


```r
pathway %<>% select(-key)
pathway %<>% rename(description = value)
```

Keep only non-empty descriptions:


```r
pathway %<>% filter(!is.na(description) & description != "")
```

Create a `type` field to indicate the type of description:


```r
pathway %<>% mutate(type = "pathway")
```

Preview data:


```r
kable(head(pathway))
```



|raw_id                                     |raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_salinity_zone |raw_reference               |description    |type    |
|:------------------------------------------|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:-----------------|:---------------------------|:--------------|:-------|
|alien-macroinvertebrates-checklist:taxon:1 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |shipping       |pathway |
|alien-macroinvertebrates-checklist:taxon:2 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |M                 |Kerckhof and Catrijsse 2001 |shipping       |pathway |
|alien-macroinvertebrates-checklist:taxon:3 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |shipping       |pathway |
|alien-macroinvertebrates-checklist:taxon:4 |Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |F                 |Gerard 1986                 |aquaculture    |pathway |
|alien-macroinvertebrates-checklist:taxon:5 |Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |F                 |Wouters 2002                |aquarium trade |pathway |
|alien-macroinvertebrates-checklist:taxon:6 |Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |M                 |Leloup and Lefevre 1952     |shipping       |pathway |

#### Habitat

`raw_salinity_zone` contains information on the habitat of the species ("B" = brackish, "M" = marine, "freshwater"). We'll separate, clean, map and combine these values.

Create new data frame:


```r
habitat <- raw_data
```

Inspect native_range:


```r
habitat %>%
  distinct(raw_salinity_zone) %>%
  arrange(raw_salinity_zone) %>%
  kable()
```



|raw_salinity_zone |
|:-----------------|
|B                 |
|B/M               |
|F                 |
|F/B               |
|M                 |

Similar as for `native_range` and `pathway`, we create a new variable `description` in `habitat` from `raw_salinity_zone`:


```r
habitat %<>% mutate(description = raw_salinity_zone)
```

Separate `description` on column in 2 columns.


```r
# In case there are more than 2 values, these will be merged in habitat_2. 
# The dataset currently contains no more than 2 values per record.
habitat %<>% 
  separate(description, 
           into = c("habitat_1", "habitat_2"),
           sep = "/",
           remove = TRUE,
           convert = FALSE,
           extra = "merge",
           fill = "right"
  )
```

Gather habitats in a key and value column:


```r
habitat %<>% gather(
  key, value,
  habitat_1, habitat_2,
  na.rm = TRUE, # Also removes records for which there is no habitat_1
  convert = FALSE
)
```

`value now contains` the abbreviations `B`, `M` and `F` --> we substitute these by `brackish`, `marine` and `freshwater` respectively.


```r
habitat %<>% 
  mutate(mapped_value = recode(
    value,
    "B" = "brackish",
    "M" = "marine",
    "F" = "freshwater"))
```

Show mapped values:


```r
habitat %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()
```



|value |mapped_value | records|
|:-----|:------------|-------:|
|B     |brackish     |      24|
|F     |freshwater   |      48|
|M     |marine       |      21|

Drop `key` and `value` column and rename `mapped value`:


```r
habitat %<>% select(-key, -value)
habitat %<>% rename(description = mapped_value)
```

Keep only non-empty descriptions:


```r
habitat %<>% filter(!is.na(description) & description != "")
```

Create a `type` field to indicate the type of description:


```r
habitat %<>% mutate(type = "habitat")
```

Preview data:


```r
kable(head(habitat))
```



|raw_id                                     |raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_salinity_zone |raw_reference               |description |type    |
|:------------------------------------------|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:-----------------|:---------------------------|:-----------|:-------|
|alien-macroinvertebrates-checklist:taxon:1 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |marine      |habitat |
|alien-macroinvertebrates-checklist:taxon:2 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |M                 |Kerckhof and Catrijsse 2001 |marine      |habitat |
|alien-macroinvertebrates-checklist:taxon:3 |Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |M                 |Kerckhof and Catrijsse 2001 |marine      |habitat |
|alien-macroinvertebrates-checklist:taxon:4 |Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |F                 |Gerard 1986                 |freshwater  |habitat |
|alien-macroinvertebrates-checklist:taxon:5 |Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |F                 |Wouters 2002                |freshwater  |habitat |
|alien-macroinvertebrates-checklist:taxon:6 |Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |M                 |Leloup and Lefevre 1952     |marine      |habitat |

#### Union native range, pathway and habitat:


```r
description_ext <- bind_rows(native_range, pathway, habitat)
```

### Term mapping

Map the source data to [Taxon Description](http://rs.gbif.org/extension/gbif/1.0/description.xml):
#### taxonID


```r
description_ext %<>% mutate(taxonID = raw_id)
```

#### description


```r
description_ext %<>% mutate(description = description)
```

#### type


```r
description_ext %<>% mutate(type = type)
```

#### source

Clean `raw_reference` somewhat:


```r
description_ext %<>% mutate (raw_reference = recode(
  raw_reference,
  "Adam  and Leloup 1934" = "Adam and Leloup 1934",  # remove whitespace
  "Van  Haaren and Soors 2009" = "van Haaren and Soors 2009", # remove whitespace and lowercase "van"
  "This study" = "Boets et al. 2016",
  "Nyst 1835; Adam 1947" = "Nyst 1835 | Adam 1947" ))
```

The full reference for source can be found in the raw file `sources`.
We will combine `sources` with `description_ext`, based on their respective columns `citation` and `raw_reference`. 
For this, `citation` must be equal to `raw_reference`:


```r
sort(unique(description_ext $ raw_reference)) == sort(unique(sources $ citation)) # --> Yes!
```

```
##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [29] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
## [43] TRUE TRUE TRUE
```

Merge `sources` with `description_ext`:


```r
description_ext %<>% 
  left_join(sources, by = c("raw_reference" = "citation")) %<>% 
  rename(source = reference)
```

Visualisation of this merge. 
`Boets. et al. unpub data`, `Collection RBINs` and `Dumoulin 2004` full references were lacking and should thus be empty fields in `source`


```r
description_ext %>% 
  mutate (source = substr(source, 1,10)) %>%  # shorten full reference to make it easier to display 
  rename (citation = raw_reference) %>%
  select (citation, source) %>%
  group_by(citation, source) %>%
  summarise(records = n()) %>%
  arrange (citation) %>%
  kable()
```



|citation                    |source     | records|
|:---------------------------|:----------|-------:|
|Adam 1947                   |Adam W (19 |      13|
|Adam and Leloup 1934        |Adam W, Le |       4|
|Backeljau 1986              |Backeljau  |       3|
|Boets et al. 2009           |Boets P, L |       4|
|Boets et al. 2010b          |Boets P, L |       3|
|Boets et al. 2011b          |Boets P, L |       4|
|Boets et al. 2012c          |Boets P, L |       3|
|Boets et al. 2016           |Boets P, B |       4|
|Boets et al. unpub data     |           |       6|
|Collection RBINS            |           |       9|
|Cook et al. 2007            |Cook EJ, J |       4|
|Damas 1938                  |Damas H (1 |       4|
|Dewicke 2002                |Dewicke A  |       4|
|Dumoulin 2004               |           |       4|
|Faasse and Van Moorsel 2003 |Faasse M,  |       7|
|Gerard 1986                 |Gérard P ( |       6|
|Keppens and Mienis 2004     |Keppens M, |       3|
|Kerckhof and Catrijsse 2001 |Kerckhof F |      16|
|Kerckhof and Dumoulin 1987  |Kerckhof F |       4|
|Kerckhof et al. 2007        |Kerckhof F |       4|
|Leloup 1971                 |Leloup E ( |       4|
|Leloup and Lefevre 1952     |Leloup E,  |       8|
|Lock et al. 2007            |Lock K, Va |       4|
|Loppens 1902                |Loppens K  |       4|
|Messiaen et al. 2010        |Messiaen M |      12|
|Nuyttens et al. 2006        |Nuyttens F |       4|
|Nyst 1835 &#124; Adam 1947  |Nyst HJP ( |       4|
|Sablon et al. 2010a         |Sablon R,  |       4|
|Sablon et al. 2010b         |Sablon R,  |       3|
|Sellius 1733                |Sellius G  |       3|
|Seys et al. 1999            |Seys J, Vi |       3|
|Soors et al. 2010           |Soors J, F |       3|
|Soors et al. 2013           |Soors J, v |      30|
|Swinnen et al. 1998         |Swinnen F, |       8|
|Van Damme and Maes 1993     |Van Damme  |       4|
|Van Damme et al. 1992       |Van Damme  |       4|
|Van Goethem and Sablon 1986 |Van Goethe |       3|
|van Haaren and Soors 2009   |van Haaren |       3|
|Vandepitte et al. 2012      |Vandepitte |       3|
|Vercauteren et al. 2005     |Vercautere |       6|
|Vercauteren et al. 2006     |Vercautere |       7|
|Verslycke et al. 2000       |Verslycke  |       5|
|Verween et al. 2006         |Verween A, |       4|
|Wouters 2002                |Wouters K  |      22|
|Ysebaert et al. 1997        |Ysebaert T |       3|

#### language


```r
description_ext %<>% mutate(language = "en")
```

#### created
#### creator
#### contributor
#### audience
#### license
#### rightsHolder
#### datasetID
### Post-processing

Remove the original columns:


```r
description_ext %<>% select(-one_of(raw_colnames))
```

Move `taxonID` to the first position:


```r
description_ext %<>% select(taxonID, everything())
```

Sort on `taxonID`:


```r
description_ext %<>% arrange(taxonID)
```

Preview data:


```r
description_ext %>% 
  mutate (source = substr(source, 1,10)) %>%
  head() %>%
  kable()
```



|taxonID                                     |description      |type         |source     |language |
|:-------------------------------------------|:----------------|:------------|:----------|:--------|
|alien-macroinvertebrates-checklist:taxon:1  |Southern Europe  |native range |Kerckhof F |en       |
|alien-macroinvertebrates-checklist:taxon:1  |shipping         |pathway      |Kerckhof F |en       |
|alien-macroinvertebrates-checklist:taxon:1  |marine           |habitat      |Kerckhof F |en       |
|alien-macroinvertebrates-checklist:taxon:10 |Northern America |native range |Van Damme  |en       |
|alien-macroinvertebrates-checklist:taxon:10 |shipping         |pathway      |Van Damme  |en       |
|alien-macroinvertebrates-checklist:taxon:10 |brackish         |habitat      |Van Damme  |en       |

Save to CSV:


```r
write.csv(description_ext, file = dwc_description_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

