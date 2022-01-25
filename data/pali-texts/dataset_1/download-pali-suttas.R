# Script to read in pali texts from bilara i/o. ---------------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py dn dn-pali.tsv --include reference
# python sheet_export.py mn mn-pali.tsv --include reference
# python sheet_export.py sn sn-pali.tsv --include reference
# python sheet_export.py an an-pali.tsv --include reference
# python sheet_export.py kn kn-pali.tsv --include reference
# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

dn_pali_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/dn-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
mn_pali_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/mn-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
sn_pali_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/sn-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
an_pali_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/an-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))
kn_pali_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/kn-pali.tsv") %>% 
  rename(segment_text = `root-pli-ms`) %>% 
  filter(!is.na(segment_text))

pali_sutta_data <- dn_pali_sutta_data %>%
  bind_rows(mn_pali_sutta_data, sn_pali_sutta_data, an_pali_sutta_data, kn_pali_sutta_data)

# Save to disk.
save(pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_sutta_data.Rda")

write_tsv(dn_pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_dn_sutta_data.tsv")
write_tsv(mn_pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_mn_sutta_data.tsv")
write_tsv(sn_pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_sn_sutta_data.tsv")
write_tsv(an_pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_an_sutta_data.tsv")
write_tsv(kn_pali_sutta_data, file = "./data/pali-texts/dataset_1/pli_kn_sutta_data.tsv")