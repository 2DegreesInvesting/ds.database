test_that("pulls the expected values", {
  expect_equal(
    pull_from_dictionary("companies", "companies_id", "enforce_unique"),
    TRUE
  )
  expect_equal(
    pull_from_dictionary("categories", "companies_id", "type"),
    "character"
  )
})
