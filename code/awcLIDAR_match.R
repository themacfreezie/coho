## SET WORKING DIR & PACKAGES

# import packages
# library(car)
# library(cowplot)
# library(data.table)
# library(dplyr)
# library(gghighlight)
# library(ggplot2)
# library(gplots)
library(ggspatial)
library(here)
# library(lmtest)
# library(MARSS)
# library(marssTMB)
# library(openxlsx)
# library (panelr)
# library(plm)
# library(readxl)
library(sf)
# library(tidyverse)
# library(TMB)
# library(tseries)

# set working dir
here::i_am("code/awcLIDAR_match.R")
options(max.print=2000)

# pull in data
awc <- read_sf(
  here("data", "awc_streams.shp")
  )
class(awc)

lidar <- read_sf(
  here("data", "hnLIDAR", "reach_hnh.shp")
  )
class(lidar)
st_bbox(lidar)

# check crs
st_crs(awc)
st_crs(lidar)

# transform crs to match
awc <- st_transform(awc, crs = 3338) 
lidar <- st_transform(lidar, crs = 3338)
  # recommended coordinate reference system for alaska

# quick plot
ggplot() +
  geom_sf(data = awc) +
  geom_sf(data = lidar, color = "red")

# crop awc to match lidar
st_bbox(lidar)
awc_crop <- st_crop(
  awc,
  xmin = 1054642, ymin = 1029573,
  xmax = 1106227, ymax = 1062029
)

# quick plot - cropped
ggplot() +
  geom_sf(data = awc_crop) +
  geom_sf(data = lidar, color = "red")

# # check how many LIDAR stream segments within given distances of awc streams
# sel50 <- st_is_within_distance(lidar, awc_crop, dist = 50)
# summary(lengths(sel50) > 0)
#   # 3168 LIDAR segments w/in 50m of AWC streams
# 
# sel25 <- st_is_within_distance(lidar, awc_crop, dist = 25)
# summary(lengths(sel25) > 0)
#   # 2815 LIDAR segments w/in 25m of AWC streams
# 
# sel10 <- st_is_within_distance(lidar, awc_crop, dist = 10)
# summary(lengths(sel10) > 0)
#   # 2378 LIDAR segments w/in 10m of AWC streams

# quick plot - cropped
ggplot() +
  geom_sf(data = awc_crop) +
  ggspatial::annotation_scale()
  # it doesn't look like many streams are within 50m of a separate distinct system
  # overlap is likely due to the same LIDAR segment near multiple awc segments of the same watershed
  # this should get condensed out later and so will be ignored for now..
  # therefore, dist = 50 will be used for join

z <- st_join(lidar, awc_crop, st_is_within_distance, dist = 50)
