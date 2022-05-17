# Shiny module for map display and data download. As this is likely to be a
# common pattern for many datasets, might be simplest as a module

display_mapUI <- function(id, heading, description, map_info){
# display_mapUI <- function(id){
    tagList(
      h2(heading),
      p(description),
      radioButtons(NS(id, "radio"), "Select dataset", choices = map_info$selection),
      leafletOutput(NS(id, "leaflet_map")),
      p("download data")
    )
}

display_mapServer <- function(id, map_info, map_to_plot){
  moduleServer(id, function(input, output, session){
    # this_choice <- reactive(filter(map_info, input$radio == selection))
    # map_to_plot <- reactive(get(this_choice[1,"ll_map"]))
observeEvent(input$radio, {
    #this_choice <- filter(map_info, input$radio == selection)
this_choice <- input$radio
    cat(file=stderr(), "this_choice is", class(this_choice), "\n")
#this_map <- get(map_info$ll_map[[1]])
#this_map <- get(map_info$ll_map[[as.character("Surface Water Operational Catchments")]])

    len_lst <- length(map_info)
    idx_lst <- 1:len_lst
    lmap_no <- map_info$selection == this_choice
    idx_lst <- idx_lst[lmap_no]
    this_map <- get(map_info$ll_map[[idx_lst]])
    
    
    cat(file=stderr(), "this_map is", class(this_map), "\n")
    #cat(file=stderr(), "map_to_plot is", class(map_to_plot), "\n")
    # output$leaflet_map <- renderLeaflet({
    output$leaflet_map <- renderLeaflet({
        leaflet() %>% 
        addTiles() %>%
        addProviderTiles(providers$Esri.WorldImagery,
                         options = providerTileOptions(noWrap = TRUE)
        )  %>%
        addFeatures(this_map)
        #addFeatures(get(this_choice[1,"ll_map"]))
    })
    # data <- reactive(mtcars[[input$var]])
    # output$silly_plot <- renderPlot({
    #   hist(data(), breaks = input$bins, main = input$var)
    # }, res = 96)
    # output$download_vect <- downloadHandler(
    #   filename = function() {
    #     paste0(input$download_vect, ".RDS")
    #   },
    #   content = function(file) {
    #     saveRDS(get(this_choice[1, "os_map"]), file)
    #   })
})    
  })
}