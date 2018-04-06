# Darwin Core mapping for occurrence dataset

Lien Reyserhove, Dimitri Brosens, Peter Desmet

2017-11-22

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
library(stringr)   # For string manipulation
```

Set file paths (all paths should be relative to this script):


```r
raw_data_file = "../data/raw/denormalized_observations.csv"
dwc_occurrence_file = "../data/processed/dwc_occurrence/occurrence.csv"
```

## Read data

Read the source data:


```r
raw_data <- read.table(raw_data_file, header = TRUE, sep = "\t", quote="", na.strings = "NULL", fileEncoding = "UTF-8-BOM", stringsAsFactors = F) 
```

Clean data somewhat: remove empty rows if present


```r
raw_data %<>%  remove_empty_rows() 
```

Add prefix `raw_` to all column names, this to avoid name clashes with Darwin Core terms:


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



|raw_taxon_occurrence_key |raw_taxon_occurrence_comment |raw_nameserver_recommended_scientific_name |raw_nameserver_recommended_name_authority |raw_nameserver_recommended_name_rank |raw_sample_vague_date_start |raw_sample_vague_date_end |raw_sample_vague_date_type |raw_survey_event_comment     |raw_location_name_item_name |raw_survey_event_location_name |raw_sample_lat   |raw_sample_long  |raw_sample_spatial_ref |raw_sample_spatial_ref_system |raw_sample_spatial_ref_qualifier |
|:------------------------|:----------------------------|:------------------------------------------|:-----------------------------------------|:------------------------------------|:---------------------------|:-------------------------|:--------------------------|:----------------------------|:---------------------------|:------------------------------|:----------------|:----------------|:----------------------|:-----------------------------|:--------------------------------|
|BFN0017900009QRO         |PB:Ugent:AqE:2906            |Procambarus clarkii                        |(Girard, 1852)                            |Spp                                  |2011-03-16 00:00:00.000     |2011-03-16 00:00:00.000   |D                          |NA                           |Damme                       |NA                             |51,2917039321127 |3,33787615648995 |78089.0,220704.0       |BD72                          |Imported                         |
|BFN0017900009QRP         |PB:Ugent:AqE:2905            |Procambarus clarkii                        |(Girard, 1852)                            |Spp                                  |2009-01-03 00:00:00.000     |2010-01-02 00:00:00.000   |Y                          |NA                           |Laakdal                     |NA                             |51,0868389225402 |5,00310740316376 |194446.0,197604.0      |BD72                          |Imported                         |
|BFN0017900009QRQ         |PB:Ugent:AqE:2904            |Procambarus clarkii                        |(Girard, 1852)                            |Spp                                  |2009-01-03 00:00:00.000     |2010-01-02 00:00:00.000   |Y                          |NA                           |Geel                        |NA                             |51,1005800032735 |4,97993697973969 |192810.0,199119.0      |BD72                          |Imported                         |
|BFN0017900009QRS         |PB:Ugent:AqE:1815            |Orconectes limosus                         |(Rafinesque, 1817)                        |Spp                                  |2002-08-15 00:00:00.000     |2002-08-15 00:00:00.000   |D                          |2004_KreeftenBBICalc_Warmoes |Weert                       |NA                             |51,2165593647505 |5,58310964700181 |234845.0,212540.0      |BD72                          |Imported                         |
|BFN0017900009QRT         |PB:Ugent:AqE:1831            |Orconectes limosus                         |(Rafinesque, 1817)                        |Spp                                  |2003-06-06 00:00:00.000     |2003-06-06 00:00:00.000   |D                          |2004_KreeftenBBICalc_Warmoes |Dilsen-Stokkem              |NA                             |51,0214476671045 |5,75042616893119 |246938.0,191042.0      |BD72                          |Imported                         |
|BFN0017900009QRW         |PB:Ugent:AqE:1806            |Orconectes limosus                         |(Rafinesque, 1817)                        |Spp                                  |2002-05-30 00:00:00.000     |2002-05-30 00:00:00.000   |D                          |2004_KreeftenBBICalc_Warmoes |Ham                         |NA                             |51,0990079250055 |5,13641646066324 |203772.0,199046.0      |BD72                          |Imported                         |

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
occurrence %<>% mutate(rightsHolder = "Ghent University Aquatic Ecology")
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

Checking whether occurrenceID is a unique code (TRUE)


```r
n_distinct(occurrence $ raw_taxon_occurrence_comment) == nrow(occurrence)
```

```
## [1] TRUE
```

mapping:


```r
occurrence %<>% mutate(occurrenceID = raw_taxon_occurrence_comment)
```

#### catalogNumber
#### recordNumber
#### recordedBy

give all unique name/group/organization records in raw_survey_event_comment (base column for recordedBy and identifiedBy)


```r
occurrence %>% select (raw_survey_event_comment) %>%
  distinct(raw_survey_event_comment) %>%
  arrange (raw_survey_event_comment) %>%
  kable()
