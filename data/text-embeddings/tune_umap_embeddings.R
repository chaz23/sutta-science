library(tidymodels)
library(embed)

load("./data-generation/text-embeddings/embeddings_by_section_dn.Rda")
load("./data-generation/text-embeddings/embeddings_by_section_mn.Rda")
load("./data-generation/text-embeddings/embeddings_by_section_an.Rda")
load("./data-generation/text-embeddings/embeddings_by_section_sn.Rda")
load("./data-generation/text-embeddings/embeddings_by_section_kn.Rda")

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
  neighbors = c(5, 10, 15, 25, 50, 75, 100, 125, 150, 175, 200),
  min_dist = c(0, 0.05, 0.1, 0.2, 0.35, 0.5, 0.7, 0.85, 0.99)
) %>% 
  mutate(data = map2(neighbors, min_dist, ~ {
    embeddings_wide %>% 
      recipe(~ ., data = .) %>% 
      step_umap(embeddings_1:embeddings_1536, num_comp = 2, neighbors = .x, min_dist = .y) %>% 
      prep() %>% 
      bake(new_data = NULL) %>% 
      rename(x = UMAP1, y = UMAP2)
  })) %>% 
  unnest(data)

save(umap_grid, file = "./data-generation/text-embeddings/umap_grid.Rda")