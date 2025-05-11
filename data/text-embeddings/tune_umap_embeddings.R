library(tidymodels)
library(embed)
library(furrr)

plan(multisession)

load("./data/text-embeddings/embeddings_by_section_pre_umap_dn.Rda")
load("./data/text-embeddings/embeddings_by_section_pre_umap_mn.Rda")
load("./data/text-embeddings/embeddings_by_section_pre_umap_an.Rda")
load("./data/text-embeddings/embeddings_by_section_pre_umap_sn.Rda")
load("./data/text-embeddings/embeddings_by_section_pre_umap_kn.Rda")

embeddings_by_section_pre_umap <- bind_rows(
  embeddings_by_section_pre_umap_dn,
  embeddings_by_section_pre_umap_mn,
  embeddings_by_section_pre_umap_an,
  embeddings_by_section_pre_umap_sn,
  embeddings_by_section_pre_umap_kn
)

embeddings_wide <- embeddings_by_section_pre_umap %>% 
  select(sutta, section_num, embeddings) %>% 
  unnest_wider(embeddings, names_sep = "_")

umap_grid <- crossing(
  min_dist = c(0, 0.5, 0.99),
  metric = c("euclidean", "cosine", "correlation")
) %>% 
  mutate(data = future_pmap(
    list(min_dist, metric), 
    function(min_dist, metric) {
      embeddings_wide %>% 
        recipe(~ ., data = .) %>% 
        step_umap(embeddings_1:embeddings_1536, num_comp = 2, min_dist = min_dist, metric = metric) %>% 
        prep() %>% 
        bake(new_data = NULL) %>% 
        rename(x = UMAP1, y = UMAP2)
    })) %>% 
  unnest(data)

save(umap_grid, file = "./data-generation/text-embeddings/umap_grid.Rda")