```



|raw_survey_event_comment                                      |
|:-------------------------------------------------------------|
|2004_KreeftenBBICalc_Warmoes                                  |
|2004_niet_BBICacl - Warmoes                                   |
|Claudio Salvo                                                 |
|D'udekem D'Acoz                                               |
|databank VMM                                                  |
|Dirk en Walda Hennebel                                        |
|eigen data VMM                                                |
|extra stalen                                                  |
|Frank de Block-Burij                                          |
|Geert Vanloot                                                 |
|Gérard                                                        |
|Gérard, 1986                                                  |
|Gunter Flipkens                                               |
|Hans de Blauwe                                                |
|Herwig Mees                                                   |
|IRSNB-Karel Wouters, 2002                                     |
|Johan Auwerx                                                  |
|Joost Mertens                                                 |
|Kobe Janssen                                                  |
|koen                                                          |
|Koen Maes                                                     |
|Leloup L.                                                     |
|LIN - Belpaire - Cammaerts                                    |
|LISEC - Neven & Beckers                                       |
|Lot Hebbelinck                                                |
|Luc Van Assche                                                |
|Marjolein                                                     |
|Paul van sanden                                               |
|Pieter Cox                                                    |
|Pieter Van Dorsselaer                                         |
|Rik Clicque                                                   |
|Roeland Croket                                                |
|Thomas Gyselinck                                              |
|Tom Van den Neucker                                           |
|Verslycke Tim                                                 |
|VMM                                                           |
|VMM - Joost                                                   |
|VMM - Joost, 2004_KreeftenBBICalc_Warmoes                     |
|VMM - Wim Gabriels                                            |
|VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes              |
|VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes, VMM - Joost |
|VMM, 2004_KreeftenBBICalc_Warmoes                             |
|waarnemingen                                                  |
|waarnemingen - Dirk Hennebel                                  |
|waarnemingen - Hans de Blauwe                                 |
|waarnemingen - Hans De Blauwe                                 |
|Waarnemingen - Kevin Lambeets                                 |
|waarnemingen - Tom Van de Neucker                             |
|Warmoes Thierry                                               |
|Wouters                                                       |
|Wouters, 2002                                                 |
|Xavier Vermeersch                                             |
|zeehavens                                                     |
|NA                                                            |

replace these records by a (list of) person(s), in the recommended best format for [recordedBy](https://terms.tdwg.org/wiki/dwc:recordedBy)  


```r
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
                       "GÃ©rard" = "GÃ©rard",
                       "GÃ©rard, 1986" = "GÃ©rard",
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
                       "waarnemingen - Tom Van den Neucker" = "Van den Neucker T",
                       "Warmoes Thierry" = "Warmoes T",
                       "Wouters" = "Wouters K",
                       "Wouters, 2002" = "Wouters K",
                       "Xavier Vermeersch" = "Vermeersch X",
                       "zeehavens" = "Boets P",
                       .default = "",
                       .missing = ""))
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
occurrence %<>% mutate(otherCatalogNumbers = 
                         paste0("INBO:NBN:",raw_taxon_occurrence_key))
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

 Dates can be found both in `raw_sample_vague_date_start` and `raw_sample_vague_date_end`
 Both variables are imported in Rstudio as character vectors and need to be converted to an object of class "date".


```r
occurrence %<>% 
  mutate(Date_start = as.Date (raw_sample_vague_date_start,"%Y-%m-%d")) %<>% 
  mutate(Date_end = as.Date (raw_sample_vague_date_end,"%Y-%m-%d")) 
```

`Date_start` and `Date_end`are not always identical: 


```r
with (occurrence, identical(Date_start, Date_end))
```

```
## [1] FALSE
```

Thus: dates will be expressed as: 
yyy-mm-dd when `Date_start` = `Date_end`
yyy-mm-dd / yy-mm-dd when `Date_start` != `Date_end`

