
# Relational data with dm

The dm package:

-   Makes it easy to create, visualize, check, and use complex datasets.
-   Plays well with dplyr.

``` r
library(dm, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
```

Example dataset with two tables.

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
              3, "agriculture",  # Bad
)
```

A data model (dm) is like a named list.

``` r
dm <- dm(companies, categories)

dm$companies
#> # A tibble: 2 × 2
#>   companies_id information                               
#>          <dbl> <chr>                                     
#> 1            1 alpha sells solar panels and wind mills   
#> 2            2 beta sells steel and installs solar panels

dm$categories
#> # A tibble: 4 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            1 energy     
#> 2            2 metallurgy 
#> 3            2 energy     
#> 4            3 agriculture
```

But also has with special features:

-   It can store the relationships between tables via primary and
    foreign keys.

``` r
dm2 <- dm |>
  dm_add_pk(companies, companies_id) |>
  dm_add_fk(categories, companies_id, companies)

dm2
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `companies`, `categories`
#> Columns: 4
#> Primary keys: 1
#> Foreign keys: 1
```

-   It makes it easy to draw and understand the relationship between
    tables.

``` r
dm2 |>
  dm_draw()
```

![](README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

-   It makes it easy to examine the constraints of you data:

    -   Each value of a primary key should be unique.
    -   Each value of a primary key should be not missing.
    -   Each value of a foreign key should match a value in its primary
        key.

``` r
dm2 |>
  dm_examine_constraints()
#> ! Unsatisfied constraints:
#> • Table `categories`: foreign key `companies_id` into table `companies`: values of `categories$companies_id` not in `companies$companies_id`: 3 (1)
```

(Doing this “by hand” with dplyr is a lot harder.)

``` r
# Expect no duplicates
# Good
dm2$companies |>
  count(companies_id) |>
  filter(n > 1)
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, n <int>

# Expect no missing values
# Good
dm2$companies |>
  filter(is.na(companies_id))
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, information <chr>

# Expect no miss-match
# Bad
dm2$categories |>
  anti_join(dm2$companies, by = "companies_id")
#> # A tibble: 1 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            3 agriculture
```

-   It makes it easy to join multiple tables.

``` r
dm2 |>
  dm_flatten_to_tbl(.start = categories, .recursive = TRUE)
#> # A tibble: 4 × 3
#>   companies_id sector      information                               
#>          <dbl> <chr>       <chr>                                     
#> 1            1 energy      alpha sells solar panels and wind mills   
#> 2            2 metallurgy  beta sells steel and installs solar panels
#> 3            2 energy      beta sells steel and installs solar panels
#> 4            3 agriculture <NA>
```

-   It allows you to manipulate tables with functions from dplyr or
    similar.

``` r
dm3 <- dm2 |>
  dm_zoom_to(categories) |> 
  filter(companies_id != 3) |> 
  dm_update_zoomed()

# Same
dm3 <- dm2 |> 
  dm_filter(categories = (companies_id != 3))

dm3 |> 
  dm_examine_constraints()
#> ℹ All constraints satisfied.
```

Learn more: <https://cynkra.github.io/dm/>

### Questions

Can dm check:

1.  constraints in columns other than the keys? E.g. allow only 1 or 0.
2.  column type?
3.  unique and composite unique constraints?
