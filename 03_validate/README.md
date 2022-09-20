
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
              3,     "energy", # Problem!
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
validate_categories <- function(x) {
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
  validate_categories() |> 
  interrogate()
```

-   ETL: Output a validated dataset

``` r
categories |> 
  validate_categories()
```

Secondary workflows: Generally I prefer lower-level, developer oriented
tools

-   Unit testing

``` r
data <- tibble(x = "1")

testthat::test_that("is numeric", {
  data |> expect_col_is_numeric("x")
})
#> ── Failure (<text>:4:3): is numeric ────────────────────────────────────────────
#> Failure to validate that column `x` is of type: numeric.
#> The `expect_col_is_numeric()` validation failed beyond the absolute threshold level (1).
#> * failure level (1) >= failure threshold (1)
#> Error in `reporter$stop_if_needed()`:
#> ! Test failed

testthat::test_that("is numeric", {
  data[["x"]] |> is.numeric() |> testthat::expect_true()
})
#> ── Failure (<text>:8:3): is numeric ────────────────────────────────────────────
#> is.numeric(data[["x"]]) is not TRUE
#> 
#> `actual`:   FALSE
#> `expected`: TRUE
#> Error in `reporter$stop_if_needed()`:
#> ! Test failed
```

-   Conditional code

``` r
data |> test_col_is_numeric("x")
#> [1] FALSE

data[["x"]] |> is.numeric()
#> [1] FALSE
```

### Interfaces for gathering requirements

-   [Write an `agent` to
    yaml](https://rich-iannone.github.io/pointblank/reference/yaml_write.html#writing-an-agent-object-to-a-yaml-file)

``` r
create_agent(~categories) |> 
  validate_categories() |> 
  yaml_write(filename = "requirements.yml")
#> ✔ The agent YAML file has been written to `requirements.yml`
```

    type: agent
    tbl: ~categories
    tbl_name: ~categories
    label: '[2022-09-20|14:52:02]'
    lang: en
    locale: en
    steps:
    - col_vals_not_null:
        columns: vars(companies_id)
    - col_vals_in_set:
        columns: vars(companies_id)
        set:
        - 1.0
        - 2.0
        actions:
          warn_count: 1.0
    - col_is_numeric:
        columns: vars(companies_id)
    - rows_distinct:
        columns: vars(companies_id, sector)

-   Use a data dictionary
    ([example](https://docs.google.com/spreadsheets/d/1WWuwgZXFg2EfnfwBB6oR4JNhykYmRq8kmEoIVsYhafA/edit#gid=1425673786))

| dataset    | column       | definition                                   | type      | enforce_unique | allow_missing |
|:-----------|:-------------|:---------------------------------------------|:----------|:---------------|:--------------|
| companies  | companies_id | identifier of each company                   | character | TRUE           | FALSE         |
| companies  | information  | information about each company               | character | FALSE          | FALSE         |
| categories | companies_id | identifier of each company                   | character | TRUE           | FALSE         |
| categories | sector       | a sector in which a company is does business | character | FALSE          | FALSE         |
