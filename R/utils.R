cols_companies = function(path) {
  vroom::cols(
    companies_id = vroom::col_character(),
    information = vroom::col_character()
  )
}

cols_categories = function(path) {
  vroom::cols(
    companies_id = vroom::col_character(),
    sector = vroom::col_character()
  )
}
