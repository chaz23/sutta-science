# Script to read in vinaya references from bilara i/o. --------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py pli-tv-bu-vb pli-tv-bu-vb-refs.tsv --include reference
# python sheet_export.py pli-tv-bi-vb pli-tv-bi-vb-refs.tsv --include reference
# python sheet_export.py pli-tv-kd pli-tv-kd-refs.tsv --include reference
# python sheet_export.py pli-tv-pvr pli-tv-pvr-refs.tsv --include reference

# Now run the following script.

library(dplyr)
library(readr)
library(tidytext)
library(stringr)

# NOTE: You will have to change the following paths.

bu_vb_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bu-vb-refs.tsv")
bi_vb_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bi-vb-refs.tsv")
kd_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-kd-refs.tsv")
pvr_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-pvr-refs.tsv")

vinaya_refs <- bu_vb_refs %>%
  bind_rows(bi_vb_refs, kd_refs, pvr_refs) %>% 
  unnest_tokens(reference, reference, to_lower = FALSE, token = "regex", pattern = ",") %>%
  mutate(reference = str_trim(reference)) %>% 
  mutate(text = str_extract(reference, "^.*[a-z]"))

# Save to disk.
save(vinaya_refs, file = "./data/references/dataset_2/vinaya_refs.Rda")

write_tsv(vinaya_refs, file = "./data/references/dataset_2/vinaya_refs.tsv")