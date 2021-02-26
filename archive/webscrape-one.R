#########################

### Testing webscrape 

#########################

# Prep: packages

if (!("rvest" %in% installed.packages())) {
  install.packages("rvest")
  }
if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
  }
library(rvest) # (also installs xml2)
library(dplyr)
library(curl)

# Using a predefined record (single page) to scrape

item1page <- "https://api.digitalnz.org/v3/records/18388766.xml?api_key=M2w8CXHEAaiExaTTxXQG"
item1 <- read_html(item1page)
str(item1) # eyeball 

body_nodes <- item1 %>% 
  html_node("record") %>% 
  html_children()

# view list of nodes inside the record: 
body_nodes

# harvest record_id, title, date, full_text, publisher, link 
record_id <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//id") %>% 
  rvest::html_text()

full_text <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//fulltext") %>% 
  rvest::html_text()

date <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//display-date") %>% 
  rvest::html_text()

link <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//source-url") %>% 
  rvest::html_text()

publisher <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//publisher/publisher") %>% 
  rvest::html_text()

title <- item1 %>% 
  rvest::html_nodes("record") %>% 
  xml2::xml_find_all("//title") %>% 
  rvest::html_text()

record_df <- data.frame(record_id, title, date, full_text, source_link, publisher)
#knitr::kable(
#  record_df  %>% head(10))

### Using a set of phrases to search for records

# url this: 
marae_flooding_call <- "https://api.digitalnz.org/v3/records.xml?api_key=M2w8CXHEAaiExaTTxXQG&text=kaingaearthquake+damage"
marae_flooding_pages <- read_html(marae_flooding_call)

result_count <- as.character(
marae_flooding_pages %>% 
  rvest::html_node("search") %>%
  xml2::xml_find_all("result-count") %>% 
  rvest::html_text())

#marae_flooding_call_complete <- paste(marae_flooding_call, "&+perpage=", result_count, sep = "")
marae_flooding_pages <- read_html(marae_flooding_call_complete)

# harvest record_id, title, date, full_text, publisher, link 
record_id <- marae_flooding_pages %>% 
  rvest::html_nodes("search") %>% 
  xml2::xml_find_all("//results/result/id") %>% 
  rvest::html_text()

date <- marae_flooding_pages %>% 
  rvest::html_nodes("search") %>% 
  xml2::xml_find_all("//results/result/display-date") %>% 
  rvest::html_text()

api_link <- marae_flooding_pages %>% 
  rvest::html_nodes("search") %>% 
  xml2::xml_find_all("//results/result/source-url") %>% 
  rvest::html_text()

page_link <- marae_flooding_pages %>% 
  rvest::html_nodes("search") %>% 
  xml2::xml_find_all("//results/result/landing-url") %>% 
  rvest::html_text()

publisher <- marae_flooding_pages %>% 
  rvest::html_nodes("results") %>% 
  xml2::xml_find_all("//results/result/content-partner") %>% 
  rvest::html_text()

title <- marae_flooding_pages %>% 
  rvest::html_nodes("results") %>% 
  xml2::xml_find_all("//results/result/title") %>% 
  rvest::html_text()

usage <- marae_flooding_pages %>% 
  rvest::html_nodes("results") %>% 
  xml2::xml_find_all("//results/result/usage") %>% 
  rvest::html_text()

full_text  <- marae_flooding_pages %>% 
  rvest::html_nodes("results") %>% 
  xml2::xml_find_all("//results/result/fulltext") %>% 
  rvest::html_text()

results_marae_flooding_df <- data.frame(record_id, title, date, full_text, usage, api_link, page_link, publisher)
mutate(results_marae_flooding_df, 
       ifelse(usage == "All rights reserved", full_text == ""))


record_df <- data.frame(record_id, title, date, full_text, source_link, publisher)
#knitr::kable(
#  record_df  %>% head(10))



###### References

# Webscraping tutorial:
# https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47