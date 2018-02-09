# Darwin Core mapping for checklist dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2018-02-09

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
library(stringr)   # To perform string operations
library(digest)    # To generate hashes
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
dwc_profile_file = "../data/processed/dwc_checklist/speciesprofile.csv"
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

We need to integrate the DwC term `taxonID` in each of the generated files (Taxon Core and Extensions).
For this reason, it is easier to generate `taxonID` in the raw file. 
First, we vectorize the digest function (The digest() function isn't vectorized. 
So if you pass in a vector, you get one value for the whole vector rather than a digest for each element of the vector):


```r
vdigest <- Vectorize(digest)
```

Generate `taxonID`:


```r
raw_data %<>% mutate(taxonID = paste("alien-macroinvertebrates-checklist", "taxon", vdigest (species, algo="md5"), sep=":"))
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



|raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_pathway_mapping                                                                                                                        |raw_salinity_zone |raw_reference               |raw_pathway_mapping_remarks                                       |raw_taxonID                                                               |
|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:---------------------------|:-----------------------------------------------------------------|:-------------------------------------------------------------------------|
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:cebedf4407f487b424807ccd5478bfe6 |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |Ship/boat hull fouling &#124; Ship/boat ballast water &#124; Contaminant on animals (except parasites, species transported by host/vector) |M                 |Kerckhof and Catrijsse 2001 |considered transport with oyster lots as 'Contaminant on animals' |alien-macroinvertebrates-checklist:taxon:db1c88330fce94a3483451f1e0fbc6af |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:d9c2fd07436f56f3824955c88261e76e |
|Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |Aquaculture &#124; Pet/aquarium/terrarium species (including live food for such species )                                                  |F                 |Gerard 1986                 |NA                                                                |alien-macroinvertebrates-checklist:taxon:464f0edd615ac93ab279f425dc1060a3 |
|Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |Pet/aquarium/terrarium species (including live food for such species )                                                                     |F                 |Wouters 2002                |NA                                                                |alien-macroinvertebrates-checklist:taxon:54cca150e1e0b7c0b3f5b152ae64d62b |
|Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Leloup and Lefevre 1952     |NA                                                                |alien-macroinvertebrates-checklist:taxon:f9953a68ec0b35fb531b3d1917df59c7 |

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
#### bibliographicCitation
#### informationWithheld
#### datasetID


```r
taxon  %<>% mutate(datasetID = "https://doi.org/10.15468/yxcq07")
```

#### datasetName


```r
taxon %<>% mutate(datasetName = "Inventory of alien macroinvertebrates in Flanders, Belgium")
```

#### references
#### taxonID


```r
taxon%<>% mutate(taxonID = raw_taxonID)
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
  mutate(order = recode(raw_order, "Veneroidea" = "Venerida")) %<>%
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



|language |license                                           |rightsHolder                     |datasetID                       |datasetName                                                |taxonID                                                                   |scientificName           |kingdom  |phylum     |order    |family          |taxonRank |nomenclaturalCode |
|:--------|:-------------------------------------------------|:--------------------------------|:-------------------------------|:----------------------------------------------------------|:-------------------------------------------------------------------------|:------------------------|:--------|:----------|:--------|:---------------|:---------|:-----------------|
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:cebedf4407f487b424807ccd5478bfe6 |Amphibalanus amphitrite  |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:db1c88330fce94a3483451f1e0fbc6af |Amphibalanus improvisus  |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:d9c2fd07436f56f3824955c88261e76e |Amphibalanus reticulatus |Animalia |Arthropoda |Sessilia |Balanidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:464f0edd615ac93ab279f425dc1060a3 |Astacus leptodactylus    |Animalia |Arthropoda |Decapoda |Astacidae       |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:54cca150e1e0b7c0b3f5b152ae64d62b |Atyaephyra desmaresti    |Animalia |Arthropoda |Decapoda |Atyidae         |species   |ICZN              |
|en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |https://doi.org/10.15468/yxcq07 |Inventory of alien macroinvertebrates in Flanders, Belgium |alien-macroinvertebrates-checklist:taxon:f9953a68ec0b35fb531b3d1917df59c7 |Austrominius modestus    |Animalia |Arthropoda |Sessilia |Austrobalanidae |species   |ICZN              |

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
distribution %<>% mutate(taxonID = raw_taxonID)
```

#### locationID


```r
distribution %<>% mutate(locationID = "ISO_3166-2:BE-VLG")
```

#### locality


```r
distribution %<>% mutate(locality = "Flemish Region")
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


