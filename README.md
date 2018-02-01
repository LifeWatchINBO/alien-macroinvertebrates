# Alien macroinvertebrates

## Rationale

This repository contains the functionality to standardize the data of Boets et al. (2016) (http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf) to both a [Darwin Core **occurrence**](https://www.gbif.org/dataset-classes) and [Darwin Core **checklist**](https://www.gbif.org/dataset-classes) dataset that can be harvested by [GBIF](http://www.gbif.org). The repository also contains the code for a [one-page **website**](http://trias-project.github.io/alien-macroinvertebrates) to explore the occurrence data. It was developed for the [TrIAS project](http://trias-project.be).

## Results

### Occurrence dataset

* Description of the [Darwin Core mapping](src/dwc_occurrence.md) (= a rendition of the [mapping script](src/dwc_occurrence.R))
* Generated [Darwin Core files](data/processed/dwc_occurrence/)
* Published [dataset on the IPT](https://ipt.inbo.be/resource?r=alien-macroinvertebrate-occurrences)
* Published [dataset on GBIF](https://doi.org/10.15468/xjtfoo)
* Article for this dataset:

> Boets P, Brosens D, Lock K, Adriaens T, Aelterman B, Mertens J & Goethals PLM (2016) Alien macroinvertebrates in Flanders (Belgium). Aquatic Invasions 11: 131-144. <https://doi.org/10.3391/ai.2016.11.2.03> <http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf>

### Checklist dataset

* Description of the [Darwin Core mapping](src/dwc_checklist.md) (= a rendition of the [mapping script](src/dwc_checklist.R))
* Generated [Darwin Core files](data/processed/dwc_checklist/)
* Published [dataset on the IPT](https://ipt.inbo.be/resource?r=alien-macroinvertebrates-checklist)
* Published [dataset on GBIF](https://doi.org/10.15468/yxcq07)

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

See the installation section of [alien-plants-belgium](https://github.com/trias-project/alien-plants-belgium/blob/master/README.md#installation).

## Contributors

[List of contributors](https://github.com/trias-project/alien-macroinvertebrates/contributors)

## License

[MIT License](LICENSE)
