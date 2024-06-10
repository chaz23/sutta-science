library(dplyr)
library(tidytext)
library(stringi)

load("./data/sutta-translations/dataset_2/sutta_data.Rda")
load("./data/sutta-translations/dataset_3/kn_sutta_data.Rda")
load("./data/vinaya-translations/dataset_2/vinaya_data.Rda")
load("./data/dataset_6/sutta_characters.Rda")

# Add anathapindika and migara??

# Errors: 
# Sundarika - class=person - its a river.
# id Revata1 and Revata2 are the same person?
# Bhagu, atthaka have two entries with the same ID
# MN116 make sure I've got the pacceka buddhas correctly
# Check that I've got the entries of mara and brahma correct
# Should I put the names of the people whose monastery it was (eg Anathapindikas monastery)
# Should I include suddhodhana and migaras mother
# Add entries for the classes of devas

df <- sutta_data %>% 
  bind_rows(kn_sutta_data) %>% 
  bind_rows(vinaya_data)

# List of people who
matched <- df %>% 
  unnest_tokens(word, segment_text) %>% 
  mutate(word_trans = stri_trans_general(word, "latin-ascii")) %>%
  left_join(sutta_characters, by = "word_trans") %>% 
  filter(!is.na(id)) %>% 
  distinct(name) %>% 
  arrange(name)

sutta_characters %>% 
  filter(grepl("mara", word_trans)) %>% 
  mutate(id_trans = stri_trans_general(id, "latin-ascii")) %>% 
  select(id_trans, name, desc)
  
mn_characters <- readr::read_csv(file = "./data/pali-proper-names/dataset_1/characters_of_the_mn.csv")


mn_characters %>% distinct(character_id)
















