# Wader DB main script

library(shiny)
library(sf)
library(leaflet)
library(leafem)
library(leaflet.providers)
library(dplyr)
library(tmap)


vector_regions <- c("Whole area", "IHU areas", "Wader groups", "Wader areas", "Wader region")

ui <- fluidPage(
    navlistPanel(
        id = "tabset",
        "Wader DB",
        tabPanel("Main regions",
                 display_mapUI("region",
                               heading = "Regional boundaries",
                               description = "Select catchment Integrated Hydrological Units (EA) from this page",
                               map_info = region_df
                               )),
        tabPanel("Budle Bay bathymetric",
                 h2("Detailed modelling by Steve for Budle Bay"),
                 p("Select spatial resolution"),
                 radioButtons("budle_res", "Select resolution", c("50m", "75m", "100m")),
                 leafletOutput("raster_map"),
                 p(),
                 p("Data download is R internal RDS format. Use readRDS to input into R."),
                 downloadButton("download_rast", "Download RDS")),
        tabPanel("WFD Northumbria",
                 display_mapUI("WFD",
                               heading = "Water Frameworks Directive Northumbria",
                               description = "Environment agency data from WFD for Northumbria",
                               map_info = northumbria_wfd_df)),
        tabPanel("Water Quailty",
                 display_mapUI("points",
                               heading = "Water sampling points",
                               description = " Sample data collected to monitor water quality",
                               map_info = wqd_df)),
        tabPanel("Explore all",
                h2("All spatial data"),
                p("BE PATIENT - The map takes a minute to load"),
                p(" All data are displayed on the map, you can toggle through the 
                  layers and turn their display off and on using the icon in the top left of the map.
                  Click on an object to see the type of information that is held for that object."),
                tmapOutput("mapall"))
    )
)

# Define server logic 
server <- function(input, output) {

    display_raster <- function(selected_region, raster_df){
      this_choice <- filter(raster_df, selected_region == selection)
      output$raster_map <- renderLeaflet({
        leaflet() %>%
          addTiles() %>%
          addProviderTiles(providers$Esri.WorldImagery,
                           options = providerTileOptions(noWrap = TRUE)
          ) %>%
          addRasterImage(get(this_choice[1,"ll_map"]), colors=topo.colors(25, alpha = 0.5))
      })
      output$download_rast <- downloadHandler(
        filename = function() {
          paste0(input$download_rast, ".RDS")
        },
        content = function(file) {
          saveRDS(get(this_choice[1, "os_map"]), file)
        })
    }

    observeEvent(input$budle_res, {
      selected_res <- input$budle_res
      display_raster(selected_res, budle_df)
    })

    
    display_mapServer("region", region_df)
    # display_mapServer("budle", budgle_df, type = "raster") # Needs doing
    display_mapServer("WFD", northumbria_wfd_df)

    
    # display all data on an interactive map
    output$mapall <- renderTmap({

tm_shape(hibb_wqd_po)+tm_dots(col = "blue")+
        tm_shape(ndt_spat_po)+tm_dots()
    })

 }

# Run the application 
shinyApp(ui = ui, server = server)
