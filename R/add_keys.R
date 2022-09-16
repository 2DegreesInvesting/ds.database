add_keys = function(dm) {
  dm |>
    dm::dm_add_pk(companies, companies_id) |>
    dm::dm_add_fk(categories, companies_id, companies)
}
