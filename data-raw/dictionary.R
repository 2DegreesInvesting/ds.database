library(here)
library(vroom)

dictionary <- vroom(here("data-raw", "dicionary.tsv"), col_types = "cccccc")
use_data(dictionary, overwrite = TRUE)
