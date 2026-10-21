# Sea star counts app — finished version of the app we build in lecture
# Uses selectInput() + filter() on the stars.csv data.
#
# File name should end in .R and live in the same folder as the data
# (Week_12/). For your own apps, name the file app.R inside a folder
# named after your app.
#
# Run with shiny::runApp() or the "Run App" button in RStudio.

library(shiny)
library(tidyverse)

stars <- read_csv("data/stars.csv")

ui <- fluidPage(
  selectInput(inputId = "min_stars", # ID name for the input
              label = "Show sites with at least this many sea stars:",
              choices = c(1, 5, 10, 20), # threshold options
              selected = 5 # the threshold that shows first
              ),
  plotOutput("star_map") # creates space for the map
)

server <- function(input, output) {

  # reactive: re-filters the sites every time the threshold changes
  kept_sites <- reactive({
    stars |>
      # selectInput returns choices as STRINGS, so convert back to
      # numeric -- otherwise R compares "10" >= "5" lexically and drops
      # 10, 25, 35 from the map!
      filter(star_no >= as.numeric(input$min_stars))
  })

  output$star_map <- renderPlot({
    ggplot(kept_sites(), aes(x = long, y = lat)) +
      geom_point(aes(size = star_no), color = "red") + # points sized by count
      labs(size = "Sea stars counted",
           x = "Longitude", y = "Latitude")
  })
}

shinyApp(ui = ui, server = server)
