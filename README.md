originr
========



[![cran checks](https://cranchecks.info/badges/worst/originr)](https://cranchecks.info/pkgs/originr)
[![R-check](https://github.com/ropensci/originr/workflows/R-check/badge.svg)](https://github.com/ropensci/originr/actions?query=workflow%3AR-check)
[![codecov.io](https://codecov.io/github/ropensci/originr/coverage.svg?branch=master)](https://codecov.io/github/ropensci/originr?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/originr)](https://github.com/r-hub/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/originr)](https://cran.r-project.org/package=originr)

Species Origin Data

Data sources:

* Encyclopedia of Life http://eol.org
* Flora Europaea http://rbg-web2.rbge.org.uk/FE/fe.html
* Global Invasive Species Database http://www.iucngisd.org/gisd
* Native Species Resolver http://bien.nceas.ucsb.edu/bien/tools/nsr/nsr-ws/
* Integrated Taxonomic Information Service http://www.itis.gov/
* Global Register of Introduced and Invasive Species http://www.griis.org/

## Install

Stable CRAN version


```r
install.packages("originr")
```

Development version


```r
remotes::install_github("ropensci/originr")
```


```r
library("originr")
```

## EOL invasive species datasets

Datasets included:

* `gisd100` - 100 of the World's Worst Invasive Alien Species
(Global Invasive Species Database) http://eol.org/collections/54500
* `gisd` - Global Invasive Species Database 2013 http://eol.org/collections/54983
* `isc` - Centre for Agriculture and Biosciences International Invasive Species
Compendium (ISC) http://eol.org/collections/55180
* `daisie` - Delivering Alien Invasive Species Inventories for Europe (DAISIE) Species
List http://eol.org/collections/55179
* `i3n` - IABIN Invasives Information Network (I3N) Species
http://eol.org/collections/55176
* `mineps` - Marine Invaders of the NE Pacific Species http://eol.org/collections/55331

An example using `mineps`


```r
eol(name='Ciona intestinalis', dataset='mineps')
#>        searched_name               name eol_object_id     db
#> 1 Ciona intestinalis Ciona intestinalis           NaN mineps
```

## Native Species Resolver


```r
nsr("Pinus ponderosa", "United States")
#>     family genus         species       country state_province county_parish
#> 1 Pinaceae Pinus Pinus ponderosa United States
#>   native_status native_status_reason native_status_sources isIntroduced
#> 1             N     Native to region                                  0
#>   isCultivated
#> 1            0
```

## Global Invasive Species Database


```r
sp <- c("Carpobrotus edulis", "Rosmarinus officinalis")
gisd(sp)
#> $`Carpobrotus edulis`
#> $`Carpobrotus edulis`$species
#> [1] "Carpobrotus edulis"
#> 
#> $`Carpobrotus edulis`$alien_range
#>  [1] "albania"          "argentina"        "australia"        "bermuda"         
#>  [5] "chile"            "croatia"          "france"           "french polynesia"
#>  [9] "germany"          "gibraltar"        "greece"           "guernsey"        
#> [13] "ireland"          "italy"            "malta"            "mexico"          
#> [17] "new zealand"      "pitcairn"         "portugal"         "saint helena"    
#> [21] "spain"            "tunisia"          "united kingdom"   "united states"   
#> 
#> $`Carpobrotus edulis`$native_range
#> character(0)
#> 
#> 
#> $`Rosmarinus officinalis`
#> $`Rosmarinus officinalis`$species
#> [1] "Rosmarinus officinalis"
#> 
#> $`Rosmarinus officinalis`$status
#> [1] "Not in GISD"
```

## Flora Europaea


```r
flora_europaea("Lavandula stoechas")
#> $native
#>  [1] "Islas_Baleares" "Corse"          "Kriti"          "France"        
#>  [5] "Greece"         "Spain"          "Italy"          "Portugal"      
#>  [9] "Sardegna"       "Sicilia"        "Turkey"        
#> 
#> $exotic
#> [1] NA
#> 
#> $status_doubtful
#> [1] NA
#> 
#> $occurrence_doubtful
#> [1] NA
#> 
#> $extinct
#> [1] NA
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/originr/issues).
* License: MIT
* Get citation information for `originr` in R doing `citation(package = 'originr')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.
