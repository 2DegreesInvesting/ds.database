
# Relational data with dplyr

``` r
library(dplyr, warn.conflicts = FALSE)
```

### Overview

[Relational data](https://r4ds.had.co.nz/relational-data.html):

-   A collection of related tables of data.

``` r
companies <- tribble(
  ~companies_id,                                 ~information,
              1,    "alpha sells solar panels and wind mills",
              2, "beta sells steel and installs solar panels",
)

categories <- tribble(
  ~companies_id,       ~sector,
              1,      "energy",
              2,  "metallurgy",
              2,      "energy",
              3, "agriculture",
)
```

-   The relations are always defined, between a pair of tables, by the
    keys.

``` r
key  <- "companies_id"

companies |>
  left_join(categories, by = key)
#> # A tibble: 3 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy
```

-   A realistic example:

![](https://d33wubrfki0l68.cloudfront.net/245292d1ea724f6c3fd8a92063dcd7bfb9758d02/5751b/diagrams/relational-nycflights.png)

### Types of joins

**Mutating joins** add columns and …:

-   [Inner
    Join](https://r4ds.had.co.nz/relational-data.html#mutating-joins):
    -   `inner_join()`: Drops unmatched rows.
-   [Outter
    joins](https://r4ds.had.co.nz/relational-data.html#outer-join):
    -   `left_join(x, y)`: Keeps all rows in `x` (most common).
    -   `right_join(x, y)`: Keeps all rows in `y`.
    -   `full_join(x, y)`: Keeps all rows in `x` and `y`.

**Filtering joins** affect observations, not variables.

-   `semi_join(x, y)`: Keeps all observations in `x` that have a match
    in `y`.
-   `anti_join(x, y)`: Drops all observations in `x` that have a match
    in `y`.

–

#### Inner join

![](https://d33wubrfki0l68.cloudfront.net/3abea0b730526c3f053a3838953c35a0ccbe8980/7f29b/diagrams/join-inner.png)

``` r
companies |>
  inner_join(categories, by = "companies_id")
#> # A tibble: 3 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy
```

#### Outter joins

![](https://d33wubrfki0l68.cloudfront.net/9c12ca9e12ed26a7c5d2aa08e36d2ac4fb593f1e/79980/diagrams/join-outer.png)

``` r
companies |>
  left_join(categories, by = "companies_id")
#> # A tibble: 3 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy

companies |>
  right_join(categories, by = "companies_id")
#> # A tibble: 4 × 3
#>   companies_id information                                sector     
#>          <dbl> <chr>                                      <chr>      
#> 1            1 alpha sells solar panels and wind mills    energy     
#> 2            2 beta sells steel and installs solar panels metallurgy 
#> 3            2 beta sells steel and installs solar panels energy     
#> 4            3 <NA>                                       agriculture

companies |>
  full_join(categories, by = "companies_id")
#> # A tibble: 4 × 3
#>   companies_id information                                sector     
#>          <dbl> <chr>                                      <chr>      
#> 1            1 alpha sells solar panels and wind mills    energy     
#> 2            2 beta sells steel and installs solar panels metallurgy 
#> 3            2 beta sells steel and installs solar panels energy     
#> 4            3 <NA>                                       agriculture
```

#### Filtering joins

![](https://d33wubrfki0l68.cloudfront.net/028065a7f353a932d70d2dfc82bc5c5966f768ad/85a30/diagrams/join-semi.png)

``` r
categories |> 
  semi_join(companies)
#> Joining, by = "companies_id"
#> # A tibble: 3 × 2
#>   companies_id sector    
#>          <dbl> <chr>     
#> 1            1 energy    
#> 2            2 metallurgy
#> 3            2 energy
```

![](https://d33wubrfki0l68.cloudfront.net/f29a85efd53a079cc84c14ba4ba6894e238c3759/c1408/diagrams/join-anti.png)

``` r
categories |> 
  anti_join(companies)
#> Joining, by = "companies_id"
#> # A tibble: 1 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            3 agriculture
```

### Duplicate keys

-   Duplicate keys in one table

![](https://d33wubrfki0l68.cloudfront.net/6faac3e996263827cb57fc5803df6192541a9a4b/c7d74/diagrams/join-one-to-many.png)

``` r
companies2 <- companies |>
  bind_rows(tibble(companies_id = 1L, information = "abc"))

companies2 |>
  left_join(categories)
#> Joining, by = "companies_id"
#> # A tibble: 4 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy    
#> 4            1 abc                                        energy
```

-   Duplicate keys in both tables

![](https://d33wubrfki0l68.cloudfront.net/d37530bbf7749f48c02684013ae72b2996b07e25/37510/diagrams/join-many-to-many.png)

``` r
categories2 <- categories |>
  bind_rows(tibble(companies_id = 1L, sector = "xyz"))

companies2 |>
  left_join(categories2)
#> Joining, by = "companies_id"
#> # A tibble: 6 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            1 alpha sells solar panels and wind mills    xyz       
#> 3            2 beta sells steel and installs solar panels metallurgy
#> 4            2 beta sells steel and installs solar panels energy    
#> 5            1 abc                                        energy    
#> 6            1 abc                                        xyz
```

### Validating keys

To avoid [join
problems](https://r4ds.had.co.nz/relational-data.html#join-problems) you
should validate some properties of the keys:

-   All values of a primary key should be unique.

``` r
companies |>
  count(companies_id) |>
  filter(n > 1)
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, n <int>
#> # ℹ Use `colnames()` to see all variable names

# (!) The `companies_id` column is NOT a primary key of `categories`
categories |>
  count(companies_id) |>
  filter(n > 1)
#> # A tibble: 1 × 2
#>   companies_id     n
#>          <dbl> <int>
#> 1            2     2
```

-   No value of a primary key should be missing.

``` r
companies |>
  filter(is.na(companies_id))
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, information <chr>
#> # ℹ Use `colnames()` to see all variable names
```

-   All values of a foreign key should match a value of a primary key.

``` r
# ! Problem: Invalid foreign key
anti_join(categories, companies, by = "companies_id")
#> # A tibble: 1 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            3 agriculture
```
