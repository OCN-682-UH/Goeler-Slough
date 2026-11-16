### Week 4 class code, learning data wrangling with dplyr (with Mica!)
### Created by Natalie Goeler-Slough
### Created on 2026-09-15

### loading libraries
library(palmerpenguins)
library(tidyverse)
library(here)

### loading data
#the data is part of the palmerpenguins package and is called penguins
glimpse(penguins)
head(penguins)


### data analysis

#using filter to extract rows -- filtering for only female penguins
filter(.data = penguins, sex == "female")

#penguins measured in the year 2008
filter(.data = penguins, year == "2008")

#penguins that have body mass greater than 5000
filter(.data = penguins, body_mass_g>5000)

#females also greater than 5000
filter(.data = penguins, sex == "female", body_mass_g>5000) #can also use & instead of comma

#penguins in 2008 or 2009
filter(.data = penguins, year == 2008| year == 2009)
filter(.data = penguins, year != 2007) #is not year 2007

#penguins not from island Dream
filter(.data = penguins, island != "Dream")

#penguins in the species Adelie and Gentoo
filter(.data = penguins, species != "Chinstrap") #is not chinstrap species
filter(.data = penguins, species == "Adelie" | species == "Gentoo")

#add column converting body mass in g to kg, and calculate bill lengt/depth
mutate(.data = penguins, body_mass_kg = body_mass_g / 1000,
       bill_length_depth. = bill_length_mm / bill_depth_mm)

#using across to apply across many columns
penguins |> #piping 
  mutate(across(where(is.numeric), #across columns where data are numeric
                ~ round(.x, 1))) #round each value to one decimal point (~ creates a small anonymous function, .x is placeholder for current column)

#mutate to create column to add flipper length and body mass
penguins |>
  mutate(flipper_plus_body = flipper_length_mm + body_mass_g)

#use mutate & if_else to add column where body mass greater than 4000 is labeled big and all else is small
penguins |>
  mutate(chonk = if_else(body_mass_g>4000, "big", "small"))

penguins |>
  filter(sex == "female") |> #only female penguins
  mutate(log_mass = log(body_mass_g)) |> #calculating log of body mass
  select(Species = species, island, sex, log_mass) #selecting specific columns, renaming species as Species w/ capital s

#calculating mean and min flipper length, excluding NAs
penguins |>
  summarise(mean_flipper = mean(flipper_length_mm, na.rm = TRUE),
            min_flipper  = min(flipper_length_mm, na.rm = TRUE))

# calculate the mean, max, and count of bill length by island
penguins |>
  group_by(island) |>
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length  = max(bill_length_mm, na.rm = TRUE),
            n                = n())

#group by both island and sex
penguins |>
  group_by(island, sex) |>
  summarise(mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
            max_bill_length  = max(bill_length_mm, na.rm = TRUE))

#use count to count rows per group
penguins |>
  count(species)

#remove NAs: drop all the rows that are missing data on sex, then calculate mean bill length by island and sex
penguins |>
  drop_na(sex) |>
  ggplot(aes(x = sex, y = flipper_length_mm)) +
  geom_boxplot()

#pipe into ggplot
penguins |>
  drop_na(sex) |>
  ggplot(aes(x = sex, y = flipper_length_mm)) +
  geom_boxplot()
