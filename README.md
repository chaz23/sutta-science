# sutta-science

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory. The subdirectories will each have the naming convention `dataset_[n]`.

**dataset_1**: Raw download of Bhante Sujato's translations of the Sutta Pitaka. 

This includes translations of the 4 main nikayas (`DN`, `MN`, `SN`, `AN`) in full, as well as select texts of the KN. Available texts of the KN include the Dhammapada (dhp), Itivuttaka (iti), Khuddakapatha (kp), Sutta Nipata (snp), Theragatha (thag), Therigatha (thig) and Udana (ud). Aside from the Jatakas, these include all the early texts of the KN. The Khuddakapatha is considered a later text.

Available formats: `.Rda`, `.tsv`.  
Columns: `segment_id`, `segment_text`.

**dataset_2**: Raw download of Ajahn Brahmali's translations of the Theravada Vinaya Pitaka.

This includes translations of the 

Available formats: `.Rda`, `.tsv`.  
Columns: `segment_id`, `segment_text`.

**dataset_2**: Tidied version of dataset_1.  
Available formats: `.Rda`, `.tsv`.  
Columns: `segment_id`, `segment_text`, `discourse`, `paragraph_id`, `sentence_id`, `nikaya`, `discourse_num`, `title`.  

**dataset_3**: Blurbs for each sutta and associated vagga/samyutta in the DN, MN, SN and AN.  
Available formats: `.Rda`, `.tsv`.  
Columns: `title`, `blurb`. 