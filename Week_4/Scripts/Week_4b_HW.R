### Week 4 homework b code, using tidyr for data wrangling / plotting
### Created by Natalie Goeler-Slough
### Created on 2026-09-17

### loading libraries
library(tidyverse)
library(here)
library(viridis)


### loadviridisLite### loading data
ChemData <- read_csv(here("Week_4", "Data", "chemicaldata_maunalua.csv"))
glimpse(ChemData)
ChemDataDictionary <- read.csv(here("Week_4", "Data", "chem_data_dictionary.csv"))
ChemDataDictionary

### data analysis

#need to remove NAs, separate tide_time column, filter subset of data, use pivot, calculate + export summary stats, make + export plot

#data wrangling, turning into long data
ChemData_clean_long <- ChemData |>
  drop_na() |> #removing NAs
  separate_wider_delim(cols = Tide_time, #separating tide_time column
                       delim = "_",
                       names = c("Tide", "Time"),
                       cols_remove = FALSE) |> #keeps original column
  filter(Season == "SPRING") |> #filtering to only include samples collected in Spring
  pivot_longer(cols = Temp_in:percent_sgd, #pivoting to long data instead of wide
               names_to = "Variable",
               values_to = "Value")


#now using cleaned + long data to calculate and export summary statistics
ChemData_summary <- ChemData_clean_long |>
  group_by(Variable, Site, Zone) |>
  summarise(mean = mean(Value, na.rm = TRUE),
            stdev = sd(Value, na.rm = TRUE),
            variance = var(Value, na.rm = TRUE)) |>
  write_csv(here("Week_4", "Output", "hw4b_summary.csv")) 
  

#using cleaned + long data to make a violin plot of parameters across each zone
ChemData_violin <- ChemData_clean_long |>
  ggplot(aes(y = Value, x = Zone))+
  geom_jitter(aes(color=Zone), #jittering points for each zone
              width = .25,
              alpha = .65,
              size = 1)+
  scale_color_viridis_d()+ #changing to viridis color scale
  geom_violin(alpha = .1, #adding violin on top
              scale = "width")+ #making violins across panels to be the same width vs. default of same area
  facet_wrap(~Variable, scale = "free",
             labeller = as_labeller(c( #renaming titles of faceted plots to include units (couldn't figure out how to put on y-axis without downloading another package)
               "NN" = "Nitrate + Nitrite (umol/L)", 
               "percent_sgd" = "Percent SGD (%)",
               "Phosphate" = "Phosphate (umol/L)",
               "Silicate" = "Silicate (umol/L)",
               "pH" = "pH",
               "Salinity" = "Salinity (ppm)",
               "TA" = "Total Alkalinity (umol/Kg)",
               "Temp_in" = "Temperature (C)")))+
  theme_bw()+
  labs(title = "Water Biogeochemical Parameters by Zone",
       x = NULL, y = NULL,
       caption = "Source: Silbiger et al. 2020 Proceedings of the Royal Society: B")+
  theme(axis.text.x = element_text(size =7), #making x axis labels smaller to fit
        legend.position = "none") #getting rid of legend because already labeled on x axes

ChemData_violin

ggsave(here("Week_4", "Output", "hw4b_biogeochemistry_plot.png"))
