# Script to read in sutta references from bilara i/o. ---------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py dn dn-refs.tsv --include reference
# python sheet_export.py mn mn-refs.tsv --include reference
# python sheet_export.py sn sn-refs.tsv --include reference
# python sheet_export.py an an-refs.tsv --include reference
# python sheet_export.py kn kn-refs.tsv --include reference

# Now run the following script.

library(dplyr)
library(readr)
library(tidytext)
library(stringr)

# NOTE: You will have to change the following paths.

dn_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/dn-refs.tsv")
mn_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/mn-refs.tsv")
sn_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/sn-refs.tsv")
an_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/an-refs.tsv")
kn_refs <- read_tsv("./../bilara-data/.scripts/bilara-io/kn-refs.tsv")

sutta_refs <- dn_refs %>%
  bind_rows(mn_refs, sn_refs, an_refs, kn_refs) %>% 
  unnest_tokens(reference, reference, to_lower = FALSE, token = "regex", pattern = ",") %>%
  mutate(reference = str_trim(reference)) %>% 
  mutate(edition = str_extract(reference, "^.*[a-z]"))

# Save to disk.
save(sutta_refs, file = "./data/references/sutta_refs.Rda")

write_tsv(sutta_refs, file = "./data/references/sutta_refs.tsv")
