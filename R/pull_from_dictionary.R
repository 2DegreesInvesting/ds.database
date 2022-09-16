pull_from_dictionary = function(dataset, column, pull) {
  dictionary |>
    filter(.data$dataset == .env$dataset) |>
    filter(.data$column == .env$column) |>
    pull(.data[[pull]])
}
