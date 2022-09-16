# has the expected column types (1)

    Code
      lapply(dm, function(.x) lapply(.x, typeof))
    Output
      $companies
      $companies$companies_id
      [1] "character"
      
      $companies$information
      [1] "character"
      
      
      $categories
      $categories$companies_id
      [1] "character"
      
      $categories$sector
      [1] "character"
      
      

