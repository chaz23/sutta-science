library(dplyr)
library(stringr)
library(jsonlite)
library(purrr)
library(glue)
library(tidyr)
library(furrr)

plan(multisession)




load(
  url(
    "https://github.com/chaz23/sutta-science/raw/main/data/sutta-translations/raw_sutta_data.Rda"
  )
)

raw_sutta_data <- raw_sutta_data %>% 
  mutate(sutta = str_extract(segment_id, "^.*(?=:)")) %>% 
  filter(str_detect(sutta, "^(dn|mn|sn|an|dhp|ud|snp|thig|thag|cp|iti|kp)"))




dppn_data <- read_json("./data/pali_proper_names/pli2en_dppn_copy.json")

dppn_df <- tibble()

# Convert JSON to a dataframe.
dppn_data %>% 
  walk(~ {
    dppn_df <<- dppn_df %>% 
      bind_rows(
        tibble(
          word = .x$word,
          definition = .x$text
        )
      )
  })




proper_names_dataset <- dppn_df %>%
  mutate(word_type = case_when(
    str_detect(definition, "class='person'") ~ "person",
    str_detect(definition, "class='place'") ~ "place",
    str_detect(definition, "class='thing'") ~ "thing",
    .default = "Other"
  )) %>% 
  
  # Remove the <dl> tag.
  mutate(definition = map2_chr(definition, word_type, ~ {
    str_remove_all(.x, glue("(<dl class='{.y}'>|</dl>)"))
  })) %>% 
  
  # Create new text references.
  mutate(definition = map_chr(definition, ~ {
    refs <- str_extract_all(.x, "<a .*?(?<=</a>)")[[1]]
    
    substitutions <- refs %>% 
      map_chr(~ {
        text <- str_extract(.x, "(?<=net/).*?(?=(/en/(sujato|brahmali)|/pli/ms))")
        segment_id <- str_extract(.x, "(?<=#).*?(?=')")
        substitution <- glue("{{text:[text],segment:[segment_id]}}", .open = "[", .close = "]")
      })
    
    if (length(refs) > 0) {
      definition_with_subs <- .x
      
      for (i in 1:length(refs)) {
        definition_with_subs <- str_replace(definition_with_subs, refs[i], substitutions[i])
      }
      
      definition_with_subs
    } else {
      .x
    }
  })) %>% 
  
  # Split multiple entries within a row into their own rows.
  mutate(definition = str_extract_all(definition, "<dt.*?</dd>")) %>% 
  unnest(cols = definition) %>% 
  
  # Extract ID (if exists).
  mutate(id = str_extract(definition, "(?<=id=').*?(?=')")) %>% 
  
  # Extract title.
  mutate(title = map_chr(definition, ~ {
    dfn_open_tag <- str_extract_all(.x, "<dfn.*?>")
    title <- str_extract(.x, glue("(?<={dfn_open_tag}).*?(?=</dfn>)"))
  })) %>% 
  
  # Extract core definition.
  mutate(definition = str_extract(definition, "(?<=<dd>).*?(?=</dd>)")) %>% 
  
  # Arrange by title.
  arrange(title) %>%
  
  # Create `person_type` field.
  mutate(person_type = case_when(
    str_detect(definition, "^<p>A (monk|Thera\\b)") ~ "Monks",
    str_detect(definition, "^<p>A (nun|Therī|bhikkhunī)") ~ "Nuns",
    str_detect(definition, "Pacceka") & word != "aputtaka" ~ "Pacceka Buddhas",
    str_detect(definition, "class of (deva|god)") ~ "Classes of Devas",
    str_detect(definition, "^<p>A householder") ~ "Householders",
    str_detect(definition, "A class of Nāga") ~ "Classes of Nāgas",
    str_detect(definition, "A class of Asura") ~ "Classes of Asuras",
    str_detect(definition, "A class of ascetics") ~ "Classes of Ascetics",
    str_detect(definition, "^<p>A wander") ~ "Wanderers",
    str_detect(definition, "^<p>A headman") ~ "Headmans",
    str_detect(definition, "([Vv]assals?|One) of the Four Great King") ~ "Four Great Kings",
    str_detect(definition, "^<p>A (young )?brahmin") ~ "Brahmins",
    str_detect(definition, "^<p>A Yakkha") ~ "Yakkhas",
    str_detect(definition, "^<p>A Yakkhin") ~ "Yakkhinīs",
    str_detect(definition, "^<p>An epithet") ~ "Epithets",
    str_detect(definition, "^<p>A Brahmā") ~ "Brahmās",
    str_detect(definition, "^<p>A (celebrated )?sage") ~ "Sages",
    str_detect(definition, "^<p>A naked ascetic") ~ "Naked ascetics",
    .default = NA_character_
  )) %>% 
  
  # # Extract texts where the word definitely appears.
  # mutate(definite_text_matches = map_chr(definition, ~ {
  #   refs <- str_extract_all(.x, "(?<=\\{\\{text:).*?(?=,)")[[1]] %>% 
  #     paste0(collapse = ",")
  # })) %>% 
  # 
  # # Find texts where the word possibly appears.
  # mutate(possible_text_matches = future_map_chr(title, ~ {
  #   raw_sutta_data %>% 
  #     filter(str_detect(segment_text, .x)) %>% 
  #     distinct(sutta) %>% 
  #     pull() %>% 
  #     paste0(collapse = ",")
  # }))


# proper_names_dataset %>% 
#   filter(str_detect(definition, "foremost among"))
#   mutate(is_foremost_disciple = TRUE)


# Write data.
# write_json(proper_names_dataset, path = "./data/pali_proper_names/proper_names_dataset.json")