
# Using a Relational Database Management System (RDBMS)

Packages.

``` r
library(DBI)
library(RSQLite)
library(dm, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(here)
#> here() starts at /home/rstudio/git/ds.database
```

### Deploy a data model to a RDBMS

If you have an RDBMS (an SQLite file) …

``` r
# See arguments to dbConnect() at ?RSQLite::RSQLite()
database_file <- here("04_rdbms", "database.sqlite")
connection <- RSQLite::SQLite() |> 
  DBI::dbConnect(dbname = database_file)
connection
#> <SQLiteConnection>
#>   Path: /home/rstudio/git/ds.database/04_rdbms/database.sqlite
#>   Extensions: TRUE
```

… and you have a data model …

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

… then you can easily deploy the data model to the RDBMS with
`dm::copy_dm_to()`:

-   Defaults to creating temporary tables
-   Sets primary key constraints on all databases
-   Sets foreign key constraints are set on MSSQL and Postgres
    databases.

``` r
connection |> 
  copy_dm_to(dm, temporary = FALSE)
```

Once you’re finish working with the database, you should disconnect.

``` r
connection |> 
  DBI::dbDisconnect()
```

### Using the RDBMS

Connect to the RDBMS.

``` r
database_file <- here("04_rdbms", "database.sqlite")
connection <- RSQLite::SQLite() |> 
  DBI::dbConnect(dbname = database_file)
```

Use it with [dplyr](https://dplyr.tidyverse.org/) (and
[dbplyr](https://dbplyr.tidyverse.org/) in the backend) (meetup 1).

``` r
connection |> DBI::dbListTables()
#> [1] "categories" "companies"

companies <- connection |> 
  dplyr::tbl("companies")
categories <- connection |> 
  dplyr::tbl("categories")

companies |> 
  left_join(categories, by = "companies_id")
#> # Source:   SQL [3 x 3]
#> # Database: sqlite 3.39.2 [/home/rstudio/git/ds.database/04_rdbms/database.sqlite]
#>   companies_id information                                sector    
#>          <dbl> <chr>                                      <chr>     
#> 1            1 alpha sells solar panels and wind mills    energy    
#> 2            2 beta sells steel and installs solar panels energy    
#> 3            2 beta sells steel and installs solar panels metallurgy
```

Use it with [dm](https://github.com/cynkra/dm) (meetup 2).

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

dm <- connection |> 
  companies_dm()
dm
#> ── Table source ────────────────────────────────────────────────────────────────
#> src:  sqlite 3.39.2 [/home/rstudio/git/ds.database/04_rdbms/database.sqlite]
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `companies`, `categories`
#> Columns: 4
#> Primary keys: 1
#> Foreign keys: 1

dm |> 
  dm_flatten_to_tbl(.start = categories)
#> # Source:   SQL [3 x 3]
#> # Database: sqlite 3.39.2 [/home/rstudio/git/ds.database/04_rdbms/database.sqlite]
#>   companies_id sector     information                               
#>          <dbl> <chr>      <chr>                                     
#> 1            1 energy     alpha sells solar panels and wind mills   
#> 2            2 metallurgy beta sells steel and installs solar panels
#> 3            2 energy     beta sells steel and installs solar panels
```

``` r
connection |> 
  DBI::dbDisconnect()
```
