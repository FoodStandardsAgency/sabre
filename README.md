
# sabre

<!-- badges: start -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Travis build status](https://travis-ci.org/FoodStandardsAgency/sabre.svg?branch=main)](https://travis-ci.org/github/FoodStandardsAgency/sabre)
[![Codecov test coverage](https://codecov.io/gh/FoodStandardsAgency/sabre/branch/main/graph/badge.svg)](https://codecov.io/gh/FoodStandardsAgency/sabre?branch=master)
[![R build status](https://github.com/FoodStandardsAgency/sabre/workflows/R-CMD-check/badge.svg)](https://github.com/FoodStandardsAgency/sabre/actions)
[![stability-unstable](https://img.shields.io/badge/stability-unstable-yellow.svg)](https://github.com/emersion/stability-badges#unstable)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/FoodStandardsAgency/sabre/HEAD)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/FoodStandardsAgency/sabre/HEAD?filepath=%2Fbinder%2Fbasics.ipynb)
<!-- badges: end -->

Sabre is a toolbox to ease and standardize the cleaning of business and address records.  


## Installation

### Github install

```r
library(devtools)
install_github("FoodStandardsAgency/sabre")
```

### CRAN install

> **Not available just yet.**
> You can install the released version of sabre from [CRAN](https://CRAN.R-project.org) with:
> ``` r
> install.packages("sabre")
> ```

## Example

Replace special characters in strings and melt columns on separators.

|postcode |trading_name                                |
|:--------|:-------------------------------------------|
|B42 1AB  |Cosy café @ The horse and hound             |
|B25      |Food Zone t/a ReFood                        |
|G12 0ZS  |Hocus Pocus t/aVan Leer                     |
|SE16 1BE |Media Luna Bakery Ltd trading as Media Luna |
|EC2M 1AA |t/a Pharmacy Doherty                        |

``` r
library(sabre)

melt_rows(
  businesses[4:8, 3:4],
  "trading_name",
  dividers = c("\\|", " trading as ", "t/a", "\\/")
  ) %>%
  dplyr::mutate_at(., "trading_name", ~replace_in_string(., "@", "")) %>%
  dplyr::mutate_at(., "trading_name", strip_business_legal_entity_type) %>%
  dplyr::mutate_at(., "trading_name", stringr::str_squish)
```

|postcode |trading_name                  |
|:--------|:-----------------------------|
|B42 1AB  |Cosy café The horse and hound |
|B25      |Food Zone                     |
|B25      |ReFood                        |
|G12 0ZS  |Hocus Pocus                   |
|G12 0ZS  |Van Leer                      |
|SE16 1BE |Media Luna Bakery             |
|SE16 1BE |Media Luna                    |
|EC2M 1AA |Pharmacy Doherty              |
