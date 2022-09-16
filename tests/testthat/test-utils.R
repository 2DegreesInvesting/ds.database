test_that("companies have the expected column types", {
  companies <- read_companies(test_path("db", "companies.csv"))
  expect_snapshot(lapply(companies, typeof))
})

test_that("categories have the expected column types", {
  categories <- read_categories(test_path("db", "categories.csv"))
  expect_type(categories$companies_id, "character")
  expect_type(categories$sector, "character")
})
