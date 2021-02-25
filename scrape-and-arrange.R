#################################################

# Digital NZ resources are harvested by this R programme, 
# which will encode these in RDF using the JSON-LD 
# serialisation format. Linked.art ontology is proposed for 
# the RDF encoding. This RDF will be loaded into a 
# TripleStor for SPARKL query.  

#################################################

# Prep: packages
packages_to_install <- c("rvest", 
                         "dplyr", 
                         "curl", 
                         "rdflib",
                         "tidyr",
                         "tibble",
                         "jsonld",
                         "jsonlite",
                         "purrr",
                         "XML",
                         "rjson", 
                         "stringr"
                         )

for (i in length(packages_to_install)){
  if (!(packages_to_install[i] %in% installed.packages())) {
  install.packages(packages_to_install[i])
    }
  }

# Call packages: 

library(rvest) # (also calls xml2)
#library(xml2)
library(dplyr)
library(curl)
library(rdflib)
library(tidyr)
library(tibble)
library(jsonld)
library(jsonlite)
library(purrr)
library(XML)
library(rjson)
library(stringr)


#################################################

# Scrape:
  
  ### Using a set of phrases to search for records on DigitalNZ 
  
  # url creation - adding specifiers: 
  search_term <- "&text=marae+flooding" 
  search_term_clean <- str_remove(search_term, "&text=")
  #usage_term <- "&usage=Share" #only collect share-able items
  

  call <- paste("https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG",
                search_term, 
                #usage_term,
                "&per_page=100",
                "&sort=date",
                sep = "")
  
  doc <- read_html(call)

  result_count <- as.character(
    doc %>% 
      rvest::html_node("search") %>%
      xml2::xml_find_all("result-count") %>% 
      rvest::html_text())
  
  print(paste("Using", search_term, "this scrape finds", result_count, "terms"))
  
  # # Second page of results (as result_count > 100)
  # call2 <- paste("https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG",
  #                search_term, 
  #                #usage_term,
  #                "&per_page=100",
  #                "&page=2",
  #               "&sort=date",
  #                sep = "")
  # call_page2 <- read_html(call2)
  
  # harvest record_id, title, date published, full_text, publisher, links (in two lots if there are two pages)
  harvest <- function(x, y) {output <- x %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all(paste("//results", y)) %>% 
    rvest::html_text()
  return(output)
  }
  
  x <- doc
  y <- c("/result/id")
  record_id <- harvest(doc, y)
  y <- c("/result/display-date")
  display_date <- harvest(doc, y)
  y <- c("/result/source-url")
  page_link <- harvest(doc, y)
  y <- c("/result/landing-url")
  api_link <- harvest(doc, y)
  y <- c("/result/content-partner")
  publisher <- harvest(doc, y)
  y <- c("/result/title")
  title <- harvest(doc, y)
  y <- c("/result/usage")
  usage <- harvest(doc, y)
  y <- c("/result/fulltext")
  full_text <- harvest(doc, y)
  #y <- c("")
  # <- harvest(doc, y)

  # Arrange scraped results as data frame: 
  call_results_items_df <- data.frame(record_id, title, display_date, full_text, usage, api_link, page_link, publisher)
  
  call_results_items_df <- mutate(call_results_items_df, 
                                  search = search_term_clean)
  

  
  #head(call_results_items_df)
  

  # Bind different searches together 
 # record_items_df <- dplyr::bind_rows( )
  
  # Arrange scraped results as jsons: 
  call_results_items_json <- serializeJSON(call_results_items_df, pretty = FALSE)
  
  # Save using search term as filename 
  save(call_results_items_df, filename = paste("data/digital_nz_results_", search_term_clean, ".json"))
  
  # Encode as json-ld rdf (ON HOLD) 
  
  # Repeat for publishers 
  # call_results_publishers_df <- data.frame(unique(publisher))
 

  
########################################  
  
  #  Additional to-do list: 
  #     - sort out multi-page issue (known as Paging, see "Combining pages of JSON data with jsonlite")
  #     - add Linked.Art encoding 
  #     - create sql-query box 
  #     - sort out saving multiple search terms into same json database 
  #     - save as json in github 
  
  