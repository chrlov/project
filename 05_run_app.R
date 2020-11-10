#### Packages ----------------------------------------------------------------
library(tidyverse)
library(shiny)
library(leaflet)

#### Connect R scripts -------------------------------------------------------



#### App ---------------------------------------------------------------------
runApp(shinyApp(ui     = ui, 
                server = server), 
       launch.browser  = T)
