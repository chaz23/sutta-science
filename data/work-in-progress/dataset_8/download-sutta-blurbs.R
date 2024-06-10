# A script to download the blurbs for all suttas, vaggas, etc. ------------

library(dplyr)
library(tidyr)
library(stringr)
library(httr)
library(readr)

nikayas <- c("dn", "mn", "sn", "an")

blurbs_path_prefix <- "https://raw.githubusercontent.com/suttacentral/sc-data/master/sc_bilara_data/root/en/blurb/"
blurbs_path_suffix <- "-blurbs_root-en.json"

blurbs_path <- paste0(blurbs_path_prefix, 
                      nikayas, 
                      blurbs_path_suffix)

blurbs_metadata <- lapply(lapply(blurbs_path, function (x) x), 
                          function (x) GET(x))

blurbs_metadata_content <- lapply(blurbs_metadata, function (x) {
  content(x, as = "parsed", type = "application/json")
})

sutta_blurbs <- lapply(blurbs_metadata_content, function (x) {
  x %>% 
    as_tibble() %>% 
    pivot_longer(cols = everything(), values_to = "blurb")
}) %>% 
  do.call("bind_rows", .) %>% 
  transmute(title = str_remove_all(name, "^.*:"),
            blurb)

dn_sutta_blurbs <- sutta_blurbs %>%
  filter(str_extract(title, "..") == "dn")

mn_sutta_blurbs <- sutta_blurbs %>%
  filter(str_extract(title, "..") == "mn")

sn_sutta_blurbs <- sutta_blurbs %>%
  filter(str_extract(title, "..") == "sn")

an_sutta_blurbs <- sutta_blurbs %>%
  filter(str_extract(title, "..") == "an")

# Save data.
save(sutta_blurbs, file = "./data/dataset_3/sutta_blurbs.Rda")

write_tsv(dn_sutta_blurbs, "./data/dataset_3/dn_sutta_blurbs.tsv")
write_tsv(mn_sutta_blurbs, "./data/dataset_3/mn_sutta_blurbs.tsv")
write_tsv(sn_sutta_blurbs, "./data/dataset_3/sn_sutta_blurbs.tsv")
write_tsv(an_sutta_blurbs, "./data/dataset_3/an_sutta_blurbs.tsv")
