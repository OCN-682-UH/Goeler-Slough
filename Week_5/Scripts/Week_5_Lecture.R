### MBIO612 Week 5 lecture code, learning advanced plotting
### Created by Natalie Goeler-Slough
### Created on 2026-09-24

### loading libraries
library(tidyverse)
library(here)
library(palmerpenguins)
library(patchwork)
library(ggrepel)
library(gganimate)
library(gifski)
library(plotly)
library(magick)

### data analysis
#making first plot, using palmerpenguins data
p1 <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_length_mm, 
             color = species)) +
  geom_point()
p1

#making second plot
p2 <- penguins |>
  ggplot(aes(x = sex, 
             y = body_mass_g, 
             color = species)) +
  geom_jitter(width = 0.2)
p2

#combining plots (patchwork)
p1 + p2 +
  plot_layout(guides = 'collect') + #collecting legends
  plot_annotation(tag_levels = 'A') #labeling plots, uppercase A = uppercase labels

p1 / p2 + #stacks plots vertically with /
  plot_layout(guides = 'collect') + #collecting legends
  plot_annotation(tag_levels = 'A') #labeling plots, uppercase A = uppercase labels


#plotting w/ label repelling (ggrepel)
#using mtcars dataset
head(mtcars)

#plot without label repelling
ggplot(mtcars, aes(x = wt, 
                  y = mpg,
                  label = rownames(mtcars))) +
geom_text() +
  geom_point(color = "red")

#plot with text repelling 
ggplot(mtcars, aes(x = wt, 
                   y = mpg,
                   label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = "red")

#plot with label repelling (has box around label)
ggplot(mtcars, aes(x = wt, 
                   y = mpg,
                   label = rownames(mtcars))) +
  geom_label_repel() +
  geom_point(color = "red")


#animating plots (gganimate)
p <- penguins |>
  ggplot(aes(x = body_mass_g,
             y = bill_depth_mm,
             color = species))+
  geom_point() +
  transition_states(
    year, #transitioning by year
    transition_length = 2, #length of transition (2 seconds)
    state_length = 1) + #state length (how long it stays in each transition)
  labs(title = 'Year: {closest_state}')  #changes title to be which year you're in
  
anim_save(here("Week_5", "Output", "penguin_animation.gif"), animation = p) #saving animation as gif


#interactive plots (plotly)
penguins |>
  plot_ly(x = ~body_mass_g, #need to add tildes for data going into plot
          y = ~bill_depth_mm,
          color = ~species,
          type = "scatter", #type of plot = scatterplot
          mode = "markers") |> #how to be able to interact with plot; hover marker over to see data for individual points
  layout(title = "Penguin Body Mass vs Bill Depth",
         xaxis = list(title = "Body Mass (g)"),
         yaxis = list(title = "Bill Depth (mm)"))

#animating by species with frame
penguins |>
  plot_ly(x = ~body_mass_g, #need to add tildes for data going into plot
          y = ~bill_depth_mm,
          frame = ~species, #animating by species with frame
          color = ~species,
          type = "scatter", #type of plot = scatterplot
          mode = "markers", #how to be able to interact with plot; hover marker over to see data for individual points
          marker = list(size = 8)) |> #changing marker size
  layout(title = "Penguin Body Mass vs Bill Depth",
         xaxis = list(title = "Body Mass (g)"),
         yaxis = list(title = "Bill Depth (mm)"))


#advanced image processing (magick):
silly_penguin <- image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")
silly_penguin

#making basic penguin plot
penguinplot <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() 
ggsave(here("Week_5", "Output", "penguinplot.png")) #save plot as png, to be able to make composite
penguinplot

penplot <- image_read(here("Week_5", "Output", "penguinplot.png")) #reading in basic penguin plot from output folder
out <- image_composite(image = penplot, #background image = basic penguin plot
                       composite_image = silly_penguin, #overlay image = silly penguin photo from online
                       offset = "+70+30") #changing offset to be in top 70% and left 30%
out

#doing the same thing, now with a penguin gif
pengif <- image_read("https://media3.giphy.com/media/H4uE6w9G1uK4M/giphy.gif") #reading in gif
outgif <- image_composite(penplot, pengif, gravity = "center") #overlaying gif on plot, gravity making it in the center of plot
penanimation <- image_animate(outgif, fps = 10, optimize = TRUE) #saving animation of gif on top of plot
penanimation
anim_save(here("Week_5", "Output", "penguin_gif_plot.gif"), animation = penanimation) #saving plot to output folder
