# A script to create a hierarchy of the Sutta Pitaka.
# The main purpose of this dataset is to pass is to pass it to functions like d3.stratify.

library(dplyr)
library(httr2)
library(purrr)
library(stringr)




# Define the API endpoint.
api_endpoint <- "https://suttacentral.net/api/menu"
root_node <- "sutta"

# Prepare the request.
req <- request(api_endpoint) %>% 
  req_headers("Accept" = "application/json")

# Create an empty dataframe to store the results.
sutta_hierarchy <- tibble()

# Create an exclusion list to specify which nodes not to recurse through or append to the hierarchy. 
exclusion_list <- list(
  recurse = c(
    "da", "da-ot", 
    "ma", "ma-ot", 
    "sa", "sa-2", "sa-3", "sa-ot",
    "ea", "ea-2", "ea-ot",
    "dharmapadas", "minor-lzh", "vv", "pv", "tha-ap", "thi-ap", "bv", "ja", "mnd", "cnd", "ps", "ne", "pe", "mil",
    "other-group"
  ),
  append = c(
    "long", "middle", "linked", "numbered", "minor",
    "mn-mulapannasa", "mn-majjhimapannasa", "mn-uparipannasa"
  )
)




# Define a recursive function to populate the `sutta_hierarchy` dataframe.
recurse_through_hierarchy <- function(uid, parent_uid) {
  # Send the request and extract the contents.
  resp <- req %>% 
    req_url_path_append(uid) %>% 
    req_perform() %>% 
    resp_body_json() %>% 
    pluck(1)
  
  # If the node is not in `exclusion_list$append`, then append the elements to `sutta_hierarchy`.
  if (!resp$uid %in% exclusion_list$append) {
    sutta_hierarchy <<- sutta_hierarchy %>% 
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
      if (!.x$uid %in% exclusion_list$recurse) {
        recurse_through_hierarchy(.x$uid, uid)
      }
    })
}




# Create the hierarchy.
root_node %>% 
  recurse_through_hierarchy("menu")

# Clean the final results.
sutta_hierarchy <- sutta_hierarchy %>% 
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



# Save data.
save(sutta_hierarchy, file = "./data/sutta-hierarchy/sutta_hierarchy.Rda")

