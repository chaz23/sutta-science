# Script to read in pali texts from bilara i/o. ---------------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py pli-tv-bu-vb pli-tv-bu-vb-pali.tsv --include reference
# python sheet_export.py pli-tv-bi-vb pli-tv-bi-vb-pali.tsv --include reference
# python sheet_export.py pli-tv-kd pli-tv-kd-pali.tsv --include reference
# python sheet_export.py pli-tv-pvr pli-tv-pvr-pali.tsv --include reference
# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

bu_vb_pali_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bu-vb-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
bi_vb_pali_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bi-vb-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
kd_pali_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-kd-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
pvr_pali_vinaya_data <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-pvr-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))

pali_vinaya_data <- bu_vb_pali_vinaya_data %>%
  bind_rows(bi_vb_pali_vinaya_data, kd_pali_vinaya_data, pvr_pali_vinaya_data)

# Save to disk.
save(pali_vinaya_data, file = "./data/pali-texts/dataset_2/pli_vinaya_data.Rda")

write_tsv(bu_vb_pali_vinaya_data, file = "./data/pali-texts/dataset_2/pli_bu_vb_vinaya.tsv")
write_tsv(bi_vb_pali_vinaya_data, file = "./data/pali-texts/dataset_2/pli_bi_vb_vinaya.tsv")
write_tsv(kd_pali_vinaya_data, file = "./data/pali-texts/dataset_2/pli_kd_vinaya.tsv")
write_tsv(pvr_pali_vinaya_data, file = "./data/pali-texts/dataset_2/pli_pvr_vinaya.tsv")