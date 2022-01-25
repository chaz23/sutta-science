# Script to read in sutta html from bilara i/o. ---------------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py dn dn-html.tsv --include reference
# python sheet_export.py mn mn-html.tsv --include reference
# python sheet_export.py sn sn-html.tsv --include reference
# python sheet_export.py an an-html.tsv --include reference
# python sheet_export.py kn kn-html.tsv --include reference

# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

dn_html <- read_tsv("./../bilara-data/.scripts/bilara-io/dn-html.tsv")
mn_html <- read_tsv("./../bilara-data/.scripts/bilara-io/mn-html.tsv")
sn_html <- read_tsv("./../bilara-data/.scripts/bilara-io/sn-html.tsv")
an_html <- read_tsv("./../bilara-data/.scripts/bilara-io/an-html.tsv")
kn_html <- read_tsv("./../bilara-data/.scripts/bilara-io/kn-html.tsv")

sutta_html <- dn_html %>%
  bind_rows(mn_html, sn_html, an_html, kn_html)

# Save to disk.
save(sutta_html, file = "./data/html/dataset_1/sutta_html.Rda")

write_tsv(sutta_html, file = "./data/html/dataset_1/sutta_html.tsv")