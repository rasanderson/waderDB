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

wader_areas_os <- readRDS("data/wader_areas.RDS")
wader_areas_ll <- st_transform(wader_areas_os, 4326)