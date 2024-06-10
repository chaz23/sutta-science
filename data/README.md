## Datasets

### Sutta translations: `sutta-translations`  

This data is based on Bhante Sujato's translations of the Sutta Pitaka.  

There is the "raw" version, which is just the segment ID and the associated text, and then a "tidied" version, which has done a bit of data cleaning on it.

### Vinaya translations: `vinaya-translations`

This data is based on Ajahn Brahmali's translations of the Vinaya Pitaka. Again, there is a raw and tidied version.

### Text embedding models: `text-embeddings`

This data has broken down suttas into "sections" (still based on the segment ID but larger than segments) and passed it through OpenAI's `text-embedding-3-small` model. It's then had its dimensionality reduced down to 2D using the [UMAP](https://umap-learn.readthedocs.io/en/latest/index.html) algorithm.  

There are datasets that hold both the full embeddings (broken down by nikaya due to size constraints) as well as the lower dimensional projections.

### HTML for rendering sutta and vinaya content: `html`

This data collates the HTML to render each segment; useful for web-based applications.

### Text references: `references` 

This data maps various editions of the Pali Canon together.

