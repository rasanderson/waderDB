# Shiny module for map display and data download. As this is likely to be a
# common pattern for many datasets, might be simplest as a module

display_mapUI <- function(id, heading, description, map_info){
    tagList(
      h2(heading),
      p(description),
      radioButtons(NS(id, "radio"), "Select dataset", choices = map_info$selection),
      leafletOutput(NS(id, "leaflet_map")),
      p("download data"),
      downloadButton(NS(id, "download_R"), "Download RDS")
    )
}

display_mapServer <- function(id, map_info){
  moduleServer(id, function(input, output, session){
    observeEvent(input$radio, {
      this_choice <- filter(map_info, input$radio == selection)
      this_ll_map <- get(this_choice[1, "ll_map"])
      this_os_map <- get(this_choice[1, "os_map"])
      
      output$leaflet_map <- renderLeaflet({
        leaflet() %>% 
          addTiles() %>%
          addProviderTiles(providers$Esri.WorldImagery,
                           options = providerTileOptions(noWrap = TRUE)
          )  %>%
          addFeatures(this_ll_map)
      })
      output$download_vect <- downloadHandler(
        filename = function() {
          paste0(input$download_R, ".RDS")
        },
        content = function(file) {
          saveRDS(get(this_choice[1, "this_os_map"]), file)
        })
    })    
  })
}