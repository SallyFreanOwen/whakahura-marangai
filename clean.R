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
results <- rename(results[12], text)
results <- select(results, full_text)
rename

save(results, file = "data/records_for_quality_assuring.RData")

write.csv(results, file = "data/records_for_quality_assuring.csv")
