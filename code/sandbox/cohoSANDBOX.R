## SET WORKING DIR & PACKAGES

# import packages
library(here)
library(readxl)

# create working dir and output folder
here::i_am("code/sandbox/cohoSANDBOX.R")
options(max.print=10000)

# pull in data
coho <- read_excel(here("data", "raw", "Surveys - Detailed Surveys_ coho salmon counted in escapement since 1960.xlsx"), col_names = TRUE)