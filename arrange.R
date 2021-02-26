#################################################

# .RData of metadata on digital NZ resources are 
# loaded by this R programme, and joined as a single json.

# It will (later) encode these in RDF using the JSON-LD 
# serialisation format. Linked.art ontology is proposed for 
# the RDF encoding. This RDF will be loaded into a 
# TripleStor for SPARKL query.  

#################################################

# Bind different scraped searches together 
dataframe_names <- list.files(path = "data/", pattern = "*.Rdata")
dataframe_paths <- paste("data/", dataframe_names, sep = "")

# Load all # NEEDS AUTOMATING
  i=1
  load(dataframe_paths[i])
  assign(paste("result_", i, sep = ""), results_items_df)
  i=2
  load(dataframe_paths[i])
  assign(paste("result_", i, sep = ""), results_items_df)
  i=3
  load(dataframe_paths[i])
  assign(paste("result_", i, sep = ""), results_items_df)

  rm(results_items_df)

# Bind different searches:   # NEEDS AUTOMATING
results <- rbind(result_1, result_2)
results <- rbind(results, result_3)

# Arrange scraped results as jsons: 
results_items_json <- serializeJSON(results, pretty = FALSE)

# Save using search term as filename 
write(results_items_json, file = "data/digital_nz_results.json")

# Encode:   

# Encode as json-ld rdf (ON HOLD) 

########################################  

###  To-do list: 

#     - add publishers option 

#     - create new GitHub repository to host full public database 
#     - add new website to that new rpo 
#     - host Quality Assured database in that site, at /data 
#     - add text to page with protocols/tikanga 
#     - investigate password protection 

# LOWER PRIORITY  

#     - json to RDF 
#     - add Linked.Art encoding 

#     - add querying User Interface 
#     - create sql-query box

#     - add geopgraphies of publishers 

####

# Note different terminologies: 

# RDF	        subject	  predicate	    object
# JSON	      object	  property	    value
# spreadsheet	row id	  column name	  cell