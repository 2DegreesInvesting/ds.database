get_type = function(dataset, column) {
  dictionary |>
    filter(.data$dataset == .env$dataset) |>
    filter(.data$column == .env$column) |>
    pull(type)
}
