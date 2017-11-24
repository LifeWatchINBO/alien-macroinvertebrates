# Alien macroinvertebrates

## Rationale

This repository contains 1) the source data for the _Alien macroinvertebrates in Flanders (Belgium)_ dataset by Boets et al., 2) the functionality to standardize these data to both a [Darwin Core](https://www.gbif.org/dataset-classes) **occurrence** and **checklist dataset** that can be harvested by [GBIF](http://www.gbif.org), and 3) the code for a [one-page website](http://trias-project.github.io/alien-macroinvertebrates) to explore the occurrence data. It was developed for the [TrIAS project](http://trias-project.be).

## Results

### Occurrence dataset

* Description of the [Darwin Core mapping](src/dwc_occurrence.md) (= a rendition of the [mapping script](src/dwc_occurrence.R))
* Generated [Darwin Core files](data/processed/dwc_occurrence/)
* Published [dataset on the IPT](http://data.inbo.be/ipt/resource?r=alien-macroinvertebrate-occurrences)
* Published [dataset on GBIF](https://www.gbif.org/dataset/3c428404-893c-44da-bb4a-6c19d8fb676a)
* Article for this dataset:

> Boets P, Brosens D, Lock K, Adriaens T, Aelterman B, Mertens J & Goethals P. 2016. Alien macroinvertebrates in Flanders (Belgium). Aquatic Invasions 11 (2): 131–144. https://doi.org/10.3391/ai.2016.11.2.03

### Checklist dataset

* Description of the [Darwin Core mapping](src/dwc_checklist.md) (= a rendition of the [mapping script](src/dwc_checklist.R))
* Generated [Darwin Core files](data/processed/checklist/)
* Published dataset on the IPT
* Published dataset on GBIF

## Repo structure

The repository structure is based on [Cookiecutter Data Science](http://drivendata.github.io/cookiecutter-data-science/). Files indicated with `GENERATED` should not be edited manually.

```
├── README.md               : Top-level description of the project and how to run it
├── LICENSE                 : Project license
├── .gitignore              : Files and folders to be ignored by git
│
├── data
│   ├── raw                 : Source occurrence data, not maintained elsewhere,
|   |                         input for both mapping scripts and CARTO 
│   └── processed
|       ├── dwc_occurrence  : Darwin Core output of occurrence mapping script GENERATED
|       └── dwc_checklist   : Darwin Core output of checklist mapping script GENERATED
│
├── src
│   ├── dwc_occurrence.R    : Darwin Core mapping script for occurrence dataset
│   ├── dwc_occurrence.md   : Nicer rendition of above script, created by knitr::spin GENERATED
│   ├── dwc_checklist.R     : Darwin Core mapping script for checklist dataset
│   ├── dwc_checklist.md    : Nicer rendition of above script, created by knitr::spin GENERATED
│   └── src.Rproj           : RStudio project file
│
└── docs                    : Code for a one-page website to explore occurrence data on CARTO
                              http://trias-project.github.io/alien-macroinvertebrates
```

## Installation

...

## Contributors

[List of contributors](https://github.com/trias-project/alien-macroinvertebrates/contributors)

## License

[MIT License](LICENSE)
