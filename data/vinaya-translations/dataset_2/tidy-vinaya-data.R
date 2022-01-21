# Script to tidy vinaya data. ---------------------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(readr)

load("./data/dataset_2/raw_vinaya_data.Rda")


# Function to split segment ID into sutta, section number and segment number.
split_seg_id <- function (seg_id) {
  sutta <- str_extract(seg_id, "^.*(?=:)")
  
  num_id <- str_extract(seg_id, "(?<=:).*$")
  
  section_num <- num_id %>% str_extract("^.*(?=[.])")
  segment_num <- num_id %>% str_extract("(?=[0-9]+)[0-9]+$")
  
  paste(sutta, section_num, segment_num, sep = "|")
}


# Vinaya category levels.
vin_levels <- c(
  "pli-tv-bi-vb-as",
  "pli-tv-bi-vb-np",
  "pli-tv-bi-vb-pc",
  "pli-tv-bi-vb-pd",
  "pli-tv-bi-vb-pj",
  "pli-tv-bi-vb-sk",
  "pli-tv-bi-vb-ss",
  "pli-tv-bu-vb-as",
  "pli-tv-bu-vb-ay",
  "pli-tv-bu-vb-np",
  "pli-tv-bu-vb-pc",
  "pli-tv-bu-vb-pd",
  "pli-tv-bu-vb-pj",
  "pli-tv-bu-vb-sk",
  "pli-tv-bu-vb-ss",
  "pli-tv-kd" ,
  "pli-tv-pvr"
)


vinaya_data <- raw_vinaya_data %>%

  # Split segment_id into sutta, section number and segment number.
  mutate(segment_id_copy = map_chr(segment_id, split_seg_id)) %>%
  separate(segment_id_copy, into = c("sutta", "section_num", "segment_num"), sep = "[|]") %>%

  # Extract vinaya category.
  mutate(collection = str_extract(sutta, "(?<=pli-tv-).*?(?=[0-9])")) %>%

  # Extract sutta number.
  mutate(sutta_num = str_remove(sutta, ".*?(?=[0-9])")) %>%

  # Extract sutta titles.

  # Segment numbers containing the title for each category is as follows:
  # pli-tv-bi-vb-as -> [sutta]:0.3
  # pli-tv-bu-vb-as -> [sutta]:0.3
  # pli-tv-bi-vb-np -> [sutta]:0.5
  # pli-tv-bu-vb-np -> [sutta]:0.5
  # pli-tv-bi-vb-pc -> [sutta]:0.5
  # pli-tv-bu-vb-pc -> [sutta]:0.5
  # pli-tv-bi-vb-pd -> [sutta]:0.4
  # pli-tv-bu-vb-pd -> [sutta]:0.4
  # pli-tv-bi-vb-pj -> [sutta]:0.4
  # pli-tv-bu-vb-pj -> [sutta]:0.4
  # pli-tv-bi-vb-sk -> [sutta]:0.5
  # pli-tv-bu-vb-sk -> [sutta]:0.5
  # pli-tv-bi-vb-ss -> [sutta]:0.4
  # pli-tv-bu-vb-ss -> [sutta]:0.4
  # pli-tv-bu-vb-ay -> [sutta]:0.4
  # pli-tv-kd       -> [sutta]:0.3
  # pli-tv-pvr      -> [sutta]:0.4

  mutate(title = case_when(grepl("(as|kd)", segment_id) &
                             section_num == "0" &
                             segment_num == "3" ~ segment_text,
                           grepl("(np|pc|sk)", segment_id) &
                             section_num == "0" &
                             segment_num == "5" ~ segment_text,
                           grepl("(pd|pj|ss|ay|pvr)", segment_id) &
                             section_num == "0" &
                             segment_num == "5" ~ segment_text,
                           TRUE ~ NA_character_)) %>%
  fill(title, .direction = "down") %>%
  filter(section_num != "0") %>%
  mutate(title = str_extract(title, "(?=[a-zA-Z]+).*$"),
         title = str_trim(title)) %>%

  # Remove blank rows.
  mutate(segment_text = str_trim(segment_text)) %>%
  filter(segment_text != "") %>%

  # Remove subheaders.

  # The part of the segment ID after the semicolon can have up to 4 dots.
  # i.e up to 5 separated numerical values.
  # In all cases it's a subheading when either the last or penultimate separated value is 0.
  filter(!grepl(".*([:.]0.[0-9]+|[.]0)$", segment_id)) %>%

  # Rearrange data in order of suttas.
  arrange(factor(str_remove(segment_id, "[0-9].*$"), levels = vin_levels),
          as.numeric(sutta_num))

# Save to disk.
save(vinaya_data, file = "./data/dataset_5/vinaya_data.Rda")

write_tsv(vinaya_data, "./data/dataset_5/vinaya_data.tsv")
