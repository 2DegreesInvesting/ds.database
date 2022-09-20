# styler: off
categories <- tibble::tribble(
  ~companies_id,      ~sector,
  1,     "energy",
  2, "metallurgy",
  2,     "energy",
  3,     "energy", # Problem!
)
# styler: on

use_data(categories, overwrite = TRUE)
