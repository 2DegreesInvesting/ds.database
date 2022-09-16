cols_companies <- function() {
  vroom::cols(
    companies_id = vroom::col_character(),
    information = vroom::col_character()
  )
}

cols_categories <- function() {
  vroom::cols(
    companies_id = vroom::col_character(),
    sector = vroom::col_character()
  )
}
