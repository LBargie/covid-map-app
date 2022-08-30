library(shiny)
library(plotly)

# simple interface for displaying the map
ui <- fillPage(
  
  br(),
  
  plotlyOutput("map", width = "100%", height = "750px")
  
)