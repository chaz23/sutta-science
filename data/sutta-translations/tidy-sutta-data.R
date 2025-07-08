library(dplyr)
library(stringr)
library(tidyr)
library(purrr)

load(
  url(
    "https://github.com/chaz23/sutta-science/raw/main/data/sutta-translations/raw_sutta_data.Rda"
  )
)
load(
  url(
    "https://github.com/chaz23/sutta-science/raw/main/data/html/sutta_html.Rda"
  )
)

load(
  url(
    "https://github.com/chaz23/sutta-science/raw/main/data/sutta-hierarchy/sutta_hierarchy.Rda"
  )
)




# Take this part from https://github.com/chaz23/sutta-science/blob/main/data/sutta-translations/tidy-sutta-data.R ----

split_seg_id <- function(seg_id) {
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
  separate(
    segment_id_copy,
    into = c("sutta", "section_num", "segment_num"),
    sep = "[|]"
  ) %>%
  # Extract nikaya (collection) and sutta number.
  mutate(
    collection = str_extract(sutta, "[a-z]+"),
    sutta_num = str_remove(sutta, "[a-z]+")
  )




# Take this part from https://github.com/chaz23/sutta-science/blob/main/data/sutta-translations/tidy-kn-sutta-data.R ----

kn_sutta_data <- raw_sutta_data %>%
  # Keep rows belonging to KN.
  filter(!grepl("(dn|mn|sn|an)[0-9]", segment_id)) %>%
  # Extract sutta, section number and segment number.
  
  # KN segment numbering:
  
  # dhp: [sutta]:[segment_num]
  # Headings and subheadings of dhp have 0-th level numbering. (eg: 0.1)
  
  # All other texts follow [sutta]:[section_num].[segment_num]
  # Except for thag which has 2 segments with 0-th level segment numbers.
  
  mutate(
    sutta = str_extract(segment_id, "^.*(?=:)"),
    section_num = case_when(
      grepl("dhp", sutta) ~ str_extract(segment_id, "(?<=dhp).*(?=:)"),
      grepl("thag1.1:1.0.", segment_id) ~ "1",
      TRUE ~ str_extract(segment_id, "(?<=:).*(?=[.])")
    ),
    segment_num = case_when(
      grepl("dhp", sutta) ~ str_extract(segment_id, "(?<=:).*$"),
      grepl("thag1.1:1.0.", segment_id) ~ str_extract(segment_id, "0\\.[0-9]+$"),
      TRUE ~ str_extract(segment_id, "(?<=[:.])[0-9]+$")
    )
  ) %>%
  # Extract nikaya (collection) and sutta number.
  mutate(
    collection = str_extract(sutta, "[a-z]+"),
    sutta_num = str_remove(sutta, "[a-z]+")
  ) %>%
  filter(collection %in% c("kp", "dhp", "ud", "iti", "snp", "thag", "thig", "cp"))




# Put it together. ----

# Because some suttas do not match values in the hierarchy dataset.
# Eg: an1.1 belongs under an1.1-10
sub_id_list <- sutta_hierarchy %>%
  filter(node_type == "leaf") %>%
  select(id) %>%
  filter(str_detect(id, "-")) %>%
  mutate(sub_ids = map(id, ~ {
    range <- str_extract(.x, "(?<=(\\.|dhp)).+(?<=[0-9])")
    range_start <- str_split(range, "-")[[1]][1]
    range_end <- str_split(range, "-")[[1]][2]
    sub_id_range <- as.numeric(range_start):as.numeric(range_end)
    base_string <- str_extract(.x, ".*(?<=(\\.|dhp))")
    sub_ids <- paste0(base_string, sub_id_range)
    tibble(sub_id = sub_ids)
  })) %>%
  unnest(cols = sub_ids)



sutta_data <- sutta_data %>%
  bind_rows(kn_sutta_data) %>%
  left_join(sutta_html, join_by(segment_id)) %>%
  left_join(
    sutta_hierarchy %>%
      select(id, node_type),
    join_by(sutta == id)
  ) %>%
  left_join(sub_id_list, join_by(sutta == sub_id)) %>%
  # filter(str_detect(segment_id, "sn12.93")) %>% 
  mutate(hierarchy_id = case_when(str_detect(segment_id, "sn12") ~ "sn12.93-213",
                                  str_detect(segment_id, "an1.102-109") ~ "an1.98-139",
                                  str_detect(segment_id, "an1.118-128") ~ "an1.98-139",
                                  str_detect(segment_id, "an1.132-139") ~ "an1.98-139",
                                  str_detect(segment_id, "an1.142-149") ~ "an1.140-149",
                                  str_detect(segment_id, "an1.152-159") ~ "an1.150-169",
                                  str_detect(segment_id, "an1.162-169") ~ "an1.150-169",
                                  str_detect(segment_id, "an1.175-186") ~ "an1.170-187",
                                  str_detect(segment_id, "an1.281-283") ~ "an1.278-286",
                                  str_detect(segment_id, "an1.285-286") ~ "an1.278-286",
                                  str_detect(segment_id, "an1.288-289") ~ "an1.287-295",
                                  str_detect(segment_id, "an1.291-292") ~ "an1.287-295",
                                  str_detect(segment_id, "an1.294-295") ~ "an1.287-295",
                                  str_detect(segment_id, "an1.297-305") ~ "an1.296-305",
                                  str_detect(segment_id, "an1.348-350") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.351-353") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.354-356") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.357-359") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.360-362") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.363-365") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.366-368") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.369-371") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.372-374") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.375-377") ~ "an1.333-377",
                                  str_detect(segment_id, "an1.505-514") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.515-524") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.525-534") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.535-544") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.545-554") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.555-564") ~ "an1.394-574",
                                  str_detect(segment_id, "an1.576-582") ~ "an1.575-615",
                                  str_detect(segment_id, "an1.586-590") ~ "an1.575-615",
                                  str_detect(segment_id, "an1.591-592") ~ "an1.575-615",
                                  str_detect(segment_id, "an1.593-595") ~ "an1.575-615",
                                  str_detect(segment_id, "an1.596-599") ~ "an1.575-615",
                                  str_detect(segment_id, "an1.600-615") ~ "an1.575-615",
                                  str_detect(segment_id, "an2.180-184") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.185-189") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.190-194") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.195-199") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.200-204") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.205-209") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.210-214") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.215-219") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.220-224") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.225-229") ~ "an2.180-229",
                                  str_detect(segment_id, "an2.281-309") ~ "an2.280-309",
                                  str_detect(segment_id, "an2.310-319") ~ "an2.310-479",
                                  str_detect(segment_id, "an2.320-479") ~ "an2.310-479",
                                  is.na(node_type) ~ id,
                                  .default = sutta
  )) %>% 
  select(-id, -node_type) %>%
  filter(!is.na(segment_text)) %>%
  rename(
    scripture = sutta,
    scripture_num = sutta_num
  )



# Save to disk.
save(sutta_data, file = "./data/sutta-translations/sutta_data.Rda")
