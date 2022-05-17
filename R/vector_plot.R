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

library(raster)
budle_50m_os  <- readRDS("data/budle_50m.RDS")
budle_75m_os  <- readRDS("data/budle_75m.RDS")
budle_100m_os <- readRDS("data/budle_100m.RDS")
budle_50m_ll  <- projectRaster(budle_50m_os, crs=CRS("+init=epsg:4326"))
budle_75m_ll  <- projectRaster(budle_75m_os, crs=CRS("+init=epsg:4326"))
budle_100m_ll <- projectRaster(budle_100m_os, crs=CRS("+init=epsg:4326"))
crs(budle_50m_ll)  <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
crs(budle_75m_ll)  <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
crs(budle_100m_ll) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


northumbria_twb_os <- readRDS("data/Northumbria_TWB.RDS")
northumbria_swoc_os <- readRDS("data/Northumbria_SWOC.RDS")
northumbria_swmc_os <- readRDS("data/Northumbria_SWMC.RDS")
northumbria_twb_ll <- st_transform(northumbria_twb_os, 4326)
northumbria_swoc_ll <- st_transform(northumbria_swoc_os, 4326)
northumbria_swmc_ll <- st_transform(northumbria_swmc_os, 4326)

vector_df <- data.frame(
  selection = c("Whole area", "IHU areas", "Wader groups", "Wader areas", "Wader region"),
  ll_map    = c("coast_ll", "areas_ll", "wader_groups_ll", "wader_areas_ll", "wader_region_ll"),
  os_map    = c("coast_os", "areas_os", "wader_groups_os", "wader_areas_os", "wader_region_os")
)

budle_df <- data.frame(
  selection = c("50m", "75m", "100m"),
  ll_map    = c("budle_50m_ll", "budle_75m_ll", "budle_100m_ll"),
  os_map    = c("budle_50m_os", "budle_75m_os", "budle_100m_os")
)

budle_list <- list(
  selection = c("50m", "75m", "100m"),
  ll_map    = c(budle_50m_ll, budle_75m_ll, budle_100m_ll),
  os_map    = c(budle_50m_os, budle_75m_os, budle_100m_os)
)


northumbria_wfd_df <- data.frame(
  selection = c("Transitional Water Bodies", "Surface Water Operational Catchments",
                "Surface Water Management Catchments"),
  ll_map    = c("northumbria_twb_ll", "northumbria_swoc_ll", "northumbria_swmc_ll"),
  os_map    = c("northumbria_twb_ll", "northumbria_swoc_ll", "northumbria_swmc_ll")
)

northumbria_wfd_lst <- list(
  "selection" = list("Transitional Water Bodies", "Surface Water Operational Catchments",
                "Surface Water Management Catchments"),
  "ll_map"    = list("Transitional Water Bodies" = northumbria_twb_ll,
                     "Surface Water Operational Catchments" = northumbria_swoc_ll,
                     "Surface Water Management Catchments" =northumbria_swmc_ll),
  "os_map"    = list(northumbria_twb_ll, northumbria_swoc_ll, northumbria_swmc_ll)
)

