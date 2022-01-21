# Script to tidy sutta data. ----------------------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(readr)

load("./data/dataset_1/raw_sutta_data.Rda")


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
  
  # DN:
  # section_num = 0
  #   segment_num = 1 -> sutta number
  #   segment_num = 2 -> sutta title
  
  # MN:
  # section_num = 0
  #   segment_num = 1 -> sutta number
  #   segment_num = 2 -> sutta title
  
  # SN:
  # section_num = 0
  #   segment_num = 1 -> samyutta number
  #   segment_num = 2 -> vagga title
  #   segment_num = 3 -> sutta title
  
  # AN:
  # section_num = 0
  #   segment_num = 1 -> book number
  #   segment_num = 2 -> vagga title
  #   segment_num = 3 -> sutta title
  #   segment_num = 4 -> sutta subtitle
  
  mutate(title = case_when(collection %in% c("dn", "mn") &
                             section_num == "0" &
                             segment_num == "2" ~ segment_text,
                           collection %in% c("sn", "an") &
                             section_num == "0" &
                             segment_num == "3" ~ segment_text,
                           TRUE ~ NA_character_)) %>% 
  fill(title, .direction = "down") %>% 
  filter(section_num != "0") %>% 
  mutate(title = str_extract(title, "(?=[a-zA-Z]+).*$"),
         title = str_trim(title)) %>% 
  
  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>% 
  filter(segment_text != "") %>% 
  
  # Remove subheaders.
  filter(segment_num != "0") %>% 
  filter(!grepl(".*[.]0$", section_num)) %>% 
  
  # Rearrange data in order of suttas.
  mutate(sutta_num_copy = str_replace(sutta_num, "-[0-9]{0,}", "")) %>% 
  separate(sutta_num_copy, into = c("id1", "id2")) %>% 
  replace_na(list(id2 = 0)) %>%
  mutate(id1 = as.numeric(id1),
         id2 = as.numeric(id2)) %>%
  arrange(factor(collection, levels = c("dn", "mn", "sn", "an")), id1, id2) %>% 
  select(-id1, -id2)
  

dn_sutta_data <- sutta_data %>% filter(collection == "dn")
mn_sutta_data <- sutta_data %>% filter(collection == "mn")
sn_sutta_data <- sutta_data %>% filter(collection == "sn")
an_sutta_data <- sutta_data %>% filter(collection == "an")

# Save to disk.
save(sutta_data, file = "./data/dataset_3/sutta_data.Rda")

write_tsv(dn_sutta_data, "./data/dataset_3/dn_sutta_data.tsv")
write_tsv(mn_sutta_data, "./data/dataset_3/mn_sutta_data.tsv")
write_tsv(sn_sutta_data, "./data/dataset_3/sn_sutta_data.tsv")
write_tsv(an_sutta_data, "./data/dataset_3/an_sutta_data.tsv")
