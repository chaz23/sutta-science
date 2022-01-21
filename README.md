# sutta-science

[SuttaCentral](https://github.com/suttacentral) is doing amazing work making Buddhist source texts and translations open-source and freely available to all. :tada: 

However, for a developer it can be intimidating at first to navigate the [bilara-data repository](https://github.com/suttacentral/bilara-data) with its nested hierarchies and abundance of information. Recursing through these nested directories to put together a useful dataset can also be a prohibitively time-consuming task. Additionally, some data exists in a form that is not so amenable to analysis.

This project aims to solve some of these problems - i.e collating, cleaning, feature-engineering - by preparing datasets that are fit for immediate exploration with a tool of your choice.

## Contents

* [Datasets](#datasets)
    * Sutta translations.
        - [Raw download of Bhante Sujato's translations of the Sutta Pitaka](#dataset-1) 
        - [Raw download of Ajahn Brahmali's translations of the Vinaya Pitaka](#dataset-2)
        - [Tidied representation of Bhante Sujato's translation of the 4 nikayas](#dataset-3)
        - [Tidied representation of Bhante Sujato's translation of the Khuddaka nikaya](#dataset-4)
        - [Tidied representation of Ajahn Brahmali's translation of the Vinaya Pitaka](#dataset-5)
* [Tools and references](#tools-and-references)

## Datasets

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory.

### Sutta translations. 
**Raw download of Bhante Sujato's translations of the Sutta Pitaka.**

This includes translations of the 4 main nikayas (`dn`, `mn`, `sn`, `an`) in full, as well as select texts of the Khuddaka Nikaya (`kn`). Available texts of the `kn` include the Dhammapada (`dhp`), Itivuttaka (`iti`), Khuddakapatha (`kp`), Sutta Nipata (`snp`), Theragatha (`thag`), Therigatha (`thig`) and Udana (`ud`). Aside from the Jatakas, these are all considered to be early texts of the KN. The Khuddakapatha is considered a later text.

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.  

#### Dataset 2 
**Raw download of Ajahn Brahmali's translations of the Vinaya Pitaka.**

This includes translations of select texts from the Theravada Vinaya Pitaka (`pli-tv-vi`). Texts include the Bhikkhu Vibhanga (`pli-tv-bu-vb`), Bhikkhuni Vibhanga (`pli-tv-bi-vb`), Khandhaka (`pli-tv-kd`) and Parivara (`pli-tv-pvr`).

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.

#### Dataset 3 
**Tidied representation of Bhante Sujato's translation of the 4 nikayas** (`dn`, `mn`, `sn`, `an`).  

This is an augmented version of the raw version. Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.  

#### Dataset 4 
**Tidied representation of Bhante Sujato's translation of the Khuddaka nikaya** (`kn`).  

This is an augmented version of the raw version. Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.

#### Dataset 5 
**Tidied representation of Ajahn Brahmali's translation of the Vinaya Pitaka** (`pli-tv-vi`).  

This is an augmented version of the raw version (dataset_2). Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.

## Tools and References

* For info on the SuttaCentral segment numbering system:
    * See discussion on [Discourse](https://discourse.suttacentral.net/t/making-sense-of-the-segment-numbering-system/23121).
    * See bilara-data [wiki](https://github.com/suttacentral/bilara-data/wiki/Bilara-segment-number-spec).