```r
distribution %<>% mutate(establishmentMeans = "introduced")
```

#### appendixCITES
#### eventDate

Distributions will have a start and end year, expressed in `eventDate` as ISO 8601 `yyyy/yyyy` (`start_year`/`end_year`).
The dates in `raw_first_occurrence_in_flanders` are currently expressed in different formats: `yyyy`, `< yyyy`, `<yyyy`, `before yyyy` and `yyyy-yyyy`:


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

When a **single year** is provided (i.e.`yyyy`, `< yyyy`, `<yyyy`, `before yyyy`), we consider this to be the `start_year`. No `end_year` is provided.
We have to assume when the presence of the species was last verified. We will use the publication year of Boets et al. 2016.
In this case, the eventDate will be `start_year/2016`
When a **year range** (yyyy-yyyy) is provided, we have information on both the `start_year` and `end_year`
In this case, the eventDate will be `start_year/end_year`
Thus, to generate `eventDate`, we will need to clean, separate (in case of `yyyy-yyyy`) and remerge the date information contained in `raw_first_occurrence_in_flanders`:
First,`raw_first_occurrence_in_flanders` needs to be cleaned:


```r
distribution %<>% mutate(year = str_replace_all(raw_first_occurrence_in_flanders, "(< |before |<)", ""))
```

Then, the information contained in `year` will be separated into `start_year` and `end_year`, using `-` as a separator.
For all dates in the format `yyyy`, `end_year` will be empty as there is no `end_date` provided in this case. We will replace these empty values by `2016`


```r
distribution %<>% separate(year, into = c('start_year', 'end_year'), sep='-') %<>% # Separate `year`
                  mutate(end_year = case_when(
                    is.na(end_year) ~ "2016",
                    TRUE ~ end_year))
```

Merge `start_year` and `end_year` to generate `eventDate` (`yyyy`/`yyyy`):


```r
distribution %<>% mutate(eventDate = paste(start_year, end_year, sep="/"))
```

Compare formatted dates with `raw_first_occurrence_in_flanders`:


```r
distribution %>% 
  select (raw_first_occurrence_in_flanders, eventDate) %>%
  kable()
```