creating new column `Date_interval`  when `Date_start` != `Date_end`


```r
occurrence %<>% mutate(Date_interval = paste (Date_start, Date_end, sep ="/"))  
```

As it is unsure if GBIF can handle `/`in `EventDate`:
we always use `Date_start` for `eventDate`
when `Date_start` != `Date_end`, we use `Date_interval` for `verbatimEventDate` OR
when `Date_start` = `Date_end`, we define no value for `verbatimEventDate` 

EventDate:


```r
occurrence %<>% mutate(eventDate = Date_start)
```

verbatimEventDate:


```r
occurrence %<>% mutate (verbatimEventDate =
                          case_when (
                            raw_sample_vague_date_start == raw_sample_vague_date_end ~ "",
                            raw_sample_vague_date_start != raw_sample_vague_date_end ~ Date_interval
                          ))
```

Remove the `Date_start`, `Date_end` and `Date_interval` (only intermediate steps):


```r
occurrence %<>% select (- c(Date_start, Date_end, Date_interval))
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


```r
occurrence %<>% mutate(municipality = raw_location_name_item_name)
```

#### locality
#### verbatimLocality


```r
occurrence %<>% mutate(verbatimLocality = raw_survey_event_location_name)
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
occurrence %<>% 
  mutate (coordinate = str_replace (raw_sample_lat, ",", ".")) %>%  # Change "," to "."
  mutate (decimalLatitude = round (as.numeric(coordinate), 5)) %>%  # round to 5 decimals
  select (-coordinate)                                              # remove intermediary vector "coordinate"
```

#### decimalLongitude


```r
occurrence %<>%
  mutate (coordinate = str_replace (raw_sample_long, ",", ".")) %<>%  # Change "," to "."
  mutate (decimalLongitude = round (as.numeric(coordinate), 5)) %<>%  # round to 5 decimals
  select (-coordinate)                                                # remove intermediary vector "coordinate"
```

#### geodeticDatum


```r
occurrence %<>% mutate (geodeticDatum = "WGS84")
```

#### coordinateUncertaintyInMeters


```r
occurrence %<>% mutate(coordinateUncertaintyInMeters = "30")
```

#### coordinatePrecision
#### pointRadiusSpatialFit
#### verbatimCoordinates
#### verbatimLatitude / verbatimLongitude / verbatimCoordinateSystem / verbatimSRS

These DwC terms were taken together as the *easiest* and *clearest* way to map them is to split `occurrence` 
in two separate dataframes: one dataframe with coordinatesystem = Belgium Lambert 72 and one with coordinatesystem = decimal degrees. 

First, to obtain `verbatimLongitude` and `verbatimLatitude` information, we need to split `raw_sample_spatial_ref` into two columns (separator = ","): `longitude` and `latitude` (intermediate columns, will be removed later)
and to replace "," by "." in coordinates expressed as decimal degrees:


```r
occurrence %<>% 
  separate( raw_sample_spatial_ref,
            into = c("longitude", "latitude"),
            sep = ",",
            remove = F) %<>%
  mutate (longitude = str_replace(longitude, ",", ".")) %<>%
  mutate (latitude = str_replace(latitude, ",", "."))
```

Create one dataframe for verbatimCoordinateSystem = Belgium Lambert 72 and one for verbatimCoordinateSystem = decimal degrees:


```r
occurrence.BD72 <- filter (occurrence, raw_sample_spatial_ref_system == "BD72")
occurrence.LTLN <- filter (occurrence, raw_sample_spatial_ref_system == "LTLN")
```

Dwc mapping for verbatimLongitude / verbatimLatitude / verbatimCoordinateSystem / verbatimSRS:


```r
occurrence.BD72 %<>% 
  mutate(verbatimLongitude = as.character (round (as.numeric (longitude, digits = 0 )))) %<>%  # round to 0 digits, convert from numeric to character for later union
  mutate(verbatimLatitude  = as.character (round (as.numeric (latitude, digits = 0 )))) %<>%   # round to 0 digits, convert from numeric to character for later union
  mutate(verbatimCoordinateSystem = "Belgium Lambert 72") %<>%
  mutate(verbatimSRS = "Belgian Datum 1972")

occurrence.LTLN %<>% 
  mutate(verbatimLongitude = longitude) %<>%
  mutate(verbatimLatitude  = latitude) %<>% 
  mutate(verbatimCoordinateSystem = "decimal degrees") %<>%
  mutate(verbatimSRS = "WGS84")
