# Wader DB main script

library(shiny)
library(sf)
library(leaflet)
library(leafem)
library(leaflet.providers)
library(dplyr)

vector_regions <- c("Whole area", "IHU areas", "Wader groups", "Wader areas", "Wader region")

ui <- fluidPage(
    navlistPanel(
        id = "tabset",
        "Wader DB",
        tabPanel("Vector",
                 h2("Vector data"),
                 p("Select catchment and river data from this page"),
                 radioButtons("region", "Select vector dataset", vector_regions),
                 leafletOutput("vector_map"),
                 p(),
                 p("Data download is R internal RDS format. Use readRDS to input into R."),
                 downloadButton("download_vect", "Download RDS")),
        tabPanel("Raster",
                 h2("Raster data"),
                 p("Select land cover and elevation data from this page"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    observeEvent(input$region, {
        selected_region <- input$region
        #cat(file=stderr(), "selected region is", input$region, "\n")
        if(selected_region == "Whole area"){
            output$vector_map <- renderLeaflet({
                leaflet() %>%
                    addTiles() %>% 
                    addProviderTiles(providers$Esri.WorldImagery,
                                     options = providerTileOptions(noWrap = TRUE)
                    ) %>%
                    addFeatures(coast_ll) 
            })
            output$download_vect <- downloadHandler(
                filename = function() {
                    paste0(input$dataset, ".RDS")
                },
                content = function(file) {
                    saveRDS(coast_os, file)
                })

           
        } else if(selected_region == "IHU areas"){
            output$vector_map <- renderLeaflet({
                leaflet() %>%
                    addTiles() %>% 
                    addProviderTiles(providers$Esri.WorldImagery,
                                     options = providerTileOptions(noWrap = TRUE)
                    ) %>%
                    addFeatures(areas_ll)
            })
            output$download_vect <- downloadHandler(
                filename = function() {
                    paste0(input$dataset, ".RDS")
                },
                content = function(file) {
                    saveRDS(areas_os, file)
                })
            
        } else if(selected_region == "Wader groups"){
            output$vector_map <- renderLeaflet({
                leaflet() %>%
                    addTiles() %>% 
                    addProviderTiles(providers$Esri.WorldImagery,
                                     options = providerTileOptions(noWrap = TRUE)
                    ) %>%
                    addFeatures(wader_groups_ll)
            })
            output$download_vect <- downloadHandler(
                filename = function() {
                    paste0(input$dataset, ".RDS")
                },
                content = function(file) {
                    saveRDS(wader_groups_os, file)
                })
            
        } else if(selected_region == "Wader areas"){
            output$vector_map <- renderLeaflet({
                leaflet() %>%
                    addTiles() %>% 
                    addProviderTiles(providers$Esri.WorldImagery,
                                     options = providerTileOptions(noWrap = TRUE)
                    ) %>%
                    addFeatures(wader_areas_ll)
            })
            output$download_vect <- downloadHandler(
                filename = function() {
                    paste0(input$dataset, ".RDS")
                },
                content = function(file) {
                    saveRDS(wader_areas_os, file)
                })
         } else if(selected_region == "Wader region"){
                output$vector_map <- renderLeaflet({
                    leaflet() %>%
                        addTiles() %>% 
                        addProviderTiles(providers$Esri.WorldImagery,
                                         options = providerTileOptions(noWrap = TRUE)
                        ) %>%
                        addFeatures(wader_region_ll)
                })
                output$download_vect <- downloadHandler(
                    filename = function() {
                        paste0(input$dataset, ".RDS")
                    },
                    content = function(file) {
                        saveRDS(wader_region_os, file)
                    })
                
 
        }
    })

    # output$download_vect <- downloadHandler(
    #     filename = function() {
    #         paste0(input$dataset, ".RDS")
    #     },
    #     content = function(file) {
    #         saveRDS(data_out, file)
    #     })
}

# Run the application 
shinyApp(ui = ui, server = server)
