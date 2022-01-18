# Script to tidy KN sutta data. -------------------------------------------

library(dplyr)
library(stringr)
library(tidyr)
library(readr)

load("./data/dataset_1/raw_sutta_data.Rda")


sutta_data <- raw_sutta_data %>% 
  # Keep rows belonging to KN.
  filter(!grepl("(dn|mn|sn|an)[0-9]", segment_id)) %>% 
  
  # Extract sutta, section number and segment number.
  
  # KN segment numbering:
  
  # dhp: [sutta]:[segment_num]
  # Headings and subheadings of dhp have 0-th level numbering. (eg: 0.1)
  
  # All other texts follow [sutta]:[section_num].[segment_num]
  # Except for thag which has 2 segments with 0-th level segment numbers.
  
  mutate(sutta = str_extract(segment_id, "^.*(?=:)"),
         section_num = case_when(grepl("dhp", sutta) ~ NA_character_,
                                 grepl("thag1.1:1.0.", segment_id) ~ "1",
                                 TRUE ~ str_extract(segment_id, "(?<=:).*(?=[.])")),
         segment_num = case_when(grepl("dhp", sutta) ~ str_extract(segment_id, "(?<=:).*$"),
                                 grepl("thag1.1:1.0.", segment_id) ~ str_extract(segment_id, "0\\.[0-9]+$"),
                                 TRUE ~ str_extract(segment_id, "(?<=[:.])[0-9]+$"))) %>% 
  
  # Extract nikaya and sutta number.
  mutate(nikaya = str_extract(sutta, "[a-z]+"),
         sutta_num = str_remove(sutta, "[a-z]+")) %>% 
  
  # Extract sutta titles.
  
  # Titles are:
  # dhp: segment_num = 0.3
  # thig: [section_num].[segment_num] = 0.3
  # iti: [section_num].[segment_num] = 0.4
  # thag: [section_num].[segment_num] = 0.4
  # snp: [section_num].[segment_num] = 0.2
  # ud: [section_num].[segment_num] = 0.2
  # kp: [section_num].[segment_num] = 0.2
  
  mutate(title = case_when(nikaya %in% c("dhp") & segment_num == "0.3" ~ segment_text,
                           nikaya %in% c("thig") & section_num == "0" &
                             segment_num == "3" ~ segment_text,
                           nikaya %in% c("iti", "thag") & section_num == "0" & 
                             segment_num == "4" ~ segment_text,
                           nikaya %in% c("snp", "ud", "kp") & section_num == "0" & 
                             segment_num == "2" ~ segment_text,
                           TRUE ~ NA_character_)) %>% 
  fill(title, .direction = "down") %>% 
  
  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>%
  filter(segment_text != "") %>% 
  
  # Remove subheaders.
  filter(section_num != "0") %>% 
  filter(!str_detect(segment_num, "0.")) %>% 
  
  # Rearrange data in order of suttas.
  arrange(factor(nikaya, levels = c("dhp", "iti", "kp", "snp", "thag", "thig", "ud")), 
          as.numeric(sutta_num),
          as.numeric(section_num),
          as.numeric(segment_num))


# Save to disk.
save(sutta_data, file = "./data/dataset_4/kn_sutta_data.Rda")

write_tsv(sutta_data, "./data/dataset_4/kn_sutta_data.tsv")
