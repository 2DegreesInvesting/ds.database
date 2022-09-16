read_dm = function(dir) {
  companies = path(dir, "companies.csv") |>
    read_csv(col_types = cols_companies())

  categories = path(dir, "categories.csv") |>
    read_csv(col_types = cols_categories())

  dm(companies, categories) |>
    dm_add_pk(companies, companies_id) |>
    dm_add_fk(categories, companies_id, companies)
}

cols_companies <- function() {
  cols(
    companies_id = col_character(),
    information = col_character()
  )
}

cols_categories <- function() {
  cols(
    companies_id = col_character(),
    sector = col_character()
  )
}
