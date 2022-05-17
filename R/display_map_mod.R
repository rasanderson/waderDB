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
      this_choice <- input$radio

      # Get index number and then maps
      len_lst <- length(map_info)
      idx_lst <- 1:len_lst
      lmap_no <- map_info$selection == this_choice
      idx_lst <- idx_lst[lmap_no]
      this_ll_map <- get(map_info$ll_map[[idx_lst]])
      this_os_map <- get(map_info$os_map[[idx_lst]])
      
      #  cat(file=stderr(), "this_map is", class(this_map), "\n")
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