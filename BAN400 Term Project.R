# Load Packages -----------------------------------------------------------
library(readr)
library(readxl)
library(rjson)
library(dplyr)
library(tidyverse)
library(shiny)
library(shinythemes)
library(COVID19)

# Load Data ---------------------------------------------------------------
data <- covid19()

# Data Wrangling ----------------------------------------------------------



# Define UI ---------------------------------------------------------------
ui <- fluidPage(
     
     # Application title
     titlePanel("Covid"),
     
     # Sidebar with a slider input for number of binds
     sidebarLayout(
          sidebarPanel(
               sliderInput("bins",
                           "Number of bins:",
                           min = 1,
                           max = 50,
                           value = 30)
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
               plotOutput("distPlot")
          )
     )
)    
     
# Define Server Function --------------------------------------------------
server <- function(input, output) {
     
     output$distPlot <- renderPlot({
          # Generate bins based on input$bins from ui.R
          x <- covid19()[,2]
          bins <- seq(min(x),max(x), length.out = input$bins + 1)
          
          # draw the histogram with the specified number of bins
          hist(x, breaks = bins, col = 'darkgray', border = 'white')
     })
}

# Create Shiny Object -----------------------------------------------------
shinyApp(ui = ui, server = server)
