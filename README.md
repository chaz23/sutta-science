# sutta-science

[SuttaCentral](https://github.com/suttacentral) is doing amazing work making Buddhist source texts and translations open-source and freely available to all. :tada: 

However, for a developer it can be a pain to navigate the 

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory. The subdirectories will each have the naming convention `dataset_[n]`.

**References:**
* See discussion about SuttaCentral segment numbering system [here](https://discourse.suttacentral.net/t/making-sense-of-the-segment-numbering-system/23121).

----

**dataset_1**: Raw download of Bhante Sujato's translations of the Sutta Pitaka. 

This includes translations of the 4 main nikayas (`dn`, `mn`, `sn`, `an`) in full, as well as select texts of the Khuddaka Nikaya (`kn`). Available texts of the `kn` include the Dhammapada (`dhp`), Itivuttaka (`iti`), Khuddakapatha (`kp`), Sutta Nipata (`snp`), Theragatha (`thag`), Therigatha (`thig`) and Udana (`ud`). Aside from the Jatakas, these are all considered to be early texts of the KN. The Khuddakapatha is considered a later text.

Table of data with columns `segment_id` and `segment_text`.
Available formats: `.Rda`, `.tsv`.  

**dataset_2**: Raw download of Ajahn Brahmali's translations of the Vinaya Pitaka.

This includes translations of select texts from the Theravada Vinaya Pitaka (`pli-tv-vi`). Texts include the Bhikkhu Vibhanga (`pli-tv-bu-vb`), Bhikkhuni Vibhanga (`pli-tv-bi-vb`), Khandhaka (`pli-tv-kd`) and Parivara (`pli-tv-pvr`).

Table of data with columns `segment_id` and `segment_text`.
Available formats: `.Rda`, `.tsv`.

**dataset_3**: Tidied representation of Bhante Sujato's translation of the 4 nikayas (`dn`, `mn`, `sn`, `an`).  

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `nikaya`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.  

**dataset_4**: Blurbs for each sutta and associated vagga/samyutta in the DN, MN, SN and AN.  
Available formats: `.Rda`, `.tsv`.  
Columns: `title`, `blurb`. 
