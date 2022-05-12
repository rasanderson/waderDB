# Wader DB main script

library(shiny)
library(sf)
library(leaflet)
library(leafem)
library(leaflet.providers)
library(dplyr)


# Define UI for application that draws a histogram
ui <- fluidPage(
    navlistPanel(
        id = "tabset",
        "Wader DB",
        tabPanel("Vector",
                 h2("Vector data"),
                 p("Select catchment and river data from this page"),
                 leafletOutput("vector_map")),
        tabPanel("Raster",
                 h2("Raster data"),
                 p("Select land cover and elevation data from this page"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    coast_os <- readRDS("data/coast.RDS")
    coast_ll <- st_transform(coast_os, 4326)
    coast_ll <- dplyr::mutate(coast_ll, label = "Wader study region")
    
    output$vector_map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>% 
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addFeatures(coast_ll) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
