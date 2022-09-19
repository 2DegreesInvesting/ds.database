library(here)
library(vroom)

dictionary <- vroom(here("data-raw", "dictionary.tsv"), col_types = "ccccll")
use_data(dictionary, overwrite = TRUE)
