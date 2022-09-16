read_dm <- function(dir) {
  companies <- path(dir, "companies.csv") |>
    read_csv(col_types = cols_companies())

  categories <- path(dir, "categories.csv") |>
    read_csv(col_types = cols_categories())

  dm(companies, categories) |>
    dm_add_pk(companies, companies_id) |>
    dm_add_fk(categories, companies_id, companies)
}

#' Column specifications for each dataset
#'
#' @seealso vroom::cols()
cols_companies <- function() {
  cols(
    companies_id = pull_from_dictionary("companies", "companies_id", "type"),
    information = pull_from_dictionary("companies", "information", "type")
  )
}

cols_categories <- function() {
  cols(
    companies_id = pull_from_dictionary("categories", "companies_id", "type"),
    sector = pull_from_dictionary("categories", "sector", "type")
  )
}
