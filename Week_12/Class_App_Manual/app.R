### Natalie Goeler-Slough
### OCN 682 
### Week 12 Class: Shiny Apps
### November 10, 2026

## loading libraries
library(shiny)
library(tidyverse)
library(here)

## loading data
stars <- read_csv(here("Week_12","Class_App_Manual", "data", "stars.csv"))
glimpse(stars)

# setting up user interface (building around inputs and outputs)
ui <- fluidPage( #fluid page = make webpage
  sliderInput(inputId = "num", # ID name for the input; keep simple -- will use a lot
              label = "Choose a number!", # Label above the input (slider bar)
              value = 44, min = 1, max = 100 # values for the slider; value = start, min/max = min and max values possible
  ),
  textInput(inputId = "title", #adding a second input; new Id is title
            label = "Write a title", #text label 
            value = "Histogram of Random Normal Values"), #starting title
  plotOutput("hist"), #creates empty space for a plot called "hist" (histogram)
  verbatimTextOutput("stats") #creates space for stats data table
)

## setting up server (mostly R code; the meat of the app lives here)
server <- function(input, output){
  
  data <- reactive({
    tibble(x = rnorm(input$num))
  }) #number of points, as set by the slider above (inputId)
  
  output$hist <- #code to create/save objects to display to output (name "hist" has to match exactly to plotOutput())
    renderPlot({  #build objects to display with render
      ggplot(data(), aes(x=x)) + #make a basic historgram
        geom_histogram() +
        labs(title = input$title) # adding new title, that user sets (from textInput)
      })
  
  output$stats <-
    renderPrint({
      summary(data()) #calculate summary stats based on numbers
    })
  
}


shinyApp(ui = ui, server = server)

