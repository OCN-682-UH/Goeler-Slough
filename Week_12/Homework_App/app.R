### Natalie Goeler-Slough
### OCN 682 
### Week 12 Homework: Shiny App
### November 16, 2026


## Homework assignment: 
# "Use any data set to make a shiny app. Your app must have at least one dynamic figure and one other output (can be anything).
# You must publish it on Posit Connect Cloud so that we can view your app online. Put the link in your ReadMe file so that we can easily find and click on it. 
# 3 points for 1 dynamic figure, 
# 3 points for an additional dynamic output, 
# 2 points for following appropriate coding style/commenting
# 1 points for creativity (no more exactly the same boxplot over and over)
# 1 point proper file structure"

# My plan for this app is to expand on my functions homework with coralnet benthic data (from my herbivory project):
# I want to make an app where a user can select a specific date or specific site and see a stacked barplot of benthic composition per quadrat (OR averaged across all quadrats per site/date if I have time to get fancy)
# Then for my second dynamic output I want to make a table summarizing the benthic composition (by % cover), with a row adding up total grazeable substrate


### Loading libraries:
library(shiny)
library(tidyverse)
library(shinyWidgets)


### Loading data:
coralnet <- read_csv("data/annotations.csv")
labelset <- read_csv("data/CoralNet_Labelset.csv")


#codes from labelset to exclude (not included in benthic cover %)
exclude_codes <- c("OOQ", "PVC", "UNK", "MOBL")

#defining codes that count as "grazeable substrate"
grazeable_codes <- c("TURF_H", "TURF_R", "TURF_S", "MAL", "MA_EN", "Stubby", "CCA_H", "CCA_R", "CCAG")

#setting up benthic palette:
benthic_pal <- c(
  "Coral" = "#C0504D",
  "CCA" = "#F4C2C2",
  "Macroalgae" = "#0F3800",
  "Turf" = "#16A34A",
  "Sand" = "#E8D8B0",
  "Urchin" = "#5E50A1",
  "Other Invertebrates" = "#0096C7",
  "Cyanobacteria" = "#5C1A48"
)

#pre-filtering/cleaning data
benthic_clean <- coralnet |>
  mutate(Date = as.Date(Date)) |> #making sure date column is as a date
  rename(Label.code = "Label code") |>
  rename(GoPro.ID = "GoPro ID") |>
  mutate(Site = str_squish(str_replace_all(Site, "[._]", " "))) |> #changing names to match user dropdown below
  left_join(labelset, by = "Label.code") |> #adding labelset to coralnet data
  filter(!Label.code %in% exclude_codes) #excluding codes not included in benthic cover


#setting up site and date choices for user, based on options available in dataset
site_choices <- sort(unique(benthic_clean$Site))
date_choices <- sort(unique(benthic_clean$Date))
date_choices <- setNames(
  as.character(date_choices),
  format(date_choices, "%b %d, %Y")   #changing date formatting so it's nicer for the label the user sees
)


### Setting up UI:
ui <- fluidPage(
  titlePanel("Benthic Composition Explorer"), #setting up title for app page
  #selecting date(s)
  pickerInput(
    inputId = "date",
    label = "Select Date(s):",
    choices = date_choices,
    selected = NULL,   #nothing selected = defaults to all dates
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE, size = 10,
      selectedTextFormat = "count > 2",
      noneSelectedText = "All dates"
    )
  ),
  #selecting site(s)
  pickerInput(
    inputId = "site", 
    label = "Select Site(s):", 
    choices = site_choices,
    selected = site_choices,
    options = pickerOptions(
      actionsBox = TRUE, 
      size = 10,
      selectedTextFormat = "count > 3"
      ), 
    multiple = TRUE
    ),
  #option to select individual quadrats or summarized site/date
  radioGroupButtons(
    inputId = "view",
    label = "View:",
    choices = c("Site/date summary" = "summary",
                "Individual quadrats" = "quadrat"),
    selected = "summary",   #default selection = summary
    direction = "horizontal",   #horizontal switch
    justified = FALSE   #doesn't take up entire width
  ),
  plotOutput("bar", height = "950px"), #making plot output quite tall so plots don't get squished
  tableOutput("table")  #adding space for table output
  )


