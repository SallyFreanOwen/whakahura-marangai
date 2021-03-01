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
results <- dplyr::transmute(results_raw, 
                         full_text <- if_else(usage !=  "All rights reserved", 
                                 full_text, 
                                 "Unavailable, see source"))

head(results)
  