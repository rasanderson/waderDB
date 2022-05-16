library(sf)
library(leaflet)
library(leafem)
library(leaflet.providers)
library(dplyr)

coast_os <- readRDS("data/coast.RDS")
coast_ll <- st_transform(coast_os, 4326)
coast_ll <- dplyr::mutate(coast_ll, label = "Wader study region")

areas_os <- readRDS("data/ihu_areas.RDS")
areas_ll <- st_transform(areas_os, 4326)

wader_groups_os <- readRDS("data/wader_groups.RDS")
wader_groups_ll <- st_transform(wader_groups_os, 4326)

wader_areas_os <- readRDS("data/wader_areas.RDS")
wader_areas_ll <- st_transform(wader_areas_os, 4326)

wader_region_os <- readRDS("data/wader_region.RDS")
wader_region_ll <- st_transform(wader_region_os, 4326)



vector_df <- data.frame(
  selection = c("Whole area", "IHU areas", "Wader groups", "Wader areas", "Wader region"),
  ll_map    = c("coast_ll", "areas_ll", "wader_groups_ll", "wader_areas_ll", "wader_region_ll"),
  os_map    = c("coast_os", "areas_os", "wader_groups_os", "wader_areas_os", "wader_region_os")
)
