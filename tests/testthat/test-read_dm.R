# + Easy to write
# - Error prone: Requires careful inspection.
test_that("has the expected column types (1)", {
  dm <- read_dm(test_path("db"))
  expect_snapshot(lapply(dm, function(.x) lapply(.x, typeof)))
})

# + Granular to the column level
# - Not super friendly to review for non-coders
test_that("has the expected column types (2)", {
  dm <- read_dm(test_path("db"))

  expect_type(dm$companies$companies_id, "character")
  expect_type(dm$companies$information, "character")

  expect_type(dm$categories$companies_id, "character")
  expect_type(dm$categories$sector, "character")
})

# + The single source of truth (the dictionary) is easy to share and review
# + Easy to adapt for other checks
# - Requires more infrastructure
test_that("has the expected column types (3)", {
  dm <- read_dm(test_path("db"))

  dm$companies$companies_id |>
    expect_type(pull_from_dictionary("companies", "companies_id", "type"))

  dm$companies$information |>
    expect_type(pull_from_dictionary("companies", "information", "type"))

  dm$categories$companies_id |>
    expect_type(pull_from_dictionary("categories", "companies_id", "type"))

  dm$categories$sector |>
    expect_type(pull_from_dictionary("categories", "sector", "type"))
})

