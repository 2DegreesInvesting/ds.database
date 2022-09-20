# styler: off
companies <- tibble::tribble(
  ~companies_id,                                 ~information,
  1,    "alpha sells solar panels and wind mills",
  2, "beta sells steel and installs solar panels"
)
# styler: on

use_data(companies, overwrite = TRUE)
