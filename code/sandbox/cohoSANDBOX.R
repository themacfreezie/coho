## SET WORKING DIR & PACKAGES

# import packages
library(here)
library(readxl)
library(tidyverse)

# create working dir and output folder
here::i_am("code/sandbox/cohoSANDBOX.R")
options(max.print=10000)

# pull in data
coho <- read_excel(here("data", "raw", "Surveys - Detailed Surveys_ coho salmon counted in escapement since 1960.xlsx"), col_names = TRUE)

# drop aerial surveys
coho <- coho %>% filter(`Survey Type Name`!="AERIAL")
coho <- coho %>% filter(`Survey Type Name`!="HELICOPTER")

# transform dates
head(coho)
coho$date <- as.Date(coho$Day)
coho$time <- format(as.POSIXct(coho$Day),
                    format = "%H:%M:%S")
class(coho$date)
dates <- data.frame(date = coho$date,
                    year = as.numeric(format(coho$date, format ="%Y")),
                    month = as.numeric(format(coho$date, format ="%m")),
                    day = as.numeric(format(coho$date, format ="%d")))
coho <- coho[-c(20,21)]
coho$year <- dates$year
coho$month <- dates$month
coho$day <- dates$day

# add special designation for january (13)
coho$month[coho$month == 1] <- 13

coho_foot <- coho %>% filter(`Survey Type Name`=="FOOT")
