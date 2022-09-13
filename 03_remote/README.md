
``` r
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
```

# Remote databases

Packages.

``` r
library(dm, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
```

Data.

``` r
companies <- tribble(
  # styler: off
  ~companies_id,                                 ~information,
              1,    "alpha sells solar panels and wind mills",
              2, "beta sells steel and installs solar panels",
  # styler: on
)

categories <- tribble(
  # styler: off
  ~companies_id,       ~sector,
              1,      "energy",
              2,  "metallurgy",
              2,      "energy",
              3, "agriculture",
  # styler: on
)
```

``` r
database = dm(companies, categories)

# Or you may save it to a remote database
path = tempfile(fileext = ".sqlite")
connection = DBI::dbConnect(RSQLite::SQLite(), dbname = path)
connection
#> <SQLiteConnection>
#>   Path: /tmp/Rtmp6s5ZEW/filefe62e1efff8.sqlite
#>   Extensions: TRUE

connection |>
  copy_dm_to(database, temporary = FALSE)

connection |> DBI::dbListTables()
#> [1] "categories" "companies"
tbl(connection, "companies")
#> # Source:   table<companies> [2 x 2]
#> # Database: sqlite 3.39.1 [/tmp/Rtmp6s5ZEW/filefe62e1efff8.sqlite]
#>   companies_id information                               
#>          <dbl> <chr>                                     
#> 1            1 alpha sells solar panels and wind mills   
#> 2            2 beta sells steel and installs solar panels
tbl(connection, "categories")
#> # Source:   table<categories> [4 x 2]
#> # Database: sqlite 3.39.1 [/tmp/Rtmp6s5ZEW/filefe62e1efff8.sqlite]
#>   companies_id sector     
#>          <dbl> <chr>      
#> 1            1 energy     
#> 2            2 metallurgy 
#> 3            2 energy     
#> 4            3 agriculture
```
