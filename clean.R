#################################################

# .RData of metadata on digital NZ resources are 
# edited by this programme. 

#################################################

# clear workspace 
rm(list = ls())

# call libraries
library(dplyr)

# Open data
load("data/digital_nz_results.RData")

# clean 
results_raw <- results

# usage 
unique(results_raw$usage)
#[1] "All rights reserved" "ShareModifyUse commercially" "ShareModify" "Share"  "Unknown"
results <- dplyr::filter(results, usage !=  "All rights reserved") 


head(results)
  