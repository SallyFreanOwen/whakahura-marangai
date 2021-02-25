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
 
  if(result_count>100 & result_count<200) {
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
  write(results_items_df, file = filename)
  
  #head(call_results_items_df)
  
  # Bind different searches together 
 # record_items_df <- dplyr::bind_rows( )
  
  # Arrange scraped results as jsons: 
  results_items_json <- serializeJSON(results_items_df, pretty = FALSE)
  
  # Save using search term as filename 
  filename <- paste("data/digital_nz_results_", search_term_clean, ".json", sep = "")
  write(results_items_json, file = filename)
  
  # Encode as json-ld rdf (ON HOLD) 
  
  # Repeat for publishers 
   #call_results_publishers_df <- data.frame(unique(results_items_df$publisher))
  
########################################  
  
  ###  To-do list: 
  
  #     - sort out saving multiple search terms into same json  
  #     - add publishers option 
  
  #     - create new GitHub repository to host full public database 
  #     - add new website to that new rpo 
  #     - host Quality Assured database in that site, at /data 
  #     - add text to page with protocols/tikanga 
  #     - investigate password protection 
  
  # LOWER PRIORITY  
  
  #     - add Linked.Art encoding 
  
  #     - add querying User Interface 
  #     - create sql-query box
  
  #     - add geopgraphies of publishers 
  
  