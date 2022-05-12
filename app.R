# Wader DB main script

library(shiny)
library(sf)
library(leaflet)
library(leafem)
library(leaflet.providers)
library(dplyr)

source("R/vector_plot.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
    navlistPanel(
        id = "tabset",
        "Wader DB",
        tabPanel("Vector",
                 h2("Vector data"),
                 p("Select catchment and river data from this page"),
                 leafletOutput("vector_map"),
                 downloadButton("download_vect", "Download RDS")),
        tabPanel("Raster",
                 h2("Raster data"),
                 p("Select land cover and elevation data from this page"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$vector_map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>% 
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
                             ) %>%
            addFeatures(coast_ll) 
    })
    
    data <- reactive(
        coast_os
    )
    
    output$download_vect <- downloadHandler(
        filename = function() {
            paste0(input$dataset, ".RDS")
        },
        content = function(file) {
            saveRDS(data(), file)
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
