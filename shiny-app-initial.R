# import libraries
library(shiny)

##########
# SERVER #
##########

#generic line initiating the SERVER 

server <- shinyServer(function(input, output) {
  
  #########################
  # Data load and cleanup #
  #########################
  
  #Import data
  
  #Clean data
  
  #############
  # Reactives #
  #############
  
  # define any reactive elements of the app
  
  #Close the server definition
})

##################
# User Interface #
##################

#generic line initiating the UI
ui <- shinyUI(fluidPage(
  
  #Add a title
  titlePanel("Whakahura: Extreme Weather Events and the Emergence of CLimate Change"),
  
  #This creates a layout with a left sidebar and main section
  sidebarLayout(
    
    #beginning of sidebar section
    #usually includes inputs
    sidebarPanel(),
    
    #beginning of main section
    mainPanel()
  )
  
  #Close the UI definition
))

##############
# Launch App #
##############

#generic line that launches the app
shinyApp(ui = ui, server = server)