|raw_first_occurrence_in_flanders |eventDate |
|:--------------------------------|:---------|
|1952                             |1952/2016 |
|before 1700                      |1700/2016 |
|1997                             |1997/2016 |
|1986                             |1986/2016 |
|1895                             |1895/2016 |
|1950                             |1950/2016 |
|2010                             |2010/2016 |
|1931                             |1931/2016 |
|2002                             |2002/2016 |
|1993                             |1993/2016 |
|1998                             |1998/2016 |
|1990                             |1990/2016 |
|1992                             |1992/2016 |
|1992                             |1992/2016 |
|1992                             |1992/2016 |
|1969                             |1969/2016 |
|1911                             |1911/2016 |
|2001                             |2001/2016 |
|1997                             |1997/2016 |
|1834                             |1834/2016 |
|2009                             |2009/2016 |
|2004                             |2004/2016 |
|1925                             |1925/2016 |
|2009                             |2009/2016 |
|1987                             |1987/2016 |
|1933                             |1933/2016 |
|1937                             |1937/2016 |
|1950                             |1950/2016 |
|1937                             |1937/2016 |
|1991                             |1991/2016 |
|2006                             |2006/2016 |
|2003                             |2003/2016 |
|1999                             |1999/2016 |
|2000                             |2000/2016 |
|1996                             |1996/2016 |
|2000                             |2000/2016 |
|2014                             |2014/2016 |
|2009                             |2009/2016 |
|2005                             |2005/2016 |
|1924                             |1924/2016 |
|2008                             |2008/2016 |
|1995                             |1995/2016 |
|1997                             |1997/2016 |
|1998                             |1998/2016 |
|1996                             |1996/2016 |
|1998                             |1998/2016 |
|1933                             |1933/2016 |
|1993                             |1993/2016 |
|2002                             |2002/2016 |
|< 1700                           |1700/2016 |
|1835                             |1835/2016 |
|1927                             |1927/2016 |
|1977                             |1977/2016 |
|1986                             |1986/2016 |
|1999                             |1999/2016 |
|1899                             |1899/2016 |
|1869                             |1869/2016 |
|1927                             |1927/2016 |
|2009                             |2009/2016 |
|1998                             |1998/2016 |
|1945                             |1945/2016 |
|2008                             |2008/2016 |
|2008                             |2008/2016 |
|<1600                            |1600/2016 |
|1996                             |1996/2016 |
|2004                             |2004/2016 |
|1991                             |1991/2016 |
|1999                             |1999/2016 |
|2007                             |2007/2016 |
|2005                             |2005/2016 |
|2003                             |2003/2016 |
|2006                             |2006/2016 |
|1730-1732                        |1730/1732 |

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
(`Boets. et al. unpub data` and `Collection RBINS` full references were lacking in `source`)


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
|Boets et al. unpub data     |Boets et a |       1|
|Collection RBINS            |Collection |       2|
|Cook et al. 2007            |Cook EJ, J |       1|
|Damas 1938                  |Damas H (1 |       1|
|Dewicke 2002                |Dewicke A  |       1|
|Dumoulin 2004               |Dumoulin E |       1|
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
distribution %<>% select(-one_of(raw_colnames), -start_year, -end_year)
```

Preview data:


```r
distribution %>% 
  mutate (source = substr(source, 1,10)) %>%
  head() %>%
  kable()
```



|taxonID                                                                   |locationID        |locality       |countryCode |occurrenceStatus |establishmentMeans |eventDate |source     |
|:-------------------------------------------------------------------------|:-----------------|:--------------|:-----------|:----------------|:------------------|:---------|:----------|
|alien-macroinvertebrates-checklist:taxon:cebedf4407f487b424807ccd5478bfe6 |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1952/2016 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:db1c88330fce94a3483451f1e0fbc6af |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1700/2016 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:d9c2fd07436f56f3824955c88261e76e |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1997/2016 |Kerckhof F |
|alien-macroinvertebrates-checklist:taxon:464f0edd615ac93ab279f425dc1060a3 |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1986/2016 |Gérard P ( |
|alien-macroinvertebrates-checklist:taxon:54cca150e1e0b7c0b3f5b152ae64d62b |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1895/2016 |Wouters K  |
|alien-macroinvertebrates-checklist:taxon:f9953a68ec0b35fb531b3d1917df59c7 |ISO_3166-2:BE-VLG |Flemish Region |BE          |present          |introduced         |1950/2016 |Leloup E,  |

Save to CSV:


```r
write.csv(distribution, file = dwc_distribution_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Create speciesProfile extension

We use this extension to map the **salinity zone** information contained in `raw_salinity_zone` in the raw data file.
`raw_salinity_zone` describes whether a species is found in brackish (B), freshwater (F), marine (M) or combined (B/M or F/B) salinity zone. 
### Pre-processing


```r
species_profile <- raw_data
```

### Term mapping

Map the source data to [Species Profile](http://rs.gbif.org/extension/gbif/1.0/speciesprofile.xml):
#### taxonID


```r
species_profile %<>% mutate(taxonID = raw_taxonID)
```

The following DwC terms from the Species Profile extension are used to map the `raw_salinity_zone` information: `isMarine` and `isFreshwater`.
For completeness, we integrate `isTerrestrial` as this is an essential piece of information for the development of indicators for invasive species.
This is how `raw_salinity_zone` maps to the three DwC terms:


```r
kable(as.data.frame(
  matrix(data = c(
    "F", "FALSE", "TRUE", "FALSE",
    "M", "TRUE", "FALSE", "FALSE",
    "B/M", "TRUE", "FALSE", "FALSE",
    "F/B", "FALSE", "TRUE", "FALSE",
    "B", "TRUE", "TRUE", "FALSE"),
    nrow = 5, ncol = 4, byrow = T,
    dimnames = list (c(1:5), c("salinity zone", "isMarine", "isFreshwater", "isTerrestrial"))
  )))
```



|salinity zone |isMarine |isFreshwater |isTerrestrial |
|:-------------|:--------|:------------|:-------------|
|F             |FALSE    |TRUE         |FALSE         |
|M             |TRUE     |FALSE        |FALSE         |
|B/M           |TRUE     |FALSE        |FALSE         |
|F/B           |FALSE    |TRUE         |FALSE         |
|B             |TRUE     |TRUE         |FALSE         |

#### isMarine


```r
species_profile %<>% 
  mutate(isMarine = case_when(
    raw_salinity_zone == "M" | raw_salinity_zone == "B/M" | raw_salinity_zone == "B" ~ "TRUE",
    TRUE ~"FALSE"))
```

#### isFreshwater


```r
species_profile %<>% 
  mutate(isFreshwater = case_when(
    raw_salinity_zone == "F" | raw_salinity_zone == "F/B" | raw_salinity_zone == "B" ~ "TRUE",
    TRUE ~"FALSE"))
```

#### isTerrestrial


```r
species_profile %<>% mutate(isTerrestrial = "FALSE")
```

Show mapped values:


```r
species_profile %>%
  select(raw_salinity_zone, isMarine, isFreshwater, isTerrestrial) %>%
  group_by(raw_salinity_zone, isMarine, isFreshwater, isTerrestrial) %>%
  summarize(records = n()) %>%
  kable()
```



|raw_salinity_zone |isMarine |isFreshwater |isTerrestrial | records|
|:-----------------|:--------|:------------|:-------------|-------:|
|B                 |TRUE     |TRUE         |FALSE         |       4|
|B/M               |TRUE     |FALSE        |FALSE         |       4|
|F                 |FALSE    |TRUE         |FALSE         |      32|
|F/B               |FALSE    |TRUE         |FALSE         |      16|
|M                 |TRUE     |FALSE        |FALSE         |      17|

### Post-processing

Remove the original columns:


```r
species_profile %<>% select(-one_of(raw_colnames))
```

Sort on `taxonID`:


```r
species_profile %<>% arrange(taxonID)
```

Preview data:


```r
kable(head(species_profile))
```



|taxonID                                                                   |isMarine |isFreshwater |isTerrestrial |
|:-------------------------------------------------------------------------|:--------|:------------|:-------------|
|alien-macroinvertebrates-checklist:taxon:0396fe0cb30083ee34d8692802dbfc3a |TRUE     |TRUE         |FALSE         |
|alien-macroinvertebrates-checklist:taxon:05e1226fad2eec66ff6c70764ecf047a |FALSE    |TRUE         |FALSE         |
|alien-macroinvertebrates-checklist:taxon:06b1921ec41577a8c4516c91837ea594 |TRUE     |FALSE        |FALSE         |
|alien-macroinvertebrates-checklist:taxon:0737719f7e273373da08c01c8dc6162f |FALSE    |TRUE         |FALSE         |
|alien-macroinvertebrates-checklist:taxon:13883300ac884d3398e25f29b89a6513 |TRUE     |FALSE        |FALSE         |
|alien-macroinvertebrates-checklist:taxon:151b9f1f8474dc7154761d78ba5f67e9 |TRUE     |FALSE        |FALSE         |

Save to CSV:


```r
write.csv(species_profile, file = dwc_profile_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

## Create description extension

In the description extension we want to include **native range** (`raw_origin`), **pathway** (`raw_pathway_of_introduction`) and **invasion stage** information. We'll create a separate data frame for each and then combine these with union.

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
native_range %<>% mutate(mapped_value = recode(value,
    "East-Asia" = "East Asia",
    "East-Europe" = "Eastern Europe",
    "Indio-Pacific" = "Indo-Pacific",
    "North-Africa" = "North Africa",
    "North-America" = "Northern America",
    "Northeast-Asia" = "Northeast Asia",
    "South-America" = "South America",
    "South-Europe" = "Southern Europe",
    "Southeast-Asia" = "Southeast Asia",
    "Southern hemisphere" = "Southern Hemisphere",
    "USA" = "United States",
    "West-Africa" = "West Africa",
    "West-Atlantic" = "Western Atlantic"
))
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



|value                  |mapped_value           | records|
|:----------------------|:----------------------|-------:|
|Africa                 |Africa                 |       1|
|Asia                   |Asia                   |       7|
|Australia              |Australia              |       3|
|China                  |China                  |       1|
|East-Asia              |East Asia              |       1|
|East-Europe            |Eastern Europe         |       1|
|Indio-Pacific          |Indo-Pacific           |       1|
|New Zealand            |New Zealand            |       2|
|North-Africa           |North Africa           |       1|
|North-America          |Northern America       |      27|
|Northeast-Asia         |Northeast Asia         |       1|
|Ponto-Caspian          |Ponto-Caspian          |      15|
|South-America          |South America          |       1|
|South-Europe           |Southern Europe        |       6|
|Southeast-Asia         |Southeast Asia         |       3|
|Southern hemisphere    |Southern Hemisphere    |       1|
|Tropical and warm seas |Tropical and warm seas |       1|
|USA                    |United States          |       1|
|West-Africa            |West Africa            |       1|
|West-Atlantic          |Western Atlantic       |       1|

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



|raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_pathway_mapping                                                                                                                        |raw_salinity_zone |raw_reference               |raw_pathway_mapping_remarks                                       |raw_taxonID                                                               |description            |type         |
|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:---------------------------|:-----------------------------------------------------------------|:-------------------------------------------------------------------------|:----------------------|:------------|
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:cebedf4407f487b424807ccd5478bfe6 |Southern Europe        |native range |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |Ship/boat hull fouling &#124; Ship/boat ballast water &#124; Contaminant on animals (except parasites, species transported by host/vector) |M                 |Kerckhof and Catrijsse 2001 |considered transport with oyster lots as 'Contaminant on animals' |alien-macroinvertebrates-checklist:taxon:db1c88330fce94a3483451f1e0fbc6af |Western Atlantic       |native range |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:d9c2fd07436f56f3824955c88261e76e |Tropical and warm seas |native range |
|Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |Aquaculture &#124; Pet/aquarium/terrarium species (including live food for such species )                                                  |F                 |Gerard 1986                 |NA                                                                |alien-macroinvertebrates-checklist:taxon:464f0edd615ac93ab279f425dc1060a3 |Eastern Europe         |native range |
|Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |Pet/aquarium/terrarium species (including live food for such species )                                                                     |F                 |Wouters 2002                |NA                                                                |alien-macroinvertebrates-checklist:taxon:54cca150e1e0b7c0b3f5b152ae64d62b |Southern Europe        |native range |
|Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Leloup and Lefevre 1952     |NA                                                                |alien-macroinvertebrates-checklist:taxon:f9953a68ec0b35fb531b3d1917df59c7 |Australia              |native range |

#### Pathway (pathway of introduction)

`raw_pathway_of_introduction` contains the raw information on the pathway of introduction (e.g. `aquaculture`).
`raw_pathway_mapping` contains the interpretation of this pathway information by @timadriaens. We will use this information to further process our mapping to DwC Archive.
(Remarks on this interpretation are given in `raw_pathway_mapping_remarks`)
 We'll separate, clean, map and combine these values.

Create new data frame:


```r
pathway <- raw_data
```

Similar as for `native_range`, we create a new variable `description` in `pathway` from `raw_pathway_mapping`:


```r
pathway %<>% mutate(description = raw_pathway_mapping)
```

Separate `description` on column in 3 columns.


```r
# In case there are more than 3 values, these will be merged in pathway_3. 
# The dataset currently contains no more than 3 values per record.
pathway %<>% 
  separate(description, 
           into = c("pathway_1", "pathway_2", "pathway_3"),
           sep = " \\| ",
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

Inspect values:


```r
pathway %>%
  distinct(value) %>%
  arrange(value) %>%
  kable()
```



|value                                                                         |
|:-----------------------------------------------------------------------------|
|Aquaculture                                                                   |
|Aquaculture / mariculture                                                     |
|Contaminant on animals (except parasites, species transported by host/vector) |
|Interconnected waterways/basins/seas                                          |
|Mariculture                                                                   |
|Other means of transport                                                      |
|Pet/aquarium/terrarium species (including live food for such species )        |
|Ship/boat ballast water                                                       |
|Ship/boat hull fouling                                                        |

For `pathway` information, we use the suggested vocabulary for introduction pathways used in the TrIAS project, summarized [here](https://github.com/trias-project/vocab/tree/master/vocabulary/pathway).
This standardized vocabulary is based on the [CBD 2014 standard](https://www.cbd.int/doc/meetings/sbstta/sbstta-18/official/sbstta-18-09-add1-en.pdf)
recode values:


```r
pathway %<>% mutate (cbd_stand = recode (value,
  "Aquaculture" = "escape_aquaculture",
  "Aquaculture / mariculture" = "escape_aquaculture",
  "Contaminant on animals (except parasites, species transported by host/vector)" = "contaminant_on_animals",
  "Interconnected waterways/basins/seas" = "corridor_water",
  "Mariculture" = "escape_aquaculture",
  "Other means of transport" = "stowaway_other",
  "Pet/aquarium/terrarium species (including live food for such species )" = "escape_pet",
  "Ship/boat ballast water" = "stowaway_ballast_water",
  "Ship/boat hull fouling" = "stowaway_hull_fouling"))
```

Add prefix `cbd_2014_pathway`:


```r
pathway %<>% mutate(mapped_value = paste ("cbd_2014_pathway", cbd_stand, sep = ":"))
```

Inspect new_pathways:


```r
pathway %>%
  select(value, mapped_value) %>%
  group_by(value, mapped_value) %>%
  summarize(records = n()) %>%
  arrange(value) %>%
  kable()
```



|value                                                                         |mapped_value                            | records|
|:-----------------------------------------------------------------------------|:---------------------------------------|-------:|
|Aquaculture                                                                   |cbd_2014_pathway:escape_aquaculture     |       7|
|Aquaculture / mariculture                                                     |cbd_2014_pathway:escape_aquaculture     |       1|
|Contaminant on animals (except parasites, species transported by host/vector) |cbd_2014_pathway:contaminant_on_animals |       5|
|Interconnected waterways/basins/seas                                          |cbd_2014_pathway:corridor_water         |      18|
|Mariculture                                                                   |cbd_2014_pathway:escape_aquaculture     |       1|
|Other means of transport                                                      |cbd_2014_pathway:stowaway_other         |      11|
|Pet/aquarium/terrarium species (including live food for such species )        |cbd_2014_pathway:escape_pet             |       5|
|Ship/boat ballast water                                                       |cbd_2014_pathway:stowaway_ballast_water |      31|
|Ship/boat hull fouling                                                        |cbd_2014_pathway:stowaway_hull_fouling  |      20|

Drop `key`, `value` and `cbd_stand` column and rename `mapped_value`:


```r
pathway %<>% select(-key, - value, -cbd_stand)
pathway %<>% rename(description = mapped_value)
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



|raw_phylum |raw_order |raw_family      |raw_species              |raw_origin             |raw_first_occurrence_in_flanders |raw_pathway_of_introduction |raw_pathway_mapping                                                                                                                        |raw_salinity_zone |raw_reference               |raw_pathway_mapping_remarks                                       |raw_taxonID                                                               |description                            |type    |
|:----------|:---------|:---------------|:------------------------|:----------------------|:--------------------------------|:---------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:---------------------------|:-----------------------------------------------------------------|:-------------------------------------------------------------------------|:--------------------------------------|:-------|
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus amphitrite  |South-Europe           |1952                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:cebedf4407f487b424807ccd5478bfe6 |cbd_2014_pathway:stowaway_hull_fouling |pathway |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus improvisus  |West-Atlantic          |before 1700                      |shipping                    |Ship/boat hull fouling &#124; Ship/boat ballast water &#124; Contaminant on animals (except parasites, species transported by host/vector) |M                 |Kerckhof and Catrijsse 2001 |considered transport with oyster lots as 'Contaminant on animals' |alien-macroinvertebrates-checklist:taxon:db1c88330fce94a3483451f1e0fbc6af |cbd_2014_pathway:stowaway_hull_fouling |pathway |
|Crustacea  |Sessilia  |Balanidae       |Amphibalanus reticulatus |Tropical and warm seas |1997                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Kerckhof and Catrijsse 2001 |NA                                                                |alien-macroinvertebrates-checklist:taxon:d9c2fd07436f56f3824955c88261e76e |cbd_2014_pathway:stowaway_hull_fouling |pathway |
|Crustacea  |Decapoda  |Astacidae       |Astacus leptodactylus    |East-Europe            |1986                             |aquaculture                 |Aquaculture &#124; Pet/aquarium/terrarium species (including live food for such species )                                                  |F                 |Gerard 1986                 |NA                                                                |alien-macroinvertebrates-checklist:taxon:464f0edd615ac93ab279f425dc1060a3 |cbd_2014_pathway:escape_aquaculture    |pathway |
|Crustacea  |Decapoda  |Atyidae         |Atyaephyra desmaresti    |South-Europe           |1895                             |aquarium trade              |Pet/aquarium/terrarium species (including live food for such species )                                                                     |F                 |Wouters 2002                |NA                                                                |alien-macroinvertebrates-checklist:taxon:54cca150e1e0b7c0b3f5b152ae64d62b |cbd_2014_pathway:escape_pet            |pathway |
|Crustacea  |Sessilia  |Austrobalanidae |Austrominius modestus    |Australia, Asia        |1950                             |shipping                    |Ship/boat hull fouling                                                                                                                     |M                 |Leloup and Lefevre 1952     |NA                                                                |alien-macroinvertebrates-checklist:taxon:f9953a68ec0b35fb531b3d1917df59c7 |cbd_2014_pathway:stowaway_hull_fouling |pathway |

#### Invasion stage


```r
invasion_stage <- raw_data
```

There's no information on `invasion stage` in `raw_data`.
We decided to use the unified framework for biological invasions of [Blackburn et al. 2011](http://doc.rero.ch/record/24725/files/bach_puf.pdf) for `invasion stage`.
Here, we consider all species to be `established` as they come from live samples in running waters.
We decided not to use the terms `naturalized`(because often, there's no sensible criterium to distinguish between casual/naturalised of naturalised/established) and `invasive` (this is a label that should only be put on a species after risk assessment).


```r
invasion_stage %<>% mutate(description = "established")
```

Create a `type` field to indicate the type of description:


```r
invasion_stage %<>% mutate(type = "invasion stage")
```

#### Union native range, pathway and invasion stage:


```r
description_ext <- bind_rows(native_range, pathway, invasion_stage)
```

### Term mapping

Map the source data to [Taxon Description](http://rs.gbif.org/extension/gbif/1.0/description.xml):
#### taxonID


```r
description_ext %<>% mutate(taxonID = raw_taxonID)
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
(`Boets. et al. unpub data` and `Collection RBINS` full references are lacking in `source`)


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
|Adam 1947                   |Adam W (19 |      14|
|Adam and Leloup 1934        |Adam W, Le |       4|
|Backeljau 1986              |Backeljau  |       3|
|Boets et al. 2009           |Boets P, L |       4|
|Boets et al. 2010b          |Boets P, L |       3|
|Boets et al. 2011b          |Boets P, L |       3|
|Boets et al. 2012c          |Boets P, L |       3|
|Boets et al. 2016           |Boets P, B |       3|
|Boets et al. unpub data     |Boets et a |       5|
|Collection RBINS            |Collection |       8|
|Cook et al. 2007            |Cook EJ, J |       4|
|Damas 1938                  |Damas H (1 |       3|
|Dewicke 2002                |Dewicke A  |       4|
|Dumoulin 2004               |Dumoulin E |       3|
|Faasse and Van Moorsel 2003 |Faasse M,  |       6|
|Gerard 1986                 |Gérard P ( |       7|
|Keppens and Mienis 2004     |Keppens M, |       4|
|Kerckhof and Catrijsse 2001 |Kerckhof F |      18|
|Kerckhof and Dumoulin 1987  |Kerckhof F |       4|
|Kerckhof et al. 2007        |Kerckhof F |       5|
|Leloup 1971                 |Leloup E ( |       3|
|Leloup and Lefevre 1952     |Leloup E,  |       8|
|Lock et al. 2007            |Lock K, Va |       3|
|Loppens 1902                |Loppens K  |       3|
|Messiaen et al. 2010        |Messiaen M |       9|
|Nuyttens et al. 2006        |Nuyttens F |       3|
|Nyst 1835 &#124; Adam 1947  |Nyst HJP ( |       4|
|Sablon et al. 2010a         |Sablon R,  |       3|
|Sablon et al. 2010b         |Sablon R,  |       3|
|Sellius 1733                |Sellius G  |       3|
|Seys et al. 1999            |Seys J, Vi |       3|
|Soors et al. 2010           |Soors J, F |       3|
|Soors et al. 2013           |Soors J, v |      28|
|Swinnen et al. 1998         |Swinnen F, |       6|
|Van Damme and Maes 1993     |Van Damme  |       4|
|Van Damme et al. 1992       |Van Damme  |       3|
|Van Goethem and Sablon 1986 |Van Goethe |       3|
|van Haaren and Soors 2009   |van Haaren |       4|
|Vandepitte et al. 2012      |Vandepitte |       3|
|Vercauteren et al. 2005     |Vercautere |       6|
|Vercauteren et al. 2006     |Vercautere |       6|
|Verslycke et al. 2000       |Verslycke  |       4|
|Verween et al. 2006         |Verween A, |       3|
|Wouters 2002                |Wouters K  |      19|
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



|taxonID                                                                   |description                             |type           |source     |language |
|:-------------------------------------------------------------------------|:---------------------------------------|:--------------|:----------|:--------|
|alien-macroinvertebrates-checklist:taxon:0396fe0cb30083ee34d8692802dbfc3a |cbd_2014_pathway:stowaway_ballast_water |pathway        |van Haaren |en       |
|alien-macroinvertebrates-checklist:taxon:0396fe0cb30083ee34d8692802dbfc3a |cbd_2014_pathway:stowaway_hull_fouling  |pathway        |van Haaren |en       |
|alien-macroinvertebrates-checklist:taxon:0396fe0cb30083ee34d8692802dbfc3a |cbd_2014_pathway:escape_aquaculture     |pathway        |van Haaren |en       |
|alien-macroinvertebrates-checklist:taxon:0396fe0cb30083ee34d8692802dbfc3a |established                             |invasion stage |van Haaren |en       |
|alien-macroinvertebrates-checklist:taxon:05e1226fad2eec66ff6c70764ecf047a |Northern America                        |native range   |Gérard P ( |en       |
|alien-macroinvertebrates-checklist:taxon:05e1226fad2eec66ff6c70764ecf047a |cbd_2014_pathway:escape_aquaculture     |pathway        |Gérard P ( |en       |

Save to CSV:


```r
write.csv(description_ext, file = dwc_description_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

