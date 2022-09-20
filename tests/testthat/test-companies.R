test_that("`companies_id` is unique", {
  expect_equal(anyDuplicated(companies$companies_id), 0L)
})

test_that("`companies_id` is complete", {
  expect_false(anyNA(companies$companies_id))
})
