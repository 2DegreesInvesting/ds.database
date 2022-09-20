library(here)
library(vroom)

# https://docs.google.com/spreadsheets/d/1WWuwgZXFg2EfnfwBB6oR4JNhykYmRq8kmEoIVsYhafA/edit#gid=1425673786
dictionary <- vroom(here("data-raw", "dictionary.tsv"), col_types = "ccccll")
use_data(dictionary, overwrite = TRUE)
