library(tidyverse, warn.conflicts = FALSE)
library(pointblank)

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
  3, "energy",
)

### Overview ----

# You can build a clear data validation plan and report

# Report data

al = action_levels(
  warn_at = 0.2,
  stop_at = 0.3,
  notify_at = 0.1
)
validation_plan <- companies |>
  create_agent(actions = al) |>
  col_exists(vars(companies_id)) |>
  col_exists(vars("bad")) |>
  col_exists(vars("bad2")) |>
  col_is_character(companies_id)


validation_plan |>
  interrogate()

# There are other use cases but already there are good tools for them:

# You can write functions with pointblank
validate_companies <- function(data) {
  if (!test_col_is_character(data, "companies_id")) {
    stop("`comanies_id` must be of type character")
  }

  invisible(data)
}

# But you may prefer lower level tools
validate_companies <- function(data) {
  vctrs::vec_assert(data$companies_id, "character")

  invisible(data)
}

companies |> validate_companies()

# You can write tests with pointblank
testthat::test_that("in `companies`, `companies_id` is of type character", {
  expect_col_is_character(companies)
})

# But you may prefer lower level tools
testthat::test_that("in `companies`, `companies_id` is of type character", {
  testthat::expect_type(companies$companies_id, "character")
})

# install.packages("ggforce")
companies |> scan_data()

agent = companies |> create_agent()



### Data quality workflow ----

companies |>
  draft_validation()

# companies.R
writeLines(readLines("companies.R"))

categories |>
  draft_validation()

# companies.R
writeLines(readLines("categories.R"))

