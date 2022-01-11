# Script to tidy sutta data for analysis. ---------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(readr)

load("./data/dataset_1/raw_sutta_data.Rda")

sutta_data <- raw_sutta_data %>% 
  mutate(segment_id_copy = segment_id) %>% 
  
  # Split segment_id into discourse and ID.
  separate(segment_id_copy, into = c("discourse", "id"), sep = ":") %>% 
  
  # Extract nikaya and discourse number.
  mutate(nikaya = str_extract(discourse, "[a-z][a-z]"),
         discourse_num = str_remove(discourse, "[a-z][a-z]")) %>% 
  
  # Extract paragraph and sentence IDs.
  separate(id, into = c("paragraph_id", "sentence_id"), sep = "\\.", extra = "merge") %>% 
  
  # Extract sutta titles.
  
  # DN:
  # paragraph_id = 0
  #   sentence_id = 1 -> sutta number
  #   sentence_id = 2 -> sutta title
  
  # MN:
  # paragraph_id = 0
  #   sentence_id = 1 -> sutta number
  #   sentence_id = 2 -> sutta title
  
  # SN:
  # paragraph_id = 0
  #   sentence_id = 1 -> samyutta number
  #   sentence_id = 2 -> vagga title
  #   sentence_id = 3 -> sutta title
  
  # AN:
  # paragraph_id = 0
  #   sentence_id = 1 -> book number
  #   sentence_id = 2 -> vagga title
  #   sentence_id = 3 -> sutta title
  #   sentence_id = 4 -> sutta subtitle
  
  mutate(title = case_when(nikaya %in% c("dn", "mn") &
                             paragraph_id == "0" &
                             sentence_id == "2" ~ segment_text,
                           nikaya %in% c("sn", "an") &
                             paragraph_id == "0" &
                             sentence_id == "3" ~ segment_text,
                           TRUE ~ NA_character_)) %>% 
  fill(title, .direction = "down") %>% 
  filter(paragraph_id != "0") %>% 
  separate(title, into = c("title1", "title2"), sep = "\\.") %>% 
  mutate(title1 = case_when(is.na(title2) ~ title1,
                            TRUE ~ title2),
         sutta_title = title1) %>% 
  select(-title1, -title2) %>% 
  
  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>% 
  filter(segment_text != "") %>% 
  
  # Remove subheaders.
  filter(sentence_id != "0") %>% 
  
  # Rearrange data in order of suttas.
  mutate(discourse_num = str_replace(discourse_num, "-[0-9]{0,}", "")) %>% 
  mutate(discourse_num_copy = discourse_num) %>% 
  separate(discourse_num_copy, into = c("id1", "id2")) %>% 
  replace_na(list(id2 = 0)) %>%
  mutate(id1 = as.numeric(id1),
         id2 = as.numeric(id2)) %>%
  arrange(factor(nikaya, levels = c("dn", "mn", "sn", "an")), id1, id2) %>% 
  select(-id1, -id2)

dn_sutta_data <- sutta_data %>% filter(nikaya == "dn")
mn_sutta_data <- sutta_data %>% filter(nikaya == "mn")
sn_sutta_data <- sutta_data %>% filter(nikaya == "sn")
an_sutta_data <- sutta_data %>% filter(nikaya == "an")

# Save to disk.
save(sutta_data, file = "./data/dataset_2/sutta_data.Rda")

write_tsv(dn_sutta_data, "./data/dataset_2/dn_sutta_data.tsv")
write_tsv(mn_sutta_data, "./data/dataset_2/mn_sutta_data.tsv")
write_tsv(sn_sutta_data, "./data/dataset_2/sn_sutta_data.tsv")
write_tsv(an_sutta_data, "./data/dataset_2/an_sutta_data.tsv")
