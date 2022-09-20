
# Validating data quality

## The [pointblank](https://rich-iannone.github.io/pointblank/) package

![](data-validation-workflow.png)

### Demo

Packages

``` r
library(pointblank)
library(tibble)
```

Data

``` r
# styler: off
companies <- tibble::tribble(
  ~companies_id,                                 ~information,
              1,    "alpha sells solar panels and wind mills",
              2, "beta sells steel and installs solar panels"
)

categories <- tibble::tribble(
  ~companies_id,      ~sector,
              1,     "energy",
              2, "metallurgy",
              2,     "energy",
              3,     "energy"
)
# styler: on
```

Validation

``` r
agent <- categories |>
  create_agent(actions = action_levels(warn_at = 1, stop_at = 2))

plan <- agent |>
  col_vals_not_null(columns = "companies_id") |>
  col_vals_in_set(columns = "companies_id", set = unique(companies$companies_id)) |>
  col_is_numeric(columns = "companies_id") |>
  rows_distinct(columns = names(categories))

plan |>
  interrogate()
```

### [More workflows](https://rich-iannone.github.io/pointblank/articles/validation_workflows.html)

![](all-workflows.png)

Helper

``` r
validate_companies <- function(x) {
  x |>
    col_vals_not_null(columns = "companies_id") |>
    col_vals_in_set(
      columns = "companies_id", 
      set = unique(companies$companies_id),
      actions = action_levels(warn_at = 1)
    ) |>
    col_is_numeric(columns = "companies_id") |>
    rows_distinct(columns = names(categories))
}
```

Main workflows:

-   Data quality: Output a validation report

``` r
categories |> 
  create_agent() |> 
  validate_companies() |> 
  interrogate()
```

-   ETL: Output a validated dataset

``` r
categories |> 
  validate_companies()
```

Secondary workflows: Generally I prefer lower-level, developer oriented
tools

``` r
data = tibble(x = "1")

data |> col_is_numeric("x")

# Tests
data |> test_col_is_numeric("x")

data[["x"]] |> is.numeric()

# Expectations
testthat::test_that("is numeric", {
  data |> expect_col_is_numeric("x")
})

testthat::test_that("is numeric", {
  data[["x"]] |> is.numeric() |> testthat::expect_true()
})
```
