# sutta-science

[SuttaCentral](https://github.com/suttacentral) is doing amazing work making Buddhist source texts and translations open-source and freely available to all. :tada: 

However, for a developer it can be intimidating at first to navigate the [bilara-data repository](https://github.com/suttacentral/bilara-data) with its nested hierarchies and abundance of information. Recursing through these nested directories to put together a useful dataset can also be a prohibitively time-consuming task. Additionally, some data exists in a form that is not so amenable to analysis.

This project aims to solve some of these problems - i.e collating, cleaning, feature-engineering - by preparing datasets that are fit for immediate exploration with a tool of your choice.

## Contents

[Datasets](#datasets)
[References](#references)

## Datasets

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory. The subdirectories will each have the naming convention `dataset_[n]`.




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

## References

* SuttaCentral segment numbering system.
** See discussion on [Discourse](https://discourse.suttacentral.net/t/making-sense-of-the-segment-numbering-system/23121).
** See bilara-data [wiki](https://github.com/suttacentral/bilara-data/wiki/Bilara-segment-number-spec)