# Script to match PTS refs to segment IDs. --------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)

load("./data/references/dataset_1/sutta_refs.Rda")
load("./data/references/dataset_2/vinaya_refs.Rda")

load("./data/dataset_6/sutta_characters.Rda")


# Books:
# DN, MN, SN, AN
# Dhp, Snp, It, Thig, Thag, Ud
# Vin

match_refs <- function (ref) {
  ref_regex <- "(?<=class='ref'>).*?(?=[<\U{2013}])"
  
  ref %>% 
    regmatches(., gregexec(ref_regex, ., perl = TRUE)) %>% 
    unlist() %>% 
    as_tibble() %>% 
    rename(ref = value)
}


refs_df <- sutta_refs %>% 
  bind_rows(vinaya_refs) %>% 
  filter(grepl("pts-vp-pli", edition))


pts_refs_df <- sutta_characters %>% 
  select(desc) %>% 
  mutate(matches = map(desc, match_refs)) %>% 
  unnest(cols = matches)

pts_to_segid <- function(pts_ref) {
  ref_split <- pts_ref %>% 
    str_split("\\.")
  
  if (ref_split[1] %in% c("DN", "MN", "SN", "AN", "Vin")) {
    
  }
  
}

