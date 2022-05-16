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
        tabPanel("Main regions",
                 h2("Regional boundaries"),
                 p("Select catchment Integrated Hydrological Units (EA) from this page"),
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

# Define server logic 
server <- function(input, output) {
    
    display_vector <- function(selected_region, vector_df){
        this_choice <- filter(vector_df, selected_region == selection)
            output$vector_map <- renderLeaflet({
                leaflet() %>%
                    addTiles() %>%
                    addProviderTiles(providers$Esri.WorldImagery,
                                     options = providerTileOptions(noWrap = TRUE)
                    ) %>%
                    addFeatures(get(this_choice[1,"ll_map"]))
            })
            output$download_vect <- downloadHandler(
                filename = function() {
                    paste0(input$download_vect, ".RDS")
                },
                content = function(file) {
                    saveRDS(get(this_choice[1, "os_map"]), file)
                })
    }
    
    observeEvent(input$region, {
        selected_region <- input$region
        #cat(file=stderr(), "selected region is", input$region, "\n")
        
        display_vector(selected_region, vector_df)
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
