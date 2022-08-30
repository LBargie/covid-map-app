library(jsonlite)
library(httr)
library(dplyr)
library(lubridate)

opendata_api <- function(resource){
  
  # Get URL using the specified resource ID
  url <- paste0(
    "https://www.opendata.nhs.scot/api/3/action/datastore_search?resource_id=",
    resource,
    "&limit=100000"
    )
  
  # Make API request
  return(GET(url))
  
}

response_results <- function(response){
  
  # Get JSON data
  return(fromJSON(content(response, "text")))
  
}

get_dataframe <- function(results){
  
  df <- results[["result"]][["records"]]
  
  # Parse the date column - ISO-8601 format
  df$Date <- as.Date(df$Date)
  
  return(df)
  
}

# Main function for getting covid data
covid_data <- function(resource_id){
  
  response <- opendata_api(resource_id)
  
  results <- response_results(response)
  
  return(get_dataframe(results))
  
}
