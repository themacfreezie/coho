## SET WORKING DIR & PACKAGES

# import packages
# library(car)
# library(cowplot)
# library(data.table)
# library(dplyr)
# library(gghighlight)
# library(ggplot2)
# library(gplots)
# library(ggspatial)
library(here)
# library(lmtest)
# library(MARSS)
# library(marssTMB)
# library(openxlsx)
# library (panelr)
# library(plm)
# library(readxl)
# library(sf)
library(tidyr)
library(tidyverse)
# library(TMB)
# library(tseries)

# set working dir
here::i_am("code/awcLIDAR_area.R")
options(max.print=2000)

# drop extraneous columns for area measurement
z_area <- z[-c(5:16, 18:71, 75:79)]

# cut extraneous characters (8 and 12) out of stream ID strings for matching
z_area$AWC_CODE <- substr(z_area$AWC_CODE, 1, 11)

z_area$AWC_CODEstart <- substr(z_area$AWC_CODE, 1, 7)
z_area$AWC_CODEend <- substr(z_area$AWC_CODE, 9, 11)

z_area$AWC_CODE <- paste(z_area$AWC_CODEstart, z_area$AWC_CODEend, sep="")

z_area <- z_area[-c(10:11)]

# drop observations with no match
z_area <- z_area %>% drop_na(OBJECTID)

# create area variable
z_area$area <- z_area$LENGTH_M*z_area$WIDTH_M

class(z_area)
z_area.df <- as.data.frame(z_area)
class(z_area.df)

# sum stream area by watershed
str_area <- z_area.df %>%
  group_by(AWC_CODE) %>%
  summarize(area = sum(area))

str_area$area_km2 <- str_area$area/1000000
