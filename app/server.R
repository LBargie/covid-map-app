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
  # What to search for if URL doesn't work (date could be different): Local Authority Districts (December 2022) Boundaries UK BUC
  map_url <- 
    "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2022_Boundaries_UK_BGC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"

  la_cases <- covid_data(resource)
  
  map <- st_read(map_url)

  scot_map <- map |>
    filter(str_detect(map$LAD22CD, "S"))
  
  data <- left_join(scot_map, la_cases[c("CA", "NewPositive", "TotalCases")], by = c("LAD22CD" = "CA"))
  
  output$map<- renderPlotly({
    plot_ly(
      data,
      type = "scatter",
      mode = "lines",
      split = ~LAD22NM,
      color = ~NewPositive,
      colors = "Blues",
      stroke = I("black"),
      showlegend = FALSE,
      text = ~paste(
        "New Cases:", NewPositive, 
        "\nTotal Cases:", TotalCases,
        "\nLocation:", LAD22NM, 
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