library(tidymodels)
library(httr)
library(jsonlite)
library(embed)
library(stringr)


# Load data.

load(url("https://github.com/chaz23/sutta-science/raw/main/data/sutta-translations/sutta_data.Rda"))

load(url("https://github.com/chaz23/sutta-science/raw/main/data/sutta-translations/kn_sutta_data.Rda"))

sutta_data <- sutta_data %>% 
  bind_rows(kn_sutta_data)


# Retreive embeddings.

embeddings_url <- "https://api.openai.com/v1/embeddings"

auth <- add_headers(Authorization = paste("Bearer", Sys.getenv("OPENAI_API_KEY")))

embeddings_by_section <- sutta_data %>% 
  group_by(sutta, section_num) %>% 
  summarise(section_text = paste(segment_text, collapse = " ")) %>% 
  ungroup() %>% 
  mutate(group = row_number() %/% 2048)
  
groups <- unique(embeddings_by_section$group)

embeddings_df <- tibble()

for (i in groups) {
  df <- embeddings_by_section %>% 
    filter(group == i)
  
  body_section <- list(model = "text-embedding-3-small", 
                       input = df$section_text)
  
  resp_section <- POST(
    embeddings_url,
    auth,
    body = body_section,
    encode = "json"
  )
  
  section_embeddings <- content(resp_section, 
                                as = "text", 
                                encoding = "UTF-8") %>% 
    fromJSON(flatten = TRUE) %>% 
    pluck("data", "embedding")
  
  new_embeddings <- enframe(section_embeddings, value = "embeddings") %>% 
    select(-name)
  
  embeddings_df <- embeddings_df %>% 
    bind_rows(new_embeddings)
  
  Sys.sleep(15)
}

embeddings_by_section_pre_umap <- embeddings_by_section %>% 
  select(-group) %>% 
  bind_cols(embeddings_df)


# Reduce dimensionality.

set.seed(123)

embeddings_by_section <- embeddings_by_section_pre_umap %>% 
  unnest_wider(embeddings, names_sep = "_") %>% 
  recipe(~ ., data = .) %>% 
  step_umap(embeddings_1:embeddings_1536, num_comp = 2) %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  rename(x = UMAP1, y = UMAP2)

sutta_first_segments <- sutta_data %>% 
  group_by(sutta, section_num) %>% 
  slice_head(n = 1) %>% 
  select(sutta, section_num, first_segment_num = segment_num)

embeddings_by_section <- embeddings_by_section %>% 
  left_join(sutta_first_segments, 
            join_by(sutta, section_num))



# Save.

embeddings_by_section_pre_umap_dn <- embeddings_by_section_pre_umap %>% filter(str_detect(sutta, "^dn"))
embeddings_by_section_pre_umap_mn <- embeddings_by_section_pre_umap %>% filter(str_detect(sutta, "^mn"))
embeddings_by_section_pre_umap_an <- embeddings_by_section_pre_umap %>% filter(str_detect(sutta, "^an"))
embeddings_by_section_pre_umap_sn <- embeddings_by_section_pre_umap %>% filter(str_detect(sutta, "^sn[0-9]"))
embeddings_by_section_pre_umap_kn <- embeddings_by_section_pre_umap %>% filter(!str_detect(sutta, "^(dn|mn|an|sn[0-9])"))

save(embeddings_by_section_pre_umap_dn, 
     file = "./data/text-embeddings/embeddings_by_section_pre_umap_dn.Rda")
save(embeddings_by_section_pre_umap_mn, 
     file = "./data/text-embeddings/embeddings_by_section_pre_umap_mn.Rda")
save(embeddings_by_section_pre_umap_an, 
     file = "./data/text-embeddings/embeddings_by_section_pre_umap_an.Rda")
save(embeddings_by_section_pre_umap_sn, 
     file = "./data/text-embeddings/embeddings_by_section_pre_umap_sn.Rda")
save(embeddings_by_section_pre_umap_kn, 
     file = "./data/text-embeddings/embeddings_by_section_pre_umap_kn.Rda")

save(embeddings_by_section,
     file = "./data/text-embeddings/embeddings_by_section.Rda")

write.csv(embeddings_by_section, 
          file = "./data/text-embeddings/embeddings_by_section.csv", 
          row.names = FALSE)
