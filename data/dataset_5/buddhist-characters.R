library(dplyr)
library(tidyr)
library(httr)
library(purrr)
library(stringi)
library(readr)


data_path <- "https://raw.githubusercontent.com/suttacentral/sc-data/master/dictionaries/complex/en/pli2en_dppn.json"


sutta_proper_names <- GET(data_path) %>% 
  content(as = "parsed", type = "application/json") %>% 
  lapply(function (x) as_tibble(x)) %>% 
  do.call("bind_rows", .) 


regex <- list(starts_with_person = "(?=<dt class='place').*?(?=<dt class='person'|</dl>)",
              starts_with_place = "<dl class='place'.*(?=<dt class='person')")


parse_text <- function (word, text) {
  regexs <- list(id = "(?<=<dfn)(?:.*?)(?=</dfn>)",
                 desc = "(?:<dd>.*?</dd>)")
  
  ids <- text %>%
    regmatches(., gregexec(regexs$id, ., perl = TRUE)) %>%
    unlist() %>% 
    (function (x) {
      case_when(grepl("id='", x) ~ sub("'>.*$", "", sub("^.*id='", "", x)),
                TRUE ~ sub(">", "", x))
    })
  
  names <- text %>%
    regmatches(., gregexec(regexs$id, ., perl = TRUE)) %>%
    unlist() %>% 
    (function (x) {
      case_when(grepl("id='", x) ~ sub("^.*>", "", x),
                TRUE ~ sub(">", "", x))
    })
  
  descs <- text %>%
    regmatches(., gregexec(regexs$desc, ., perl = TRUE)) %>%
    unlist()
  
  tibble(id = ids, name = names, desc = descs)
}


sutta_characters <- sutta_proper_names %>% 
  # Keep items that include people.
  filter(grepl("class='person'", text)) %>%
  
  # Remove entries of places.
  mutate(text = case_when(grepl("<dl class='person'", text) ~ 
                            sub(regex$starts_with_person, "", text, perl = TRUE),
                          grepl("<dl class='place'", text) ~ 
                            sub(regex$starts_with_place, "<dl class='person'>", text, perl = TRUE),
                          TRUE ~ text)) %>% 
  
  # Parse text field.
  mutate(text = map2(word, text, parse_text)) %>% 
  unnest(cols = text) %>% 
  
  # Transliterate character name.
  mutate(word_trans = stri_trans_general(word, "latin-ascii"))


write_tsv(sutta_characters, "./data/dataset_4/sutta_characters.tsv")
  

# GET("https://api.pts.dhamma-dana.de/v1/lookup/sn/0/123.json") %>% 
#   content(as = "parsed", type = "application/json")
# 
# 
# "<dd><p>One of the ten ancient seers who conducted great sacrifices and were versed in Vedic lore. The others being Aṭṭhaka, Vāmaka, Vāmadeva, Vessāmitta, Yamataggi, Bhāradvāja, Vāseṭṭha, Kassapa and Bhagu. The list occurs in several places. <span class='ref'>Vin.i.245</span> <span class='ref'>AN.iii.224</span> <span class='ref'>MN.ii.169</span> <span class='ref'>MN.ii.200</span></p><p>The same ten are also mentioned as being composers and reciters of the Vedas. <span class='ref'>DN.i.238</span></p></dd>" %>% regmatches(., gregexec("(?<=class='ref'>)(?:.*?)(?=</span>)", ., perl = TRUE)) %>% unlist() %>% as_tibble()

# translate_pts_refs <- function (pts_ref) {
#   refs <- pts_ref %>% 
#     regmatches(., gregexec("(?<=class='ref'>)(?:.*?)(?=</span>)", ., perl = TRUE)) %>% 
#     unlist() %>% 
#     as_tibble()
#   
#   refs %>% 
#     rename(pts_ref = value) %>% 
#     mutate(seg_id = map_chr(pts_ref, ~ sub("(?=(<em|f|;|-|\U{2013})).*$", "", ., perl = TRUE)))
# }
# 
# test <- sutta_characters %>% 
#   mutate(refs = map(desc, translate_pts_refs)) %>% 
#   unnest(cols = refs)
#   # filter(!grepl("^(MN|SN|DN|AN|Vin|Thag|Thig|Snp|Ud|It|Dhp|Aii|A.i)", value))
# 
# test %>% 
#   mutate(test = stringr::str_split(seg_id, "\\."),
#          test = map_dbl(test, length)) %>% 
#   filter(grepl("^(SN|DN|MN|AN)", seg_id)) %>% View()
#   filter(test != 3)

# sutta_proper_names %>% 
#   mutate(row_num = row_number()) %>% 
#   filter(grepl("class='person'", text)) %>%
#   mutate(dd_count = map_dbl(text, ~ length(pluck(gregexpr("<dd ?", .), 1))),
#          dt_count = map_dbl(text, ~ length(pluck(gregexpr("<dt ?", .), 1))),
#          dl_count = map_dbl(text, ~ length(pluck(gregexpr("<dl ?", .), 1))),
#          dfn_count = map_dbl(text, ~ length(pluck(gregexpr("<dfn ?", .), 1))),
#          p_count = map_dbl(text, ~ length(pluck(gregexpr("<p ?", .), 1)))) %>%
#   filter(dd_count != dfn_count) %>% 
#   filter(grepl("class='place'", text)) %>% 
  # filter(grepl("<dl class='person'", text)) %>% 
  # mutate(text = sub("(?=<dt class='place').*?(?=<dt class='person'|</dl>)", "", text, perl = TRUE))


# readr::write_tsv(sutta_characters, "./sutta-characters.tsv")

# "DN.i.85–86" %>% sub("(?=(<em|f|;|-|\U{2013})).*$", "", ., perl = TRUE)


# MN: MN86
# SN: SN.348-352, SN.163
# Thag: Everything except "Thag.776."