```

merge both subset to new occurrence data frame:


```r
occurrence <- union(occurrence.BD72, occurrence.LTLN)
```

remove intermediary columns `longitude` and `latitude`:


```r
occurrence %<>% select(-c(longitude, latitude))
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

give all unique name/group/organization records in raw_survey_event_comment (base for recordedBy and identifiedBy)


```r
occurrence %>% select (raw_survey_event_comment) %>%
  distinct(raw_survey_event_comment) %>%
  arrange (raw_survey_event_comment) %>%
  kable()
```



|raw_survey_event_comment                                      |
|:-------------------------------------------------------------|
|2004_KreeftenBBICalc_Warmoes                                  |
|2004_niet_BBICacl - Warmoes                                   |
|Claudio Salvo                                                 |
|D'udekem D'Acoz                                               |
|databank VMM                                                  |
|Dirk en Walda Hennebel                                        |
|eigen data VMM                                                |
|extra stalen                                                  |
|Frank de Block-Burij                                          |
|Geert Vanloot                                                 |
|Gérard                                                        |
|Gérard, 1986                                                  |
|Gunter Flipkens                                               |
|Hans de Blauwe                                                |
|Herwig Mees                                                   |
|IRSNB-Karel Wouters, 2002                                     |
|Johan Auwerx                                                  |
|Joost Mertens                                                 |
|Kobe Janssen                                                  |
|koen                                                          |
|Koen Maes                                                     |
|Leloup L.                                                     |
|LIN - Belpaire - Cammaerts                                    |
|LISEC - Neven & Beckers                                       |
|Lot Hebbelinck                                                |
|Luc Van Assche                                                |
|Marjolein                                                     |
|Paul van sanden                                               |
|Pieter Cox                                                    |
|Pieter Van Dorsselaer                                         |
|Rik Clicque                                                   |
|Roeland Croket                                                |
|Thomas Gyselinck                                              |
|Tom Van den Neucker                                           |
|Verslycke Tim                                                 |
|VMM                                                           |
|VMM - Joost                                                   |
|VMM - Joost, 2004_KreeftenBBICalc_Warmoes                     |
|VMM - Wim Gabriels                                            |
|VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes              |
|VMM - Wim Gabriels, 2004_KreeftenBBICalc_Warmoes, VMM - Joost |
|VMM, 2004_KreeftenBBICalc_Warmoes                             |
|waarnemingen                                                  |
|waarnemingen - Dirk Hennebel                                  |
|waarnemingen - Hans de Blauwe                                 |
|waarnemingen - Hans De Blauwe                                 |
|Waarnemingen - Kevin Lambeets                                 |
|waarnemingen - Tom Van de Neucker                             |
|Warmoes Thierry                                               |
|Wouters                                                       |
|Wouters, 2002                                                 |
|Xavier Vermeersch                                             |
|zeehavens                                                     |
|NA                                                            |

