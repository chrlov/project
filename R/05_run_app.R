#### Packages ----------------------------------------------------------------
library(tidyverse)
library(shiny)
library(leaflet)
library(here)

#### Connect R scripts -------------------------------------------------------
source(file = here("R", "01_load_raw_data_and_clean.R"),
       skip.echo = 2)

source(file = here("R", "02_define_variables.R"),
       skip.echo = 1)

source(file = here("R", "03_user_interface.R"),
       skip.echo = 2)

source(file = here("R", "04_server.R"),
       skip.echo = 1)


#### App ---------------------------------------------------------------------
runApp(shinyApp(ui     = ui, 
                server = server), 
       launch.browser  = T)
