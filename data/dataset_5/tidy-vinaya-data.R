# Script to tidy vinaya data. ---------------------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(readr)

load("./data/dataset_2/raw_vinaya_data.Rda")


#

# pli-tv-bi-vb-as
# pli-tv-bi-vb-np
# pli-tv-bi-vb-pc
# pli-tv-bi-vb-pd
# pli-tv-bi-vb-pj
# pli-tv-bi-vb-sk
# pli-tv-bi-vb-ss
# pli-tv-bu-vb-as
# pli-tv-bu-vb-ay
# pli-tv-bu-vb-np
# pli-tv-bu-vb-pc
# pli-tv-bu-vb-pd
# pli-tv-bu-vb-pj
# pli-tv-bu-vb-sk
# pli-tv-bu-vb-ss
# pli-tv-kd      
# pli-tv-pvr 

# Vinaya rule classes.
vin_categories <- tribble(
  ~ cat_abb,       ~ vin_category,
  "pli-tv-bi-vb-as", "Adhikaraṇasamathā",
  "pli-tv-bi-vb-np", "Nissaggiyā Pācittiyā",
  "pli-tv-bi-vb-pc", "Pācittiyā",
  "pli-tv-bi-vb-pd", "Pāṭidesanīyā",
  "pli-tv-bi-vb-pj", "Pārājika",
  "pli-tv-bi-vb-sk", "Sekhiyā",
  "pli-tv-bi-vb-ss", "Saṅghādisesā",
  "pli-tv-bu-vb-as", "Adhikaraṇasamathā",
  "pli-tv-bu-vb-ay", "Aniyata",
  "pli-tv-bu-vb-np", "Nissaggiyā Pācittiyā",
  "pli-tv-bu-vb-pc", "Pācittiyā",
  "pli-tv-bu-vb-pd", "Pāṭidesanīyā",
  "pli-tv-bu-vb-pj", "Pārājika",
  "pli-tv-bu-vb-sk", "Sekhiyā",
  "pli-tv-bu-vb-ss", "Saṅghādisesā",
  "pli-tv-kd" ,      "Khandhaka",
  "pli-tv-pvr",      "Parivāra"
)



split_seg_id <- function (seg_id) {
  sutta <- str_extract(seg_id, "^.*(?=:)")
  
  num_id <- str_extract(seg_id, "(?<=:).*$")
  
  section_num <- num_id %>% str_extract("^.*(?=[.])")
  segment_num <- num_id %>% str_extract("(?=[0-9]+)[0-9]+$")
  
  paste(sutta, section_num, segment_num, sep = "|")
}


raw_vinaya_data %>% 
  
  # Split segment_id into sutta, section number and segment number.
  mutate(segment_id_copy = map_chr(segment_id, split_seg_id)) %>%
  separate(segment_id_copy, into = c("sutta", "section_num", "segment_num"), sep = "[|]") %>%

  # Extract vinaya category and sutta number.
  mutate(cat_abb = str_remove(sutta, "[0-9].*$")) %>%
  left_join(vin_categories, by = "cat_abb") %>%
  select(-cat_abb)
#   mutate(nikaya = str_extract(sutta, "[a-z]+"),
#          sutta_num = str_remove(sutta, "[a-z]+")) %>% 
#   
#   # Extract sutta titles.
#   
#   # DN:
#   # section_num = 0
#   #   segment_num = 1 -> sutta number
#   #   segment_num = 2 -> sutta title
#   
#   # MN:
#   # section_num = 0
#   #   segment_num = 1 -> sutta number
# #   segment_num = 2 -> sutta title
# 
# # SN:
# # section_num = 0
# #   segment_num = 1 -> samyutta number
# #   segment_num = 2 -> vagga title
# #   segment_num = 3 -> sutta title
# 
# # AN:
# # section_num = 0
# #   segment_num = 1 -> book number
# #   segment_num = 2 -> vagga title
# #   segment_num = 3 -> sutta title
# #   segment_num = 4 -> sutta subtitle
# 
# mutate(title = case_when(nikaya %in% c("dn", "mn") &
#                            section_num == "0" &
#                            segment_num == "2" ~ segment_text,
#                          nikaya %in% c("sn", "an") &
#                            section_num == "0" &
#                            segment_num == "3" ~ segment_text,
#                          TRUE ~ NA_character_)) %>% 
#   fill(title, .direction = "down") %>% 
#   filter(section_num != "0") %>% 
#   mutate(title = str_extract(title, "(?=[a-zA-Z]+).*$"),
#          title = str_trim(title)) %>% 
#   
#   # Remove blank rows.
#   mutate(segment_text = str_trim(segment_text)) %>% 
#   filter(segment_text != "") %>% 
#   
#   # Remove subheaders.
#   filter(segment_num != "0") %>% 
#   filter(!grepl(".*[.]0$", section_num)) %>% 
#   
#   # Rearrange data in order of suttas.
#   mutate(sutta_num_copy = str_replace(sutta_num, "-[0-9]{0,}", "")) %>% 
#   separate(sutta_num_copy, into = c("id1", "id2")) %>% 
#   replace_na(list(id2 = 0)) %>%
#   mutate(id1 = as.numeric(id1),
#          id2 = as.numeric(id2)) %>%
#   arrange(factor(nikaya, levels = c("dn", "mn", "sn", "an")), id1, id2) %>% 
#   select(-id1, -id2)
# 
# 
# dn_sutta_data <- sutta_data %>% filter(nikaya == "dn")
# mn_sutta_data <- sutta_data %>% filter(nikaya == "mn")
# sn_sutta_data <- sutta_data %>% filter(nikaya == "sn")
# an_sutta_data <- sutta_data %>% filter(nikaya == "an")

# Save to disk.
# save(sutta_data, file = "./data/dataset_3/sutta_data.Rda")
# 
# write_tsv(dn_sutta_data, "./data/dataset_3/dn_sutta_data.tsv")
# write_tsv(mn_sutta_data, "./data/dataset_3/mn_sutta_data.tsv")
# write_tsv(sn_sutta_data, "./data/dataset_3/sn_sutta_data.tsv")
# write_tsv(an_sutta_data, "./data/dataset_3/an_sutta_data.tsv")
