# Script to tidy sutta data. ----------------------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(readr)

load("./data/sutta-translations/dataset_1/raw_sutta_data.Rda")
load("./data/sutta-html/dataset_1/sutta_html_data.Rda")


split_seg_id <- function (seg_id) {
  sutta <- str_extract(seg_id, "^.*(?=:)")
  
  num_id <- str_extract(seg_id, "(?<=:).*$")
  
  section_num <- num_id %>% str_extract("^.*(?=[.])")
  segment_num <- num_id %>% str_extract("(?=[0-9]+)[0-9]+$")
  
  paste(sutta, section_num, segment_num, sep = "|")
}


sutta_data <- raw_sutta_data %>%
  # Keep rows belonging to DN, MN, SN and AN.
  filter(grepl("(dn|mn|sn|an)[0-9]", segment_id)) %>% 
  
  # Split segment_id into sutta, section number and segment number.
  mutate(segment_id_copy = map_chr(segment_id, split_seg_id)) %>% 
  separate(segment_id_copy, into = c("sutta", "section_num", "segment_num"), sep = "[|]") %>% 
  
  # Extract nikaya (collection) and sutta number.
  mutate(collection = str_extract(sutta, "[a-z]+"),
         sutta_num = str_remove(sutta, "[a-z]+")) %>% 
  
  # Extract sutta titles.
  
  # Check the HTML markup for each segment.
  # Segments with the markup "class='sutta-title'" are titles.
  
  left_join(sutta_html_data, by = "segment_id") %>% 
  mutate(title = case_when(grepl("class='sutta-title'", html) ~ segment_text,
                           TRUE ~ NA_character_)) %>% 
  select(-html) %>% 
  fill(title, .direction = "down") %>%
  filter(section_num != "0") %>% 
  mutate(title = str_extract(title, "(?=[a-zA-Z]+).*$"),
         title = str_trim(title)) %>% 
  
  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>% 
  filter(segment_text != "") %>% 
  
  # Remove subheaders.
  filter(segment_num != "0") %>% 
  filter(!grepl(".*[.]0$", section_num)) 
  

dn_sutta_data <- sutta_data %>% filter(collection == "dn")
mn_sutta_data <- sutta_data %>% filter(collection == "mn")
sn_sutta_data <- sutta_data %>% filter(collection == "sn")
an_sutta_data <- sutta_data %>% filter(collection == "an")

# Save to disk.
save(sutta_data, file = "./data/sutta-translations/dataset_2/sutta_data.Rda")

write_tsv(dn_sutta_data, "./data/sutta-translations/dataset_2/dn_sutta_data.tsv")
write_tsv(mn_sutta_data, "./data/sutta-translations/dataset_2/mn_sutta_data.tsv")
write_tsv(sn_sutta_data, "./data/sutta-translations/dataset_2/sn_sutta_data.tsv")
write_tsv(an_sutta_data, "./data/sutta-translations/dataset_2/an_sutta_data.tsv")
