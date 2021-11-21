# sutta-science

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory. The subdirectories will each have the naming convention `dataset_[n]`.

**dataset_1**: Unaltered download of Bhante Sujato's translations of the 4 main nikayas (DN, MN, SN, AN).  
Available formats: `.Rda`, `.tsv`.  
Columns: `segment_id`, `segment_text`.

**dataset_2**: Tidied version of dataset_1.  
Available formats: `.Rda`, `.tsv`.  
Columns: `segment_id`, `segment_text`, `discourse`, `paragraph_id`, `sentence_id`, `nikaya`, `discourse_num`, `title`.  

**dataset_3**: Blurbs for each sutta and associated vagga/samyutta in the DN, MN, SN and AN.  
Available formats: `.Rda`, `.tsv`.  
Columns: `title`, `blurb`. 