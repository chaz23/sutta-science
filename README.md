# sutta-science

[SuttaCentral](https://github.com/suttacentral) is doing amazing work making Buddhist source texts and translations open-source and freely available to all. :tada: 

Developers may wish to explore [bilara i/o](https://github.com/suttacentral/bilara-data/wiki/Bilara-io) which is a superb tool developed by SuttaCentral that allows you to download JSON data from the [bilara-data repo](https://github.com/suttacentral/bilara-data) into a format of your choice. 

This project aims to build on that work. First, by collating, cleaning and feature-engineering, it prepares datasets that are fit for immediate exploration with a tool of your choice. Second, it builds bespoke datasets that may not be readily available.

## Contents

* [Datasets](#datasets)
    * [Pali texts](#pali-texts)
        - [Raw download of the Sutta Pitaka in Pali](#pali-texts-dataset-1)
        - [Raw download of the Vinaya Pitaka in Pali](#pali-texts-dataset-2)
    * [HTML Markup](#html-markup)
        - [HTML markup for the Sutta Pitaka](#html-markup-dataset-1)
        - [HTML markup for the Vinaya Pitaka](#html-markup-dataset-2)
    * [Sutta translations](#sutta-translations)
        - [Raw download of Bhante Sujato's translations of the Sutta Pitaka](#sutta-translations-dataset-1) 
        - [Tidied representation of Bhante Sujato's translation of the 4 nikayas](#sutta-translations-dataset-2)
        - [Tidied representation of Bhante Sujato's translation of the Khuddaka nikaya](#sutta-translations-dataset-3)
    * [Vinaya translations](#vinaya-translations)
        - [Raw download of Ajahn Brahmali's translations of the Vinaya Pitaka](#vinaya-translations-dataset-1)
        - [Tidied representation of Ajahn Brahmali's translation of the Vinaya Pitaka](#vinaya-translations-dataset-2)
    * [Text references](#text-references)
        - [References for the Sutta Pitaka](#text-references-dataset-1)
        - [References for the Vinaya Pitaka](#text-references-dataset-2)
* [Tools and references](#tools-and-references)

## Datasets

Datasets and their associated script/s (if any) are accessible via subdirectories of the `data` directory. For quick access to these subdirectories, click on the hashtags in front of each dataset title. 

### :sparkles: Pali texts

#### [#dataset_1](https://github.com/chaz23/sutta-science/tree/main/data/pali-texts/dataset_1) <a name="pali-texts-dataset-1"></a>· Raw download of the Sutta Pitaka in Pali

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.

#### [#dataset_2](https://github.com/chaz23/sutta-science/tree/main/data/pali-texts/dataset_2) <a name="pali-texts-dataset-2"></a>· Raw download of the Vinaya Pitaka in Pali

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.

### :sparkles: HTML markup

#### [#dataset_1](https://github.com/chaz23/sutta-science/tree/main/data/html/dataset_1) <a name="html-markup-dataset-1"></a>· Segment-level HTML markup for the Sutta Pitaka

Table of data with columns `segment_id` and `html`.  
Available formats: `.Rda`, `.tsv`.

#### [#dataset_2](https://github.com/chaz23/sutta-science/tree/main/data/html/dataset_2) <a name="html-markup-dataset-2"></a>· Segment-level HTML markup for the Vinaya Pitaka

Table of data with columns `segment_id` and `html`.  
Available formats: `.Rda`, `.tsv`.

### :sparkles: Sutta translations 

#### [#dataset_1](https://github.com/chaz23/sutta-science/tree/main/data/sutta-translations/dataset_1) <a name="sutta-translations-dataset-1"></a>· Raw download of Bhante Sujato's translations of the Sutta Pitaka  

This includes translations of the 4 main nikayas (`dn`, `mn`, `sn`, `an`) in full, as well as select texts of the Khuddaka Nikaya (`kn`). Available texts of the `kn` include the Dhammapada (`dhp`), Itivuttaka (`iti`), Khuddakapatha (`kp`), Sutta Nipata (`snp`), Theragatha (`thag`), Therigatha (`thig`) and Udana (`ud`). Aside from the Jatakas, these are all considered to be early texts of the KN. The Khuddakapatha is considered a later text.

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.  

#### [#dataset_2](https://github.com/chaz23/sutta-science/tree/main/data/sutta-translations/dataset_2) <a name="sutta-translations-dataset-2"></a>· Tidied representation of Bhante Sujato's translation of the 4 nikayas (`dn`, `mn`, `sn`, `an`) 

This is an augmented version of the [raw download](#sutta-translations-dataset-1). Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.  

#### [#dataset_3](https://github.com/chaz23/sutta-science/tree/main/data/sutta-translations/dataset_3) <a name="sutta-translations-dataset-3"></a>· Tidied representation of Bhante Sujato's translation of the Khuddaka nikaya (`kn`)

This is an augmented version of the [raw download](#sutta-translations-dataset-1). Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.


### :sparkles: Vinaya translations

#### [#dataset_1](https://github.com/chaz23/sutta-science/tree/main/data/vinaya-translations/dataset_1) <a name="vinaya-translations-dataset-1"></a>· Raw download of Ajahn Brahmali's translations of the Vinaya Pitaka 

This includes translations of select texts from the Theravada Vinaya Pitaka (`pli-tv-vi`). Texts include the Bhikkhu Vibhanga (`pli-tv-bu-vb`), Bhikkhuni Vibhanga (`pli-tv-bi-vb`), Khandhaka (`pli-tv-kd`) and Parivara (`pli-tv-pvr`).

Table of data with columns `segment_id` and `segment_text`.  
Available formats: `.Rda`, `.tsv`.


#### [#dataset_2](https://github.com/chaz23/sutta-science/tree/main/data/vinaya-translations/dataset_2) <a name="vinaya-translations-dataset-2"></a>· Tidied representation of Ajahn Brahmali's translation of the Vinaya Pitaka  

This is an augmented version of the [raw download](#vinaya-translations-dataset-1). Some new features (eg: sutta title, sutta number) have been added, headers and subheaders have been removed, blank rows omitted, and data rearranged. 

Note that the column headers of this data table are identical with the tidied version of the sutta translations to allow easy appending in order to create a complete dataset of the sutta and vinaya pitakas.

Table of data with columns `segment_id`, `segment_text`, `sutta`, `section_num`, `segment_num`, `collection`, `sutta_num`, `title`.  
Available formats: `.Rda`, `.tsv`.

### :sparkles: Text references

#### [#dataset_1](https://github.com/chaz23/sutta-science/tree/main/data/references/dataset_1) <a name="text-references-dataset-1"></a>· Sutta Pitaka references for various editions of the Pali Canon

Maps references from over 40 editions of the Pali Canon to the Sutta Pitaka on a segment-level granularity.

Table of data with columns `segment_id`, `reference` and `edition`.  
Available formats: `.Rda`, `.tsv`.

#### [#dataset_2](https://github.com/chaz23/sutta-science/tree/main/data/references/dataset_2) <a name="text-references-dataset-2"></a>· Vinaya Pitaka references for various editions of the Pali Canon

Maps references from over 40 editions of the Pali Canon to the Vinaya Pitaka on a segment-level granularity.

Table of data with columns `segment_id`, `reference` and `edition`.  
Available formats: `.Rda`, `.tsv`.

## Tools and References

* For info on the SuttaCentral segment numbering system:
    * See discussion on [Discourse](https://discourse.suttacentral.net/t/making-sense-of-the-segment-numbering-system/23121).
    * See bilara-data [wiki](https://github.com/suttacentral/bilara-data/wiki/Bilara-segment-number-spec).