replace these records by a (list of) person(s), in the recommended best format for [identifiedBy](https://terms.tdwg.org/wiki/dwc:identifiedBy)  


```r
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
                         "GÃ©rard" = "GÃ©rard",
                         "GÃ©rard, 1986" = "GÃ©rard",
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
                         "waarnemingen - Tom Van den Neucker" = "Van den Neucker T",
                         "Warmoes Thierry" = "Warmoes T",
                         "Wouters" = "Wouters K",
                         "Wouters, 2002" = "Wouters K",
                         "Xavier Vermeersch" = "Vermeersch X",
                         "zeehavens" = "Boets P",
                         .default = "",
                         .missing = ""))
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

Dreissena (Dreissena) polymorpha is the only scientific name with the subgenus mentioned in the name. This doesn't add much information and is removed (see [issue #9](https://github.com/trias-project/alien-macroinvertebrates/issues/9))


```r
occurrence %<>% mutate (scientificName = 
                          case_when (
                            raw_nameserver_recommended_scientific_name == "Dreissena (Dreissena) polymorpha" ~ "Dreissena polymorpha",
                            raw_nameserver_recommended_scientific_name != "Dreissena (Dreissena) polymorpha" ~ raw_nameserver_recommended_scientific_name
                          ) )
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
occurrence %<>% mutate (kingdom = "Animalia")
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

raw_nameserver_recommended_name_rank contains two values: "Spp" and "SubSpp"
--> This should be "Species" and "Subspecies":


```r
occurrence %<>% mutate (taxonRank = 
                          case_when (
                            raw_nameserver_recommended_name_rank == "Spp" ~ "species",
                            raw_nameserver_recommended_name_rank == "SubSpp" ~ "subspecies"
                          ) )
```

#### verbatimTaxonRank
#### scientificNameAuthorship


```r
occurrence %<>% mutate (scientificNameAuthorship = raw_nameserver_recommended_name_authority)
```

#### vernacularName 
#### nomenclaturalCode


```r
occurrence %<>% mutate (nomenclaturalCode = "ICZN")
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



|type  |language |license                                           |rightsHolder                     |accessRights                             |datasetID                       |institutionCode |datasetName                                   |basisOfRecord    |occurrenceID      |recordedBy |otherCatalogNumbers       |eventDate  |verbatimEventDate |continent |countryCode |municipality |verbatimLocality                                                                                     | decimalLatitude| decimalLongitude|geodeticDatum |coordinateUncertaintyInMeters |verbatimLongitude |verbatimLatitude |verbatimCoordinateSystem |verbatimSRS        |identifiedBy |scientificName           |kingdom  |taxonRank |scientificNameAuthorship |nomenclaturalCode |
|:-----|:--------|:-------------------------------------------------|:--------------------------------|:----------------------------------------|:-------------------------------|:---------------|:---------------------------------------------|:----------------|:-----------------|:----------|:-------------------------|:----------|:-----------------|:---------|:-----------|:------------|:----------------------------------------------------------------------------------------------------|---------------:|----------------:|:-------------|:-----------------------------|:-----------------|:----------------|:------------------------|:------------------|:------------|:------------------------|:--------|:---------|:------------------------|:-----------------|
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1078 |VMM        |INBO:NBN:BFN0017900009RAD |2000-08-19 |                  |Europe    |BE          |Gent         |Oostakker, Moervaartkaai, tussen Cargill en Dynea                                                    |        51.13824|          3.78624|WGS84         |30                            |109231            |203291           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Gammarus tigrinus        |Animalia |species   |Sexton, 1939             |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:2669 |VMM        |INBO:NBN:BFN0017900009RI7 |1999-07-24 |                  |Europe    |BE          |Knokke-Heist |Hazegrasstraat, Schapersdijk                                                                         |        51.34525|          3.33294|WGS84         |30                            |77828             |226666           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Potamopyrgus antipodarum |Animalia |species   |(J.E. Gray, 1843)        |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:264  |VMM        |INBO:NBN:BFN0017900009R6M |2004-08-27 |                  |Europe    |BE          |Evergem      |Molendreef, Enaamse                                                                                  |        51.15032|          3.73218|WGS84         |30                            |105459            |204666           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Crangonyx pseudogracilis |Animalia |species   |Bousfield, 1958          |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1451 |VMM        |INBO:NBN:BFN0017900009RPP |2007-08-31 |                  |Europe    |BE          |Nieuwpoort   |Sint-Joris, Ramskapellestraat                                                                        |        51.12485|          2.76741|WGS84         |30                            |37900             |202850           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Gammarus tigrinus        |Animalia |species   |Sexton, 1939             |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1265 |VMM        |INBO:NBN:BFN0017900009RE8 |1991-10-05 |                  |Europe    |BE          |Herentals    |FC: zijweg Geelsebaan (einde zandweg tgo Honingstr.), 30m afw. Prima-Lux, BIO: houten steiger na sas |        51.17161|          4.85111|WGS84         |30                            |183735            |206954           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Gammarus tigrinus        |Animalia |species   |Sexton, 1939             |ICZN              |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |Ghent University Aquatic Ecology |http://www.inbo.be/en/norms-for-data-use |https://doi.org/10.15468/xjtfoo |INBO            |Alien macroinvertebrates in Flanders, Belgium |HumanObservation |PB:Ugent:AqE:1519 |VMM        |INBO:NBN:BFN0017900009SM6 |2008-11-05 |                  |Europe    |BE          |Oostende     |Zandvoordestraat                                                                                     |        51.21327|          2.94688|WGS84         |30                            |50650             |212429           |Belgium Lambert 72       |Belgian Datum 1972 |Boets P      |Gammarus tigrinus        |Animalia |species   |Sexton, 1939             |ICZN              |

Save to CSV:


```r
write.csv(occurrence, file = dwc_occurrence_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```

