# Script to download the vinaya pitaka. -----------------------------------

library(purrr)
library(gh)
library(jsonlite)
library(dplyr)
library(readr)

# Check Github API calls remaining.
rate <- gh("GET /rate_limit")
calls_remaining <- rate$rate$limit - rate$rate$used
if (calls_remaining < 72) stop("API calls insufficient.")

vinaya_list_root <- "/repos/suttacentral/bilara-data/contents/translation/en/brahmali/vinaya/"

sections <- c("pli-tv-bi-vb", "pli-tv-bu-vb", "pli-tv-kd", "pli-tv-pvr")

vinaya_list <- unlist(map(vinaya_list_root, paste0, sections))

resp <- map(paste0("GET ", vinaya_list), gh)
names(resp) <- sections

raw_content_url <- function (resp) {
  lapply(resp, function (x) {
    if (is.null(x$download_url)) {
      raw_content_url(gh(x$url)) 
    } else {
      x$download_url
    }
  })
}

download_urls <- unlist(lapply(resp, raw_content_url))

# Download JSON data and convert to tibble.
raw_vinaya_data <- download_urls %>%
  as_tibble() %>%
  mutate(github_data = map(value, fromJSON),
         github_data = map(github_data, tibble::enframe)) %>%
  select(github_data) %>%
  tidyr::unnest(cols = github_data) %>%
  tidyr::unnest(cols = value) %>%
  rename(segment_id = name,
         segment_text = value)

# Save vinaya data.
save(raw_vinaya_data, file = "./data/dataset_2/raw_vinaya_data.Rda")
write_tsv(raw_vinaya_data, file = "./data/dataset_2/raw_vinaya_data.tsv")