dictionary <- function() {
  # styler: off
  tibble::tribble(
        ~dataset,        ~column,       ~type, ~enforce_unique, ~allow_missing,
     "companies", "companies_id", "character",            TRUE,          FALSE,
     "companies",  "information", "character",           FALSE,          FALSE,
    "categories", "companies_id", "character",            TRUE,          FALSE,
    "categories",       "sector", "character",           FALSE,          FALSE
  )
  # styler: on
}
