#################################################

# Digital NZ resources are harvested by this R programme. 



#################################################

rm(list = ls())

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

rm(packages_to_install)

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

# Scrape and Arrange: 
  
  ### Using a set of phrases to search for records on DigitalNZ 
  
  # url creation - adding specifiers: 

  search_term <- "&text=maori+village+flooding+rain+damage" 
  
#earthquake
#seismic activity 
#rū whenua
#rūaumoko 

#extreme weather
#flooding 
#hail 
#lightning 
#storm 
# 
#uanui
#uaroa
#uawhatu
#uira 
#āwha 
#tūpuhi
#marangai

#marae
#kainga
#papakainga
#kura kaupapa
#hui 
#wananga 
#ūrupa 
#māori village 
#ngahere 
#awa 

  search_term_clean <- str_remove(search_term, "&text=")
  #usage_term <- "&usage=Share" #only collect share-able items

  call <- paste("https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG",
                search_term, 
                #usage_term,
                "&per_page=100",
                "&sort=date",
                sep = "")
  
  doc <- read_html(call)
  rm(call)

  result_count <- as.character(
    doc %>% 
      rvest::html_node("search") %>%
      xml2::xml_find_all("result-count") %>% 
      rvest::html_text())
  
  print(paste("Using", search_term, "this scrape finds", result_count, "terms"))
  

  
  harvest <- function(x, y) {output <- x %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all(paste("//results", y)) %>% 
    rvest::html_text()
  return(output)
  }
  
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
  y <- c("/result/creator")
  creator <- harvest(doc, y)
  y <- c("/result/title")
  title <- harvest(doc, y)
  y <- c("/result/usage")
  usage <- harvest(doc, y)
  y <- c("/result/fulltext")
  full_text <- harvest(doc, y)
  rm(y)
  #y <- c("")
  # <- harvest(doc, y)
  
  # Arrange scraped results as data frame: 
  call_results_items_df <- data.frame(record_id, title, display_date, full_text, usage, api_link, page_link, publisher, creator)
  rm(record_id, title, display_date, full_text, usage, api_link, page_link, publisher, creator)
  
  call_results_items_df <- mutate(call_results_items_df, 
                                  search = search_term_clean,
                                  page = 1,
                                  n_results = result_count)
  
  results_items_df <- call_results_items_df
  
 # Second page of results (as result_count > 100)
 
  if(as.numeric(result_count)>100&as.numeric(result_count)<200){
              page_term <- paste("&per_page=", as.numeric(result_count)-100,sep="")
              call2 <- paste("https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG",
                          search_term, 
                          #usage_term,
                          page_term,
                          "&page=2",
                          "&sort=date",
                          sep = "") 
            doc2 <- read_html(call2)
            rm(call2)
            # harvest record_id, title, date published, full_text, publisher, links (in two lots if there are two pages)
            doc <- doc2
            y <- c("/result/id")
            record_id <- harvest(doc, y)
            y <- c("/result/display-date")
            display_date <- harvest(doc, y)
            y <- c("/result/source-url")
            page_link <- harvest(doc, y)
            y <- c("/result/landing-url")
            api_link <- harvest(doc, y)
            y <- c("/result/creator")
            creator <- harvest(doc, y)
            y <- c("/result/content-partner")
            publisher <- harvest(doc, y)
            y <- c("/result/title")
            title <- harvest(doc, y)
            y <- c("/result/usage")
            usage <- harvest(doc, y)
            y <- c("/result/fulltext")
            full_text <- harvest(doc, y)
            rm(y)
            #y <- c("")
            # <- harvest(doc, y)
          
            # Arrange scraped results as data frame: 
            call2_results_items_df <- data.frame(record_id, title, display_date, full_text, usage, api_link, page_link, publisher, creator)
            rm(record_id, title, display_date, full_text, usage, api_link, page_link, publisher, creator)
            
            call2_results_items_df <- mutate(call2_results_items_df, 
                                            search = search_term_clean,
                                            page = 2,
                                            n_results = result_count)
            
            rm(page_term)
            
            # Bind pages of search together 
            results_items_df <- bind_rows(call_results_items_df, call2_results_items_df)
            
            # Tidy workspace
            rm(call2_results_items_df)
            rm(doc2)
  }
  
  # Tidy workspace
  rm(call_results_items_df)
  rm(result_count)
  rm(search_term)
  rm(doc)
  
  # Save using search term as filename 
  filename <- paste("data/digital_nz_results_", search_term_clean, ".Rdata", sep = "")
  save(results_items_df, file = filename)
  
  # Clear all 
  rm(list = ls())
  
  
  