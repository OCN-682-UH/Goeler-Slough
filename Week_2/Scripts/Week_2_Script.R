### First script for MBIO612 course 
### Created by Natalie Goeler-Slough 
### Created on 09-06-2026 
########################################

#loading libraries
library(here)
library(tidyverse)

#reading in data
weightdata <- read_csv(here("Week_2", "Data", "weightdata.csv"))

#data analysis
head(weightdata) #looking at top 6 rows of weight dataframe (df)
tail(weightdata) #looking at bottom 6 rows of df
view(weightdata) #viewing entire df