### Setting up server:
server <- function(input,output){
  #setting up reactive data that filters by user inputted sites / dates 
  filtered_data <- reactive({
    req(input$site)
    df <- benthic_clean |> filter(Site %in% input$site)
    if (length(input$date) > 0) {
      df <- df |> filter(Date %in% as.Date(input$date))
    }
    validate(need(nrow(df) > 0, "No survey data found for this site/date combination."))
    df
  })
  #calculating benthic cover, by quadrat
  quadrat_cover <- reactive({
    filtered_data() |>
      filter(Subcategory %in% names(benthic_pal)) |> #making sure only subcategories from benthic palette are included
      group_by(Name) |> 
      mutate(Total.points = n()) |> #calculating total points per quadrat
      group_by(Name, Date, Site, GoPro.ID, Subcategory, Total.points) |>
      summarise(Point.count = n(), .groups = "drop") |>
      mutate(Percent.cover = (Point.count / Total.points) * 100) |> #calculating % cover per quadrat
      complete(
        nesting(Name, Date, Site, GoPro.ID),
        Subcategory = names(benthic_pal),
        fill = list(Point.count = 0, Percent.cover = 0)
      ) |>
      mutate(Subcategory = factor(Subcategory, levels = names(benthic_pal)))
  })
  #calculations for summarized cover (if selected summary version vs individual quadrats)
  summary_cover <- reactive({
    quadrat_cover() |>
      filter(Subcategory %in% names(benthic_pal)) |> #making sure only subcategories from benthic palette are included
      group_by(Site, Date, Subcategory) |>
      summarise(Mean.cover = mean(Percent.cover), #calculating summarized % cover (averaged across quadrats)
                n.quadrats = n_distinct(Name),
                .groups = "drop")
  })
  #now making stacked barplot 
  output$bar <- renderPlot({
   plot <- if (input$view == "quadrat") { #if selected per quadrat
      ggplot(quadrat_cover(),
             aes(x = GoPro.ID, y = Percent.cover, fill = Subcategory)) +
        geom_col() +
        scale_fill_manual(values = benthic_pal, drop = FALSE) +
        facet_wrap(~ Site + Date, ncol = 2, scales = "free_x") +
        labs(x = "Quadrat", y = "Percent Cover (%)",
             fill = "Benthic Category",
             title = "Benthic Cover by Quadrat")
    } else {  #if selected summary option
      ggplot(summary_cover(),
             aes(x = factor(Date), y = Mean.cover, fill = Subcategory)) +
        geom_col() +
        scale_fill_manual(values = benthic_pal, drop = FALSE) +
        facet_wrap(~ Site, ncol = 2, scales = "free_x") +
        labs(x = "Survey Date", y = "Mean Percent Cover (%)",
             fill = "Benthic Category",
             title = "Mean Benthic Cover per Site/Date")
    } 
   plot +
      theme_minimal(base_size = 18) +
      theme( #customizing theme / text for plots (mostly making text larger + more legible)
        axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text = element_text(size = 16, face = "bold"),
        plot.title = element_text(size = 22, face = "bold"),
        legend.position = "right",
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 15)
      )
  })
  output$table <- renderTable({
    if (input$view == "quadrat") {
      quadrat_cover() |> #taking quadrat cover values from calculations above
        transmute(Site, Date = as.character(Date), Quadrat = GoPro.ID, #fixing labels/column names for table
                  Subcategory, Percent.cover = round(Percent.cover, 1)) |>
        pivot_wider(names_from = Subcategory, values_from = Percent.cover) |>
        arrange(Site, Date, Quadrat)
    } else {
      summary_cover() |> #taking summary values from cover calculations above
        transmute(Site, Date = as.character(Date),
                  Subcategory, Mean.cover = round(Mean.cover, 1)) |>
        pivot_wider(names_from = Subcategory, values_from = Mean.cover) |>
        arrange(Site, Date)
    }
  }, digits = 1)
  
}

### Go app go !!
shinyApp(ui = ui, server=server)

