library(dplyr)
library(httr)

data_path <- "https://raw.githubusercontent.com/benmneb/pts-converter/master/src/data/pts_lookup.json"


pts_map <- GET(data_path) %>% 
  content(as = "parsed", type = "application/json")

pts_map[[20]] %>%
    lapply(function (x) tibble(segment_id = x[[1]][1], pts_id = x[[2]][1])) %>% 
    do.call("bind_rows", .)


pts_map %>% 
  lapply(., function (x) {
    lapply(x, function (x) {
      tibble(segment_id = x[[1]][1],
             pts_id = x[[2]][1]) %>% 
      do.call("bind_rows", .)
    })
  })


  
pts_map[[1]] %>%
  lapply(function (x) tibble(a = unlist(x))) %>% bind_rows()
