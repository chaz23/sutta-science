# Script to read in sutta translations from bilara i/o. -------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py dn dn-trans-en.tsv --include translation+en
# python sheet_export.py mn mn-trans-en.tsv --include translation+en
# python sheet_export.py sn sn-trans-en.tsv --include translation+en
# python sheet_export.py an an-trans-en.tsv --include translation+en
# python sheet_export.py kn kn-trans-en.tsv --include translation+en

# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

dn_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/dn-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-sujato`) %>% 
  select(segment_id, segment_text)
mn_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/mn-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-sujato`) %>% 
  select(segment_id, segment_text)
sn_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/sn-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-sujato`) %>% 
  select(segment_id, segment_text)
an_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/an-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-sujato`) %>% 
  select(segment_id, segment_text)
kn_sutta_data <- read_tsv("./../bilara-data/.scripts/bilara-io/kn-trans-en.tsv") %>% 
  rename(segment_text = `translation-en-sujato`) %>% 
  select(segment_id, segment_text)

raw_sutta_data <- dn_sutta_data %>%
  bind_rows(mn_sutta_data, sn_sutta_data, an_sutta_data, kn_sutta_data)


# Save sutta data.
save(raw_sutta_data, file = "./data/sutta-translations/dataset_1/raw_sutta_data.Rda")

write_tsv(dn_sutta_data, file = "./data/sutta-translations/dataset_1/raw_dn_sutta_data.tsv")
write_tsv(mn_sutta_data, file = "./data/sutta-translations/dataset_1/raw_mn_sutta_data.tsv")
write_tsv(sn_sutta_data, file = "./data/sutta-translations/dataset_1/raw_sn_sutta_data.tsv")
write_tsv(an_sutta_data, file = "./data/sutta-translations/dataset_1/raw_an_sutta_data.tsv")
write_tsv(kn_sutta_data, file = "./data/sutta-translations/dataset_1/raw_kn_sutta_data.tsv")
