# Histogram app — finished version of the app we build in lecture
# File name MUST be app.R, and the folder name is the app name.
# Run with shiny::runApp() or the "Run App" button in RStudio.

library(shiny)
library(tidyverse)

ui <- fluidPage(
  sliderInput(inputId = "num", # ID name for the input
              label = "Choose a number", # Label above the input
              value = 25, min = 1, max = 100 # values for the slider
  ),
  textInput(inputId = "title", # new Id is title
            label = "Write a title",
            value = "Histogram of Random Normal Values"), # starting title
  plotOutput("hist"), # creates space for a plot called hist
  verbatimTextOutput("stats") # create a space for stats
)

server <- function(input, output) {

  # reactive: one dataset shared by BOTH outputs (same random numbers,
  # and only regenerated when input$num changes)
  sim_data <- reactive({
    tibble(x = rnorm(input$num)) # number of points set by the slider
  })

  output$hist <- renderPlot({
    ggplot(sim_data(), aes(x = x)) + # make a histogram
      geom_histogram() +
      labs(title = input$title) # add a new title
  })

  output$stats <- renderPrint({
    summary(sim_data()) # calculate summary stats from the SAME data
  })
}

shinyApp(ui = ui, server = server)
