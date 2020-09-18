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

# Tell it what page to scrape

item1page <- "https://paperspast.natlib.govt.nz/newspapers/PBH19380602.2.27?query=flooding+marae&snippet=true"

### recall to follow along live:
  # cmd option C shows the code of the site 

item1 <- read_html(item1page)
item1
str(item1)

body_nodes <- item1 %>% 
  html_node("body") %>% 
  html_children()
body_nodes