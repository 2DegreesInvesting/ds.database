pull_from_dictionary = function(dataset, dataset_column, dictionary_column) {
  dictionary |>
    filter(.data$dataset == .env$dataset) |>
    filter(.data$column == .env$column) |>
    pull(.data[[dictionary_column]])
}
