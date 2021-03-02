#################################################

# .RData of metadata on digital NZ resources are 
# edited by this programme. 

#################################################

# clear workspace 
rm(list = ls())

# call libraries
library(dplyr)
library(tidyselect)
library(tidyr)

# Open data
load("data/digital_nz_results.RData")

# clean 
results_raw <- results

results <- dplyr::distinct(results_raw, record_id, .keep_all = TRUE)

# usage 
unique(results_raw$usage)
#[1] "All rights reserved" "ShareModifyUse commercially" "ShareModify" "Share"  "Unknown"

results <- mutate(results, 
              text <- ifelse(usage == "All rights reserved", "See source", full_text))
names(results)[13] <- "text"
results <- dplyr::select(results, -full_text)

names(results)[5] <- "link"
names(results)[6] <- "api_link"

#

results %>% mutate(Date1 = as.Date(date, format = "%m/%d/%Y"),
              Date2 = as.Date(paste0("01-",date,"-2013"), format = "%d-%B-%Y"),

              
short_results <- select(results,
                        record_id, title, )              
              
save(results, file = "data/records_for_quality_assuring.RData")

write.csv(results, file = "data/records_for_quality_assuring.csv")
