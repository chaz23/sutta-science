# A script to download the suttas. ----------------------------------------

library(purrr)
library(gh)
library(jsonlite)
library(dplyr)

# Check Github API calls remaining.
rate <- gh("GET /rate_limit")
calls_remaining <- rate$rate$limit - rate$rate$used
if (calls_remaining < 72) stop("API calls insufficient.")

sutta_list_root <- "/repos/suttacentral/bilara-data/contents/translation/en/sujato/sutta/"

nikayas <- c("dn", "mn", "sn", "an")

sutta_list <- unlist(map(sutta_list_root, paste0, nikayas))

resp <- map(paste0("GET ", sutta_list), gh)
names(resp) <- nikayas

raw_content_url <- function (x) {
  lapply(x, function (x) {
    if (!is.null(x$download_url)) {
      x$download_url
    } else {
      lapply(gh(x$url), function (x) x$download_url)
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

# Save sutta data in .Rda format.
save(raw_sutta_data, file = "./R/data/raw_sutta_data.Rda")