# A script to create a hierarchy of the Vinaya Pitaka.
# The main purpose of this dataset is to pass is to pass it to functions like d3.stratify.

library(dplyr)
library(httr2)
library(purrr)
library(stringr)
library(glue)




# Define the API endpoint.
api_endpoint <- "https://suttacentral.net/api/menu"
root_node <- "vinaya"

# Prepare the request.
req <- request(api_endpoint) %>% 
  req_headers("Accept" = "application/json")

# Create an empty dataframe to store the results.
vinaya_hierarchy <- tibble()

# Create an exclusion list to specify which nodes not to recurse through or append to the hierarchy. 
exclusion_list <- list(
  recurse = c(
    "lzh-mg-vi", "san-mg-vi", "san-lo-vi", "lzh-mi-vi", "lzh-dg-vi", "pgd-dg-vi", "lzh-sarv-vi", "san-sarv-vi", "lzh-mu-vi", "san-mu-vi", "xct-mu-vi",
    "other-vi"
  ),
  append = c()
)




# Define a recursive function to populate the `sutta_hierarchy` dataframe.
recurse_through_hierarchy <- function(uid, parent_uid) {
  # Send the request and extract the contents.
  resp <- req %>% 
    req_url_path_append(uid) %>% 
    req_perform() %>% 
    resp_body_json() %>% 
    pluck(1)
  
  # If the node is not in `exclusion_list$append`, then append the elements to `vinaya_hierarchy`.
  if (!resp$uid %in% exclusion_list$append) {
    vinaya_hierarchy <<- vinaya_hierarchy %>% 
      bind_rows(
        tibble(
          id = resp$uid,
          parent_id = parent_uid,
          pali_title = resp$root_name,
          title = resp$translated_name,
          blurb = resp$blurb,
          acronym = resp$acronym,
          child_range = resp$child_range,
          node_type = resp$node_type
        )
      )
  }
  
  # Recurse through all the child elements.
  resp$children %>% 
    map(~ {
      print(.x$uid)
      if (!is_null(.x$uid)) {
        if (!.x$uid %in% exclusion_list$recurse) {
          recurse_through_hierarchy(.x$uid, uid)
        }
      }
    })
}



# Create the hierarchy.
root_node %>%
  recurse_through_hierarchy("menu")

# Clean the final results.
vinaya_hierarchy <- vinaya_hierarchy %>%
  mutate(parent_id = case_when(parent_id == "menu" ~ "",
                               parent_id == "long" ~ "sutta",
                               parent_id == "middle" ~ "sutta",
                               parent_id == "mn-mulapannasa" ~ "mn",
                               parent_id == "mn-majjhimapannasa" ~ "mn",
                               parent_id == "mn-uparipannasa" ~ "mn",
                               parent_id == "linked" ~ "sutta",
                               parent_id == "numbered" ~ "sutta",
                               parent_id == "minor" ~ "sutta",
                               .default = parent_id)) %>%
  mutate(across(where(is.character), str_trim))




# Append suttaplex data.

suttaplex_hierarchy <- tibble()

extract_suttaplex_data <- function(x) {
  data <- tibble(
    uid = x$uid,
    difficulty = x$difficulty$level,
    parallel_count = x$parallel_count,
    translated_title = str_trim(x$translated_title)
  )
  
  suttaplex_hierarchy <<- suttaplex_hierarchy %>% 
    bind_rows(data)
}

append_to_suttaplex_hierarchy <- function(collection) {
  suttaplex_api_endpoint <- glue("https://suttacentral.net/api/suttaplex/{collection}")
  
  suttaplex_req <- request(suttaplex_api_endpoint) %>% 
    req_headers("Accept" = "application/json") %>% 
    req_perform() %>% 
    resp_body_json()
  
  suttaplex_req %>% 
    walk(extract_suttaplex_data)
}

c("pli-tv-vi") %>% 
  walk(append_to_suttaplex_hierarchy)

vinaya_hierarchy <- vinaya_hierarchy %>% 
  left_join(suttaplex_hierarchy, join_by(id == uid)) %>% 
  mutate(title = if_else(is.na(title), translated_title, title)) %>% 
  select(-translated_title) %>% 
  mutate(parent_id = if_else(id == "sutta", "", parent_id))



# Save data.
save(vinaya_hierarchy, file = "./data/vinaya-hierarchy/vinaya_hierarchy.Rda")

