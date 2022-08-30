library(shiny)
library(plotly)
library(sf)
library(stringr)
source("data.R")

# Fetch the data and generate the interactive map
server <- function(input, output){
  
  # Public Health Scotland (PHS) api resource ID for the total cases by local authority dataset
  resource <- "e8454cf0-1152-4bcb-b9da-4343f625dfef"
  
  # URL for local authority areas map in the UK
  map_url <- "https://opendata.arcgis.com/datasets/21f7fb2d524b44c8ab9dd0f971c96bba_0.geojson"
  
  la_cases <- covid_data(resource)
  
  map <- st_read(map_url)
  
  scot_map <- map |>
    filter(str_detect(map$LAD21CD, "S"))
  
  data <- left_join(scot_map, la_cases[c("CA", "NewPositive", "TotalCases")], by = c("LAD21CD" = "CA"))
  
  output$map<- renderPlotly({
    plot_ly(
      data,
      type = "scatter",
      mode = "lines",
      split = ~LAD21NM,
      color = ~NewPositive,
      colors = "Blues",
      stroke = I("black"),
      showlegend = FALSE,
      text = ~paste(
        "New Cases:", NewPositive, 
        "\nTotal Cases:", TotalCases,
        "\nLocation:", LAD21NM, 
        "\nDate:", unique(la_cases$Date)
      ),
      hoverinfo = "text",
      hoveron = "fills"
    ) |>
      colorbar(title = "New Cases", len = 0.5) |>
      layout(
        title = paste(
          "Recent COVID-19 Cases in Scotland by Local Authority"
        )
      )
  })
}