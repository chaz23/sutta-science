# Script to download the sutta pitaka. ------------------------------------

library(purrr)
library(gh)
library(jsonlite)
library(dplyr)
library(readr)

# Check Github API calls remaining.
rate <- gh("GET /rate_limit")
calls_remaining <- rate$rate$limit - rate$rate$used
if (calls_remaining < 72) stop("API calls insufficient.")

sutta_list_root <- "/repos/suttacentral/bilara-data/contents/translation/en/sujato/sutta/"

nikayas <- c("dn", "mn", "sn", "an", "kn")

sutta_list <- unlist(map(sutta_list_root, paste0, nikayas))

resp <- map(paste0("GET ", sutta_list), gh)
names(resp) <- nikayas

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
raw_sutta_data <- download_urls %>%
  as_tibble() %>%
  mutate(github_data = map(value, fromJSON),
         github_data = map(github_data, tibble::enframe)) %>%
  select(github_data) %>%
  tidyr::unnest(cols = github_data) %>%
  tidyr::unnest(cols = value) %>%
  rename(segment_id = name,
         segment_text = value)

# Save sutta data.
save(raw_sutta_data, file = "./data/dataset_1/raw_sutta_data.Rda")
write_tsv(raw_sutta_data, file = "./data/dataset_1/raw_sutta_data.tsv")
