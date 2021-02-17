#################################################

# Working on arranging the scrape into rdf 

#################################################

# Prep: packages

if (!("rvest" %in% installed.packages())) {
  install.packages("rvest")
}
if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
}

if (!("curl" %in% installed.packages())) {
  install.packages("curl")
}

if (!("rdflib" %in% installed.packages())) {
  install.packages("rdflib")
}

if (!("tidyr" %in% installed.packages())) {
  install.packages("tidyr")
}

if (!("tibble" %in% installed.packages())) {
  install.packages("tibble")
}

if (!("jsonld" %in% installed.packages())) {
  install.packages("jsonld")
}

library(rvest) # (also installs xml2)
library(dplyr)
library(curl)
library(rdflib)
library(tidyr)
library(tibble)
library(jsonld)

#################################################

# Scrape one set of terms:
  
  ### Using a set of phrases to search for records
  
  # url this: 
  search_term <- "kainga+earthquake+damage"

  call <- paste("https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG&text=",
                search_term, 
                sep = "")
  
  call_pages <- read_html(call)
  
  result_count <- as.character(
    call_pages %>% 
      rvest::html_node("search") %>%
      xml2::xml_find_all("result-count") %>% 
      rvest::html_text())
  
  # harvest record_id, title, date, full_text, publisher, link 
  record_id <- call_pages %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all("//results/result/id") %>% 
    rvest::html_text()
  
  date <- call_pages %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all("//results/result/display-date") %>% 
    rvest::html_text()
  
  api_link <- call_pages %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all("//results/result/source-url") %>% 
    rvest::html_text()
  
  page_link <- call_pages %>% 
    rvest::html_nodes("search") %>% 
    xml2::xml_find_all("//results/result/landing-url") %>% 
    rvest::html_text()
  
  publisher <- call_pages %>% 
    rvest::html_nodes("results") %>% 
    xml2::xml_find_all("//results/result/content-partner") %>% 
    rvest::html_text()
  
  title <- call_pages %>% 
    rvest::html_nodes("results") %>% 
    xml2::xml_find_all("//results/result/title") %>% 
    rvest::html_text()
  
  usage <- call_pages %>% 
    rvest::html_nodes("results") %>% 
    xml2::xml_find_all("//results/result/usage") %>% 
    rvest::html_text()
  
  full_text  <- call_pages %>% 
    rvest::html_nodes("results") %>% 
    xml2::xml_find_all("//results/result/fulltext") %>% 
    rvest::html_text()
  
  # Arrange scraped results as dataframes: 
  
  call_results_items_df <- data.frame(record_id, title, date, full_text, usage, api_link, page_link, publisher)
  mutate(call_results_df, 
         ifelse(usage == "All rights reserved", full_text == ""))
  
  call_results_publishers_df <- data.frame(unique(publisher))
  
  