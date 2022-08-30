
# Relational data with dplyr

``` r
library(dplyr, warn.conflicts = FALSE)
```

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

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

### Mutating joins

Add new variables to one data frame from matching observations in
another.

–

[Inner
join](https://r4ds.had.co.nz/relational-data.html#mutating-joins): Drop
unmatched rows.

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

[Outter joins](https://r4ds.had.co.nz/relational-data.html#outer-join):

-   Keep all rows in `x` (most common).

``` r
companies |>
  left_join(categories, by = "companies_id")
#> # A tibble: 3 × 3
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels metallurgy
#> 3            2 beta sells steel and installs solar panels energy
```

-   Keep all rows in `y`

``` r
companies |>
  right_join(categories, by = "companies_id")
#> # A tibble: 4 × 3
#>   companies_id information                                sector     
#>          <dbl> <chr>                                      <chr>      
#> 1            1 alpha sells solar panels and wind mills    energy     
#> 2            2 beta sells steel and installs solar panels metallurgy 
#> 3            2 beta sells steel and installs solar panels energy     
#> 4            3 <NA>                                       agriculture
```

-   Keep all rows in `x` and `y`

``` r
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

-   [Duplicate
    keys](https://r4ds.had.co.nz/relational-data.html#join-matches)

``` r
# Duplicate keys in one table
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

# Duplicate keys in both tables
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

### Filtering joins

Affect observations, not variables:

-   Keep all observations in `x` that have a match in `y`.

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

-   Drop all observations in `x` that have a match in `y`.

``` r
categories |> 
  anti_join(companies)
#> Joining, by = "companies_id"
#> # A tibble: 1 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            3 agriculture
```

### Validating keys to avoid [join problems](https://r4ds.had.co.nz/relational-data.html#join-problems)

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
