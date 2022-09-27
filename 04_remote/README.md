
# Using the dm package with a Relational Database Management System (RDBMS)

Packages.

``` r
library(dm, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(DBI)
library(RSQLite)
library(here)
#> here() starts at /home/rstudio/git/ds.database
```

The dm package make it easy to deploy a data model to a Relational
Database Management System (RDBMS).

### Deploy a data model to a RDBMS

-   If you have an RDBMS (an SQLite file) …

``` r
# See arguments to dbConnect() or the relevant driver at ?RSQLite::RSQLite()
database_file <- here("04_remote", "database.sqlite")
connection <- DBI::dbConnect(RSQLite::SQLite(), dbname = database_file)
connection
#> <SQLiteConnection>
#>   Path: /home/rstudio/git/ds.database/04_remote/database.sqlite
#>   Extensions: TRUE
```

-   … and you have a data model …

``` r
# styler: off
companies <- tribble(

  ~companies_id,                                 ~information,
              1,    "alpha sells solar panels and wind mills",
              2, "beta sells steel and installs solar panels",
)

categories <- tribble(
  ~companies_id,       ~sector,
              1,      "energy",
              2,  "metallurgy",
              2,      "energy",
)
# styler: on

dm <- dm(companies, categories)
```

-   … then you can easily deploy the data model to the RDBMS with the dm
    package.

``` r
copy_dm_to(connection, dm, temporary = FALSE)
DBI::dbDisconnect(connection)
```

### Using a data model from a RDBMS

``` r
# Helper
companies_dm <- function(connection) {
  dm(
    companies = connection |> tbl("companies"),
    categories = connection |> tbl("categories")
  ) |>
    dm_add_pk(companies, companies_id) |>
    dm_add_fk(categories, companies_id, companies)
}

database_file <- here("04_remote", "database.sqlite")
connection <- DBI::dbConnect(RSQLite::SQLite(), dbname = database_file)

dm <- companies_dm(connection)
dm |> dm_examine_constraints()
#> ℹ All constraints satisfied.
dm |> dm_flatten_to_tbl(.start = categories)
#> # Source:   SQL [3 x 3]
#> # Database: sqlite 3.39.2 [/home/rstudio/git/ds.database/04_remote/database.sqlite]
#>   companies_id sector     information                               
#>          <dbl> <chr>      <chr>                                     
#> 1            1 energy     alpha sells solar panels and wind mills   
#> 2            2 metallurgy beta sells steel and installs solar panels
#> 3            2 energy     beta sells steel and installs solar panels

connection |> DBI::dbDisconnect()
```
