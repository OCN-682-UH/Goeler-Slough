### Week 5 homework code, data wrangling: practicing joins and dates
### Created by Natalie Goeler-Slough
### Created on 2026-09-22

### loading libraries
library(tidyverse)
library(here)
library(scales)
library(viridis)
library(patchwork)


### loading data: conductivity, depth, and data dictionary
CondData <- read_csv(here("Week_5", "Data", "CondData.csv"))
CondData
DepthData <- read_csv(here("Week_5", "Data", "DepthData.csv"))
DepthData
DataDictionary <- read_csv(here("Week_5", "Data", "data_dictionary.csv"))
DataDictionary

### data analysis

#Convert date columns appropriately
#Round the conductivity data to the nearest 10 seconds to match depth data
#Join the two dataframes using inner_join() (only exact matches)
#Calculate averages of date, depth, temperature, and salinity by minute
#Make a plot using the averaged data
#Use pipes throughout (minimize separate dataframes)
#Add comments to your code!

#After preliminary plotting, I saw an outlier -- I looked into raw data and there is one point that has salininty ~5 while neighboring (10 sec before/after) are 33+; I think it's an erroneous outlier 

#plotting salinity across depth; putting depth on y axis to reflect actual depth
salinity_depth_temp <- CondData |>
  mutate(date = mdy_hms(date)) |> #making date into real datetime column
  mutate(date = round_date(date, "10 seconds")) |> #changing to round conductivity data to nearest 10 seconds to match depth data
  inner_join(DepthData) |> #joining conductivity data with depth data (only exact matches)
  filter(Salinity > 30) |> #selecting only salinity values above 30 to get rid of one apparent outlier point w/ salininty <29
  mutate(date_min = round_date(date, "minute")) |> #rounding the date column to nearest minute, as new column 'date_min'
  group_by(date_min) |> #grouping by date_min column
  summarise(mean_depth = mean(Depth, na.rm = TRUE),  #summarizing to get average depth for each minute
            mean_temp = mean(Temperature, na.rm = TRUE), #average temp
            mean_salinity = mean(Salinity, na.rm = TRUE)) |> #average salinity 
  #data in nice summarized and averaged form, now plotting salinity across depth:
  ggplot(aes(x = mean_salinity, y = mean_depth, color = mean_temp))+ #creating plot with salinity over time w/ temp as color
  geom_point()+
  scale_y_reverse() + #inverting y axis to make more sense for depth data (zero at the top)
  scale_color_viridis_c(option = "plasma", name = "Temp (°C)") + #changing to viridis color scale to show temperature clearly
  geom_line()+
  labs(title = "Salinity Across Depth & Temperature", 
       x = "Salinity", y = "Depth (m)",
       caption = "Source: Becker and Silbiger (2020) Journal of Experimental Biology") +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold") #making title bold
  )
print(salinity_depth_temp)
#this is an okay plot, but I'm having a hard time interpreting any patterns; I'm going to try plotting across time instead:

#plotting salinity across time with temperature as color
salinity_time_temp <- CondData |>
  mutate(date = mdy_hms(date)) |> #making date into real datetime column
  mutate(date = round_date(date, "10 seconds")) |> #changing to round conductivity data to nearest 10 seconds to match depth data
  inner_join(DepthData) |> #joining conductivity data with depth data (only exact matches)
  filter(Salinity > 10) |> #selecting only salinity values above 10 to get rid of one apparent outlier point w/ salininty ~5
  mutate(date_min = round_date(date, "minute")) |> #rounding the date column to nearest minute, as new column 'date_min'
  group_by(date_min) |> #grouping by date_min column
  summarise(mean_depth = mean(Depth, na.rm = TRUE),  #summarizing to get average depth for each minute
            mean_temp = mean(Temperature, na.rm = TRUE), #average temp
            mean_salinity = mean(Salinity, na.rm = TRUE)) |> #average salinity 
  ggplot(aes(x = date_min, y = mean_salinity, color = mean_temp))+ #creating plot with salinity over time w/ temp as color
  geom_point()+
  scale_color_viridis_c(option = "plasma", name = "Temp (°C)") + #changing to viridis color scale to show temperature clearly
  geom_line()+
  labs(x = "Time of Day", y = "Salinity") +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold") #making title bold
  )
print(salinity_time_temp)

#plot depth across time, with temp reflected as color
depth_time_temp <- CondData |>
  mutate(date = mdy_hms(date)) |> #making date into real datetime column
  mutate(date = round_date(date, "10 seconds")) |> #changing to round conductivity data to nearest 10 seconds to match depth data
  inner_join(DepthData) |> #joining conductivity data with depth data (only exact matches)
  mutate(date_min = round_date(date, "minute")) |> #rounding the date column to nearest minute, as new column 'date_min'
  group_by(date_min) |> #grouping by date_min column
  summarise(mean_depth = mean(Depth, na.rm = TRUE),  #summarizing to get average depth for each minute
            mean_temp = mean(Temperature, na.rm = TRUE), #average temp
            mean_salinity = mean(Salinity, na.rm = TRUE)) |> #average salinity 
  #data in nice summarized form, now plotting:
  ggplot(aes(x = date_min, y = mean_depth, color = mean_temp))+ #creating plot with salinity over time w/ temp as color
  geom_point()+
  scale_y_reverse() + #inverting y axis to make more sense for depth data (zero at the top)
  scale_color_viridis_c(option = "plasma", name = "Temp (°C)") + #changing to viridis color scale to show temperature clearly
  geom_line()+
  labs(x = "Time of Day", y = "Depth (m)",) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold") #making title bold
  )
print(depth_time_temp)

#using patchwork to put these two plots with salininty & depth across time together in same figure
salinity_time_temp / depth_time_temp + 
  plot_layout(guides = 'collect') + #collecting legends
  plot_annotation(tag_levels = 'A', #adding letter labels to each plot
                  title = "Salinity and Depth across Time and Temperature", #title of whole figure
                  caption = "Source: Becker and Silbiger (2020) Journal of Experimental Biology") #adding source caption
ggsave(here("Week_5", "Output","salinity_depth_plot_HW.png"))
