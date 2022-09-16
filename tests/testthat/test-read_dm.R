test_that("has the expected column types (1)", {
  dm = read_dm(test_path("db"))
  expect_snapshot(lapply(dm, function(.x) lapply(.x, typeof)))
})

test_that("has the expected column types (2)", {
  dm = read_dm(test_path("db"))

  expect_type(dm$companies$companies_id, "character")
  expect_type(dm$companies$information, "character")

  expect_type(dm$categories$companies_id, "character")
  expect_type(dm$categories$sector, "character")
})

