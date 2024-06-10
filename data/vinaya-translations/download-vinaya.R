# Script to read in vinaya translations from bilara i/o. ------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py pli-tv-bu-vb bu-vb-trans-en.tsv --include translation+en
# python sheet_export.py pli-tv-bi-vb bi-vb-trans-en.tsv --include translation+en
# python sheet_export.py pli-tv-kd kd-trans-en.tsv --include translation+en
# python sheet_export.py pli-tv-pvr pvr-trans-en.tsv --include translation+en

# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

bu_vb_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/bu-vb-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-brahmali`) %>% 
  select(segment_id, segment_text)
bi_vb_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/bi-vb-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-brahmali`) %>% 
  select(segment_id, segment_text)
kd_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/kd-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-brahmali`) %>% 
  select(segment_id, segment_text)
pvr_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/pvr-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-brahmali`) %>% 
  select(segment_id, segment_text)

raw_vinaya_data <- bu_vb_vinaya_data %>%
  bind_rows(bi_vb_vinaya_data, kd_vinaya_data, pvr_vinaya_data)


# Save vinaya data.
save(raw_vinaya_data, file = "./data/vinaya-translations/raw_vinaya_data.Rda")

write_tsv(bi_vb_vinaya_data, file = "./data/vinaya-translations/raw_bi_vb_vinaya_data.tsv")
write_tsv(bu_vb_vinaya_data, file = "./data/vinaya-translations/raw_bu_vb_vinaya_data.tsv")
write_tsv(kd_vinaya_data, file = "./data/vinaya-translations/raw_kd_vinaya_data.tsv")
write_tsv(pvr_vinaya_data, file = "./data/vinaya-translations/raw_pvr_vinaya_data.tsv")
