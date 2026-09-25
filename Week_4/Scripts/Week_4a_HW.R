### Week 4 homework a code, using dplyr for data wrangling / plotting
### Created by Natalie Goeler-Slough
### Created on 2026-09-15

### loading libraries
library(palmerpenguins)
library(tidyverse)
library(here)
library(ggridges)

### loading data
#the data is part of the palmerpenguins package and is called penguins
glimpse(penguins)

### data analysis

#part 1: calculate mean and variance of body mass by species, island, and sex without any NAs
p1_penguins <- penguins |>
  drop_na(sex) |>  #dropping all NAs from sex column
  group_by(species, island, sex) |>  #grouping by species, island, and sex
  summarise(mean_body_mass = mean(body_mass_g, na.rm = TRUE),  #calculating mean body mass for each group, without NAs
            variance_body_mass = var(body_mass_g, na.rm = TRUE),  #calculating variance of body mass for each group, without NAs
            n = n())  #also looking at the number of values (sample size) for each group
p1_penguins


#part 2: filters out (i.e. excludes) male penguins, then calculates the log body mass, then selects only the columns for species, island, sex, and log body mass, then use these data to make any plot

#using dplyr and piping to do the above, making a ridgeline plot of log body mass across species
p2_penguins <- penguins |>
  filter(sex != "male") |>  #excluding males
  mutate(log_body_mass = log(body_mass_g)) |>  #log body mass
  select(species, island, sex, log_body_mass) |> #selecting those columns
  ggplot(aes(x = log_body_mass, y = species, fill = species)) +
  geom_density_ridges(scale=1.6)+ #making ridgeline plot, scale is changing the amount of overlap
  theme_bw()+
  scale_y_discrete(
    expand = expansion(add = c(0.1, 1.65)))+ #shifting y axis to make less room at the bottom and more at the top
  labs(title = "Penguin Body Mass by Species",  #adding a plot title
       y = "Species", 
       x = expression(log[10]("Body Mass [g]")),   #adding x and y axis labels, using expression to label log base 10
       subtitle = "For female penguins from Torgersen, Dream, and Biscoe islands",
       fill = "Species",
       caption = "Source: Palmer Station LTER")

p2_penguins 

ggsave(here("Week_4", "Output", "hw4a_penguin_plot.png"))
