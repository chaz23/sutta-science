# Script to read in vinaya html from bilara i/o. --------------------------

# Make sure you have python 3.6 or higher.
# Clone the bilara-data repo.
# Navigate to "bilara-data/.scripts/bilara-io".
# Execute the following commands at the terminal.
# Note I am using Windows CMD.

# python sheet_export.py pli-tv-bu-vb pli-tv-bu-vb-html.tsv --include reference
# python sheet_export.py pli-tv-bi-vb pli-tv-bi-vb-html.tsv --include reference
# python sheet_export.py pli-tv-kd pli-tv-kd-html.tsv --include reference
# python sheet_export.py pli-tv-pvr pli-tv-pvr-html.tsv --include reference

# Now run the following script.

library(dplyr)
library(readr)

# NOTE: You will have to change the following paths.

bu_vb_html <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bu-vb-html.tsv")
bi_vb_html <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-bi-vb-html.tsv")
kd_html <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-kd-html.tsv")
pvr_html <- read_tsv("./../bilara-data/.scripts/bilara-io/pli-tv-pvr-html.tsv")

vinaya_html <- bu_vb_html %>%
  bind_rows(bi_vb_html, kd_html, pvr_html)

# Save to disk.
save(vinaya_html, file = "./data/html/vinaya_html.Rda")

write_tsv(vinaya_html, file = "./data/html/vinaya_html.tsv")