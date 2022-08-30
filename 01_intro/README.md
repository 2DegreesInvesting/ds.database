
# Introduction to relational data with dplyr

``` r
library(tidyverse, warn.conflicts = FALSE)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
#> ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
#> ✔ tibble  3.1.8     ✔ dplyr   1.0.9
#> ✔ tidyr   1.2.0     ✔ stringr 1.4.0
#> ✔ readr   2.1.2     ✔ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
```

## Relational data

-   A collection of related tables of data.
-   The relations are always defined between a pair of tables, by the
    keys.

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
companies
#> # A tibble: 2 × 2
#>   companies_id information                               
#>          <dbl> <chr>                                     
#> 1            1 alpha sells solar panels and wind mills   
#> 2            2 beta sells steel and installs solar panels

categories
#> # A tibble: 3 × 2
#>   companies_id sector    
#>          <dbl> <chr>     
#> 1            1 energy    
#> 2            2 metallurgy
#> 3            2 energy

key <- "companies_id"
left_join(companies, categories, by = key)
#> # A tibble: 3 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy
```

``` r
companies |> 
  count(companies_id) |> 
  filter(n > 1)
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, n <int>
#> # ℹ Use `colnames()` to see all variable names

categories |> 
  count(companies_id) |> 
  filter(n > 1)
#> # A tibble: 1 × 2
#>   companies_id     n
#>          <dbl> <int>
#> 1            2     2
```

TODO:

-   Introduce toy dataset.
-   Show relationship with dm

## Types of joins

**Mutating join** add new variables to one data frame from matching
observations in another.

-   Inner

TODO SHOW EXAMPLE WITH TOY DATASET

-   Outter

TODO SHOW EXAMPLE WITH TOY DATASET

-   Duplicate keys

**Filtering joins** filter observations from one data frame based on
whether or not they match an observation in the other table.

TODO SHOW EXAMPLE WITH TOY DATASET

Filtering joins, which filter observations from one data frame based on
whether or not they match an observation in the other table.

TODO SHOW EXAMPLE WITH TOY DATASET
