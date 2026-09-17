### Week 4 lecture code, using tidyr for data wrangling / plotting
### Created by Natalie Goeler-Slough
### Created on 2026-09-17

### loading libraries
library(tidyverse)
library(here)
library(cowsay)

### loading data
ChemData <- read_csv(here("Week_4", "Data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)

### data analysis

#dropping all rows that aren't complete
ChemData_clean <- ChemData |>
  filter(complete.cases(ChemData))

#need to separate Tide_time column into tide and time, practice bringing site and zone together into one column
ChemData_clean <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |> #keeps original column (default is delete)
  mutate(Site_Zone = paste(Site, Zone, sep = "."))
ChemData_clean

#pivoting a wide dataset (ex. this one) to long data
ChemData_long <- ChemData_clean |>
  pivot_longer(cols = Temp_in:percent_sgd,
             names_to = "Variables",
             values_to = "Values")
ChemData_long

#calculating mean and variance for all variables at each site
ChemData_long |>
  group_by(Variables, Site) |>
  summarise(Param_means = mean(Values, na.rm = TRUE),
            Param_vars = var(Values, na.rm = TRUE))

#now using long data to calculate mean, variance, and standard deviation for all variables by site, zone, and tide
ChemData_long |>
  group_by(Variables, Site, Zone, Tide) |>
  summarise(Param_means = mean(Values, na.rm = TRUE),
            Param_vars = var(Values, na.rm = TRUE),
            Param_stdevs = sd(Values, na.rm = TRUE))

#example using facet_wrap with long data
ChemData_long |>
  ggplot(aes(x = Site, y = Values))+
  geom_boxplot()+
  facet_wrap(~Variables, scales = "free") #scales = free releases both x and y axes so that specific to each

#make long data back to wide
ChemData_wide <- ChemData_long |>
  pivot_wider(names_from = Variables,
              values_from = Values)
ChemData_wide

#full pipeline, summary statistics to export
ChemData_clean <- ChemData |>
  drop_na() |>
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |>
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Variables", 
               values_to = "Values") |>
  group_by(Variables, Site, Time) |>
  summarise(mean_vals = mean(Values, na.rm = TRUE)) |>
  pivot_wider(names_from = Variables,
              values_from = mean_vals) |>
  write_csv(here("Week_4", "Output", "summary.csv"))
ChemData_clean

#using cowsay package!
say("Yay we made it!", by = "blowfish")
