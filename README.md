# googleAnalyticsRETL

## Purpose
This is an R package to help optimize and scale two types of workflows involving Google Analytics (GA) and Google Cloud Platform (GCP): 

1. Data ETL: for data feed or report data automation with BigQuery (BQ) or Google Cloud Storage (GCS) as data destinations 
2. Shiny apps or dashboards: that fetch, cache and back up GA data, hosted in GCP 

It is built on top of the [`googleAuthRverse`](https://docs.google.com/forms/d/e/1FAIpQLSerjirmMpB3b7LmBs_Vx_XPIE9IrhpCpPg1jUcpfBcivA3uBw/viewform) packages by [Mark Edmondson](https://github.com/MarkEdmondson1234)

Please add any feedback or ideas via the [issues](https://github.com/justinjm/googleAnalyticsRETL/issues)

**Note:** This is experimental and not recommended for production use yet

# Installation

## CRAN
This package is not yet available on CRAN.

## GitHub
To install the latest, potentially unstable version directly from GitHub:

```r
if(!require("remotes")){
    install.packages("remotes")
}
remotes::install_github("justinjm/googleAnalyticsRETL")
```

## Resources

* [googleAuthR](https://github.com/MarkEdmondson1234/googleAuthR)
* [googleAnalyticsR](https://github.com/MarkEdmondson1234/googleAnalyticsR)
* [Mark Edmondson](https://github.com/MarkEdmondson1234)

