
``` r
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
```

# Relational data with dm

Packages.

``` r
library(dm, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
```

Data.

``` r
companies <- tribble(
  # styler: off
  ~companies_id,                                 ~information,
              1,    "alpha sells solar panels and wind mills",
              2, "beta sells steel and installs solar panels",
  # styler: on
)

categories <- tribble(
  # styler: off
  ~companies_id,       ~sector,
              1,      "energy",
              2,  "metallurgy",
              2,      "energy",
              3, "agriculture",
  # styler: on
)
```

A data model (dm) is like a list.

``` r
database = dm(companies, categories)

database$companies
#> # A tibble: 2 × 2
#>   companies_id information                               
#>          <dbl> <chr>                                     
#> 1            1 alpha sells solar panels and wind mills   
#> 2            2 beta sells steel and installs solar panels

database$categories
#> # A tibble: 4 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            1 energy     
#> 2            2 metallurgy 
#> 3            2 energy     
#> 4            3 agriculture
```

For example, using the dm as a list you may examine keys constrains with
dplyr.

``` r
# No primary-key value should be duplicated
database$companies |>
  count(companies_id) |>
  filter(n > 1)
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, n <int>
#> # ℹ Use `colnames()` to see all variable names

# No primary-key value should be missing
database$companies |>
  filter(is.na(companies_id))
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, information <chr>
#> # ℹ Use `colnames()` to see all variable names

# Each foreign-key value should match a primary key value
# Problem!
categories |>
  anti_join(companies, by = "companies_id")
#> # A tibble: 1 × 2
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            3 agriculture

# Fix
categories |>
  filter(companies_id != 3) |> 
  anti_join(companies, by = "companies_id")
#> # A tibble: 0 × 2
#> # … with 2 variables: companies_id <dbl>, sector <chr>
#> # ℹ Use `colnames()` to see all variable names
```

But the dm has dedicated features that make it easier to work with it.

``` r
database
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `companies`, `categories`
#> Columns: 4
#> Primary keys: 0
#> Foreign keys: 0

# Add the primary key (pk) and the foreign key (fk)
database2 = database |>
  dm_add_pk(companies, companies_id) |>
  dm_add_fk(categories, companies_id, companies)
database2
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `companies`, `categories`
#> Columns: 4
#> Primary keys: 1
#> Foreign keys: 1

# Examine constraints
database2 |>
  dm_examine_constraints()
#> ! Unsatisfied constraints:
#> • Table `categories`: foreign key `companies_id` into table `companies`: values of `categories$companies_id` not in `companies$companies_id`: 3 (1)
# Fix
database3 = database2 |>
  dm_filter(categories = (companies_id != 3))
database3 |>
  dm_examine_constraints()
#> ℹ All constraints satisfied.

# Other cool things you can do
database3 |>
  dm_flatten_to_tbl(categories, .recursive = TRUE)
#> # A tibble: 3 × 3
#>   companies_id sector     information                               
#>          <dbl> <chr>      <chr>                                     
#> 1            1 energy     alpha sells solar panels and wind mills   
#> 2            2 metallurgy beta sells steel and installs solar panels
#> 3            2 energy     beta sells steel and installs solar panels
```

You may persist the dm by saving it to an R object.

``` r
path = tempfile(fileext = ".rds")
saveRDS(database3, path)
# And later read it back into R
readRDS(path)
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `companies`, `categories`
#> Columns: 4
#> Primary keys: 1
#> Foreign keys: 1
```
