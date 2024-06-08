# Script to tidy KN sutta data. -------------------------------------------

library(dplyr)
library(stringr)
library(tidyr)
library(readr)

load("./data/sutta-translations/dataset_1/raw_sutta_data.Rda")
load("./data/html/dataset_1/sutta_html.Rda")


kn_sutta_data <- raw_sutta_data %>% 
  # Keep rows belonging to KN.
  filter(!grepl("(dn|mn|sn|an)[0-9]", segment_id)) %>% 
  
  # Extract sutta, section number and segment number.
  
  # KN segment numbering:
  
  # dhp: [sutta]:[segment_num]
  # Headings and subheadings of dhp have 0-th level numbering. (eg: 0.1)
  
  # All other texts follow [sutta]:[section_num].[segment_num]
  # Except for thag which has 2 segments with 0-th level segment numbers.
  
  mutate(sutta = str_extract(segment_id, "^.*(?=:)"),
         section_num = case_when(grepl("dhp", sutta) ~ str_extract(segment_id, "(?<=dhp).*(?=:)"),
                                 grepl("thag1.1:1.0.", segment_id) ~ "1",
                                 TRUE ~ str_extract(segment_id, "(?<=:).*(?=[.])")),
         segment_num = case_when(grepl("dhp", sutta) ~ str_extract(segment_id, "(?<=:).*$"),
                                 grepl("thag1.1:1.0.", segment_id) ~ str_extract(segment_id, "0\\.[0-9]+$"),
                                 TRUE ~ str_extract(segment_id, "(?<=[:.])[0-9]+$"))) %>% 
  
  # Extract nikaya (collection) and sutta number.
  mutate(collection = str_extract(sutta, "[a-z]+"),
         sutta_num = str_remove(sutta, "[a-z]+")) %>% 
  
  # Extract sutta titles.
  
  # Check the HTML markup for each segment.
  # Segments with the markup "class='sutta-title'" are titles.
  
  left_join(sutta_html, by = "segment_id") %>% 
  mutate(title = case_when(grepl("class='sutta-title'", html) ~ segment_text,
                           TRUE ~ NA_character_)) %>% 
  select(-html) %>% 
  fill(title, .direction = "down") %>% 
  
  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>%
  filter(segment_text != "") %>% 
  
  # Remove subheaders.
  filter(section_num != "0") %>% 
  filter(!str_detect(segment_num, "0."))


# Save to disk.
save(kn_sutta_data, file = "./data/sutta-translations/dataset_3/kn_sutta_data.Rda")

write_tsv(kn_sutta_data, "./data/sutta-translations/dataset_3/kn_sutta_data.tsv")