### Week 3 script for MBIO612 course, focus on learning plotting; with class + video lecture + homework
### Created by Natalie Goeler-Slough 
### Created on 09-14-2026 
########################################

### loading libraries ###
library(palmerpenguins)
library(tidyverse)
library(here)
library(colorBlindness)
library(beyonce)
library(ggplot2)
library(ggridges)
library(ggfoundry)

### data loaded from palmerpenguins package ###
glimpse(penguins) #looking at data


### data analysis ###

### class 2026-09-08 scripting:
#class plot of penguins data, plotting bill depth + length, colored by species, with descriptive labels 
ggplot(data=penguins,  #using penguins data for plot
       mapping = aes(x = bill_depth_mm,  #x axis is bill_depth
                     y = bill_length_mm,  #y axis is bill length
                     color = species)) +  #making each species a different color
  geom_point()+ #adding data visualization, using a point
  labs(title = "Bill depth and length",  #adding a plot title
       subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",  #adding plot subtitle
       x = "Bill depth (mm)", y = "Bill length. (mm)",   #adding x and y axis labels
       color = "Species",  #renaming legend title
       caption = "Source: Palmer Station LTER / palmerpenguins package")+  #adding caption with data source
  scale_color_viridis_d() #changing to color scale that's color blind friendly


### lecture video ("Plotting 2") scripting:
#lecture plot of penguin data
lectureplot <- ggplot(data=penguins,  #using penguins data for plot
       mapping = aes(x = bill_depth_mm,  
                     y = bill_length_mm,
                     group = species, #grouping data by species
                     color = species)) +  #will choose a. different color for each species
  geom_point()+ 
  geom_smooth(method = "lm")+
  labs(x = "Bill depth (mm)", y = "Bill length. (mm)")+
  #scale_color_viridis_d()+
  scale_x_continuous(breaks = c(14,17,20)) #changing x breaks
  scale_color_manual(values = c("turquoise", "purple", "magenta"))
  
#checking if plot is color friendly
cvdPlot(lectureplot)

#now using beyonce color palette on plot, changing the theme, and customizing labels
beyonceplot <- ggplot(data=penguins,  #using penguins data for plot
                      mapping = aes(x = bill_depth_mm,  
                                    y = bill_length_mm,
                                    group = species, #grouping data by species
                                    color = species)) +  #will choose a. different color for each species
  geom_point()+ 
  geom_smooth(method = "lm")+
  labs(title = "Penguin Bills (Beyonce Edition)",
    x = "Bill depth (mm)", y = "Bill length (mm)")+
  scale_x_continuous(breaks = c(14,17,20))+ #changing x breaks
  scale_color_manual(values = beyonce_palette(101))+ #using beyonce color palette
  theme_bw()+
  theme(axis.title = element_text(size = 19, #changing axis label font size
                                  color = "purple"),   #changing axis label color
        plot.title = element_text(face = "bold", #making plot title bold
                                  size = 23, #changing plot title font size
                                  color = "purple"),   #changing plot title color
        panel.background = element_rect(fill="lightblue"),
        legend.justification = c("right", "bottom"),
        legend.box.background = element_rect(color = "purple", linewidth = 2),
        legend.background = element_rect(fill = "white"))
beyonceplot

ggsave(here("Week_3", "Output", "sillypenguin.png"),
       width = 7, height = 5) #playing around with height and width to save

#practicing transforming coordinates on diamonds data
ggplot(diamonds, aes(carat,price))+
  geom_point()+
  coord_trans(x = "log10", y = "log10")


### homework due 2026-09-15: come up with plot of penguin data in 1 hour

penguins_clean <- penguins %>% drop_na #dropping NA values from dataset

#first take, trying a ridgeline plot  
ridgelineplot <-  ggplot(data = penguins_clean,
       mapping = aes(x = body_mass_g / 1000, #divided mass by 1000 so it's in kg instead of g
                     y = species,
                     fill = species))+ 
  geom_density_ridges(scale=1.4)+ #scale changes the overlap; making them overlap less
  facet_wrap(~sex)+ #facet wrapping so that there's one plot for male and one for female
  scale_y_discrete(
    expand = expansion(add = c(0.1, 1.45)))+ #shifting y axis to make less room at the bottom and more at the top
  theme_bw()+ #changing to bw theme
  labs(title = "Penguin Body Mass by Species and Sex",
       x = "Body Mass (kg)", #in kg instead of g because I divided by 1000
       y = "Scaled Density (by Species)",
       #subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",  #adding plot subtitle
       fill = "Species",
       caption = "Source: Palmer Station LTER") #adding source caption
ridgelineplot
  
#I want to make it so that you could still see entire data (both M+F) in background in grey -- couldn't figure out in ridges so doing normal density plot
penguinplot_hw <- ggplot(data = penguins_clean,
       mapping = aes(x = body_mass_g / 1000, #divided mass by 1000 so it's in kg instead of g
                     y = species))+ 
#plotting background of grey shape with aggregate data
  geom_density(
    data = select(penguins_clean, -sex),
    aes(y = after_stat(count)), #scales density height proportionally to the # of observations in dataset
    fill = "lightgrey", #making a light grey background of entire data
    color = NA, #getting rid of black outlines around shape
    alpha = 0.6)+ #making this background shape more transparent
#now plotting each male + female count on top of grey background aggregate
  geom_density(
    aes(fill = species, y = after_stat(count)),
    alpha = 0.8
  )+
  facet_grid(species ~ sex)+ #facet gridding so that there's separate plots for each species + each sex
  scale_y_discrete(
    expand = expansion(add = c(0.1, 1.45)))+ #shifting y axis to make less room at the bottom and more at the top
  theme_bw()+ #changing to bw theme
  labs(title = "Penguin Body Mass by Species and Sex",
       x = "Body Mass (kg)", #in kg instead of g because I divided by 1000
       y = "Scaled Density (by Species)",
       fill = "Species",
       caption = "Source: Palmer Station LTER") #adding source caption
penguinplot_hw
ggsave(here("Week_3", "Output", "penguin_plot_hw.png"))

#there are still lots of things I would change about this plot, but didn't want to take more than an hour so I'll have to call it here :/
