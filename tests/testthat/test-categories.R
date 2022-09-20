test_that("`companies_id` is complete", {
  expect_false(anyNA(categories$companies_id))
})

test_that("all companies in `categories` exist in `companieas`", {
  expect_true(all(categories$companies_id %in% companies$companies_id))
})
