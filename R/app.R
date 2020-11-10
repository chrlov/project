#### Packages ----------------------------------------------------------------
library(tidyverse)
library(shiny)
library(leaflet)
library(selectr) # for deployment to shinyapps.io
library(rsconnect) # for deployment to shinyapps.io

#### Connect R scripts -------------------------------------------------------
source(("01_load_raw_data_and_clean.R"),
       skip.echo = 2)

source(("02_define_variables.R"),
       skip.echo = 1)

source(("03_user_interface.R"),
       skip.echo = 2)

source(("04_server.R"),
       skip.echo = 1)

#### App ---------------------------------------------------------------------
shinyApp(ui = ui, server = server)
