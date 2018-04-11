# Alien macroinvertebrates

## Rationale

This repository contains the functionality to standardize the data of [Boets et al. (2016)](http://www.aquaticinvasions.net/2016/AI_2016_Boets_etal.pdf) to both a [Darwin Core checklist](https://www.gbif.org/dataset-classes) and [Darwin Core occurrence dataset](https://www.gbif.org/dataset-classes) that can be harvested by [GBIF](http://www.gbif.org). The repository also contains the code for a [website](http://trias-project.github.io/alien-macroinvertebrates/map.html) to explore the occurrence data. It was developed for the [TrIAS project](http://trias-project.be).

## Workflow

* Checklist dataset: [source data](https://github.com/trias-project/alien-macroinvertebrates/blob/master/data/raw/AI_2016_Boets_etal_Supplement.xls) → Darwin Core [mapping script](http://trias-project.github.io/alien-macroinvertebrates/dwc_checklist.html) → generated [Darwin Core files](https://github.com/trias-project/alien-macroinvertebrates/blob/master/data/processed/dwc_checklist)
* Occurrence dataset: [source data](https://github.com/trias-project/alien-macroinvertebrates/blob/master/data/raw/denormalized_observations.csv) → Darwin Core [mapping script](http://trias-project.github.io/alien-macroinvertebrates/dwc_occurrence.html) → generated [Darwin Core files](https://github.com/trias-project/alien-macroinvertebrates/tree/master/data/processed/dwc_occurrence)

## Published datasets

* [Checklist dataset on the IPT](https://ipt.inbo.be/resource?r=alien-macroinvertebrates-checklist)
* [Checklist dataset on GBIF](https://doi.org/10.15468/yxcq07)

---

* [Occurrence dataset on the IPT](https://ipt.inbo.be/resource?r=alien-macroinvertebrate-occurrences)
* [Occurrence dataset on GBIF](https://doi.org/10.15468/xjtfoo)

## Repo structure

The repository structure is based on [Cookiecutter Data Science](http://drivendata.github.io/cookiecutter-data-science/). Files and directories indicated with `GENERATED` should not be edited manually.

```
├── README.md         : Description of this repository
├── LICENSE           : Repository license
├── .gitignore        : Files and directories to be ignored by git
│
├── data
│   ├── raw           : Source data, input for mapping script
│   └── processed     : Darwin Core output of mapping script GENERATED
│
├── docs              : Repository website GENERATED
│
├── specifications    : Data specifications for the Darwin Core files
│
└── src
    ├── dwc_checklist.Rmd  : Darwin Core mapping script for checklist dataset
    ├── dwc_occurrence.Rmd : Darwin Core mapping script for occurrence dataset
    └── src.Rproj          : RStudio project file
```

## Installation

1. Clone this repository to your computer
2. Open the RStudio project file
3. Open the `dwc_checklist.Rmd` or `dwc_occurrence.Rmd` [R Markdown file](https://rmarkdown.rstudio.com/) in RStudio
4. Install any required packages
5. Click `Run > Run All` to generate the processed data
6. Alternatively, click `Build > Build website` to generate the processed data and build the website in `/docs`

## Contributors

[List of contributors](https://github.com/trias-project/alien-macroinvertebrates/contributors)

## License

[MIT License](https://github.com/trias-project/alien-macroinvertebrates/blob/master/LICENSE)
