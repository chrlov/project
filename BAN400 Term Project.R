#### Packages ----------------------------------------------------------------
library(tidyverse)
library(shiny)
library(leaflet)

#### Data --------------------------------------------------------------------
# COVID-19 data
data <- COVID19::covid19() %>% 
         transmute("Country"                             = administrative_area_level_1,
                   "Date"                                = date,
                   "Tests"                               = tests,
                   "Tests / Population"                  = tests / population,
                   "Confirmed Cases"                     = confirmed,
                   "Confirmed Cases / Population"        = confirmed / population,
                   "Confirmed Cases / Tests"             = confirmed / tests,
                   "Recovered"                           = recovered,
                   "Currently Infected"                  = confirmed - recovered, 
                   "Currently Infected / Population"     = (confirmed - recovered) / population,
                   "Deaths"                              = deaths,
                   "Deaths / Population"                 = deaths / population,
                   "Deaths / Confirmed Cases"            = deaths / confirmed,
                   "Closed: Schools"                     = school_closing,
                   "Closed: Workplaces"                  = workplace_closing,
                   "Closed: Transport"                   = transport_closing,
                   "Closed: Events"                      = cancel_events,
                   "Restriction: Gathering"              = gatherings_restrictions,
                   "Restriction: Stay Home"              = stay_home_restrictions,
                   "Restriction: Internal Movement"      = internal_movement_restrictions,
                   "Restriction: International Movement" = international_movement_restrictions,
                   "iso_a2"                              = iso_alpha_2
                   )

# Description of variables. Source: https://covid19datahub.io/articles/doc/data.html
explaination <- c(# id:
                  "unique identifier", 
                  #Country: 
                  "country", 
                  # Date:
                  "observation date", 
                  # Tests:
                  "the cumulative number of tests in a country.", 
                  # Tested / Population:
                  "the cumulative number of tests in a country divided by the respective 
                  country's population.", 
                  # Confirmed Cases:
                  "the cumulative number of confirmed cases in a country.", 
                  # Confirmed Cases / Population:
                  "the cumulative number of confirmed cases in a country divided by the 
                  country's population.", 
                  # Confirmed Cases / Tests:
                  "the cumulative number of confirmed cases in a country divided by the 
                  number of tests performed in the country.", 
                  # Recovered:
                  "the cumulative number of patients released from hospitals or reported 
                  recovered in a country.", 
                  # Currently Infected: 
                  "the cumulative number of confirmed cases in a country minus the 
                  cumulative number of patients released from hospitals or reported 
                  recovered in the country.", 
                  # Currently Infected / Population:
                  "the cumulative number of confirmed cases in a country minus the 
                  cumulative number of patients released from hospitals or reported 
                  recovered in the country, divided by the country's population.", 
                  # COVID-19 Deaths:
                  "the cumulative number of COVID-19 related deaths in a country.", 
                  # COVID-19 Deaths / Population:
                  "the cumulative number of COVID-19 related deaths in a country divided 
                  by the country's population.", 
                  # COVID-19 Deaths / Confirmed Cases:
                  "the cumulative number of COVID-19 related deaths in a country divided 
                  by the cumulative number of confirmed cases in the respective country.", 
                  # Closed: Schools:
                  "(0) No measures; (1) Recommend closing; (2) Require closing (only some 
                  levels or categories, eg just high school, or just public schools); (3) 
                  Require closing all levels", 
                  # Closed: Workplaces:
                  "(0) No measures; (1) Recommend closing (or work from home); (2) require 
                  closing for some sectors or categories of workers; (3) require closing 
                  (or work from home) all-but-essential workplaces (eg grocery stores, 
                  doctors)", 
                  # Closed: Transport:
                  "(0) No measures; (1) Recommend closing (or significantly reduce volume/
                  route/means of transport available); (2) Require closing (or prohibit 
                  most citizens from using it)", 
                  # Closed: Events:
                  "(0) No measures; (1) Recommend cancelling; (2) Require cancelling", 
                  # Restriction: Gathering:
                  "(0) No restrictions; (1) Restrictions on very large gatherings (the 
                  limit is above 1000 people); (2) Restrictions on gatherings between 
                  100-1000 people; (3) Restrictions on gatherings between 10-100 people; 
                  (4) Restrictions on gatherings of less than 10 people", 
                  # Restriction: Stay Home
                  "(0) No measures; (1) recommend not leaving house; (2) require not 
                  leaving house with exceptions for daily exercise, grocery shopping, 
                  and “essential” trips; (3) Require not leaving house with minimal 
                  exceptions (e.g. allowed to leave only once every few days, or only 
                  one person can leave at a time, etc.)", 
                  # Restriction: Internal Movement:
                  "(0) No measures; (1) Recommend closing (or significantly reduce 
                  volume/route/means of transport); (2) Require closing (or prohibit 
                  most people from using it)", 
                  # Restriction: International Movement:
                  "(0) No measures; (1) Screening; (2) Quarantine arrivals from high-risk 
                  regions; (3) Ban on high-risk regions; (4) Total border closure", 
                  # ISO id:
                  "ISO ID" 
                  )
explainations <- reshape2::melt(data.frame(c(colnames(data)), explaination))

#### User Interface ----------------------------------------------------------

# Defining background color for  wellPanels
color  <- "#ffffff" # HEX code
color2 <- "#c3e7ff" # HEX code
wellPcolor  <- paste("background-color: ", color,  ";")
wellPcolor2 <- paste("background-color: ", color2, ";")

# Creating the UI
ui <- navbarPage(title = strong("BAN400 Term Project"),
                 # Theme for UI 
                 theme = shinythemes::shinytheme("spacelab"),
                 # Plot Tab
                 tabPanel(title = "Graph Creator",
                          # Header Plot Tab
                          fluidRow(wellPanel(style = wellPcolor2, 
                                             h1(strong("Graph Creator for COVID-19"),
                                                align = "center")
                                  ),
                          ), 
                          sidebarLayout(
                               # Inputs: Plot Tab
                               sidebarPanel(style = wellPcolor,
                                            h4(strong("Inputs")),
                                            hr(),
                                            # Variables
                                            radioButtons(inputId = "variablePLOT",
                                                         label   = "Select variable",
                                                         choices = colnames(data)[-c(1:3, length(colnames(data)))]
                                            ),
                                            helpText("Please see the note under the plot for description of the chosen variable."
                                            ),
                                            # Countries
                                            selectInput(inputId  = "idPLOT",
                                                        label    = "Select countries",
                                                        choices  = unique(data$Country),
                                                        selected = c("Australia","Norway", "Denmark"),
                                                        multiple = T
                                            ),
                                            helpText("Select as many countries as you want."
                                            ),
                                            # Time period
                                            dateRangeInput(inputId = "datesPLOT",
                                                           label   = "Select time period",
                                                           start   = "2020-03-15",
                                                           end     = Sys.Date() - 7,
                                                           min     = min(data$Date),
                                                           max     = max(data$Date)
                                            ),
                                            helpText(paste("Latest data update:", 
                                                           max(data$Date))
                                            )
                               ),
                               # Outputs: Plot Tab
                               mainPanel(
                                    wellPanel(style = wellPcolor,
                                              # Header 
                                              h2(strong(textOutput("plotheader")),
                                                 align = "center"),
                                              br(),
                                              # Plot
                                              plotOutput("plot2", 
                                                         height = 485),
                                    ),
                                    fluidRow(column(width = 7,
                                                    wellPanel(style = wellPcolor,
                                                              # Description header
                                                              strong(textOutput("desc")),
                                                              hr(),
                                                              # Description
                                                              em(textOutput("descriptionPLOT"))
                                                    )
                                             ),
                                             column(width = 5, 
                                                    wellPanel(style = wellPcolor,
                                                              strong("Download .png file"),
                                                              hr(),
                                                              fluidRow(
                                                                      column(width = 6,
                                                                              # Download: Height
                                                                              numericInput(inputId = "height",
                                                                                           label   = "Height in cm",
                                                                                           value   = 18,
                                                                                           min     = 1,
                                                                                           max     = 100
                                                                              )
                                                                      ),
                                                                      column(width = 6,
                                                                              # Download: Width
                                                                              numericInput(inputId = "width",
                                                                                           label   = "Width in cm",
                                                                                           value   = 36,
                                                                                           min     = 1,
                                                                                           max     = 100
                                                                              )
                                                                      )
                                                              ),
                                                              # Download button
                                                              downloadButton(outputId = "downloadPlot",
                                                                             label    = "Download!",
                                                                             class    = "btn btn-success"
                                                              )
                                                    )
                                             )
                                     )
                               ) 
                          )
                 ),
                 # Table Tab
                 tabPanel(title = "Data Table",
                          # Header Data Table Tab
                          fluidRow(wellPanel(style = wellPcolor2,
                                             h1(strong("COVID-19 Data Tables"),
                                                align = "center"))
                          ),
                          sidebarLayout(
                               # Inputs: Table Tab
                               sidebarPanel(style = wellPcolor,
                                            h4(strong("Inputs")),
                                            hr(),
                                            # Variables
                                            radioButtons(inputId = "variableTABLE",
                                                         label   = "Select variable",
                                                         choices = colnames(data)[-c(1:3, length(colnames(data)))]
                                            ),
                                            # Countries
                                            selectInput(inputId  = "idTABLE",
                                                        label    = "Select countries",
                                                        choices  = unique(data$Country),
                                                        selected = c("Australia","Norway", "Denmark", "United States"),
                                                        multiple = T
                                            ),
                                            helpText("Choose as many countries as you want."
                                            ),
                                            # Time Period
                                            dateRangeInput(inputId = "datesTABLE",
                                                           label   = "Select time period",
                                                           start   = Sys.Date() - 31,
                                                           end     = Sys.Date() - 10,
                                                           min     = min(data$Date),
                                                           max     = max(data$Date)
                                            ),
                                            helpText(paste("Data updated:", 
                                                           max(data$Date))
                                            ),
                                            strong("Download table"),
                                            br(),
                                            # Download button
                                            downloadButton(outputId = "downloadTABLE",
                                                           label    = "Download Table",
                                                           class    = "btn btn-success"
                                            )
                               ),
                               # Outputs: Table Tab
                               mainPanel(
                                    wellPanel(style = wellPcolor,
                                        # Table header
                                        h3(strong(textOutput("tableheader")),
                                           align = "left"),
                                        # Table
                                        tableOutput("table")
                                    )
                               )
                          )
                 ),
                 # Interactive Map Tab
                 tabPanel(title = "Interactive Map",
                          # Header Interactive Map Tab
                          fluidRow(wellPanel(style = wellPcolor2,
                                             h1(strong("Interactive COVID-19 Map"),
                                                align = "center")
                                   )
                          ),
                          # Inputs: Interactive Map Tab
                          fluidRow(
                               wellPanel(style = wellPcolor,
                                         # Date
                                         sliderInput(inputId    = "dateMAP",
                                                     label      = "Select date",
                                                     min        = min(data$Date),
                                                     max        = max(data$Date),
                                                     value      = Sys.Date() - 60,
                                                     timeFormat = "%d %b 20%y",
                                                     animate    = animationOptions(interval = 7,
                                                                                   loop     = F)
                                         ),
                                         helpText(paste("Data last updated:", 
                                                        max(data$Date))
                                         ),
                                         # Variable
                                         selectInput(inputId = "variableMAP",
                                                     label   = "What do you want to compare?",
                                                     choices = colnames(data)[-c(1:3, 8, length(colnames(data)))]
                                         )
                               )
                          ),
                          # Outputs: Interactive Map Tab
                          fluidRow(
                               h2(textOutput("mapheader"),
                                  align = "center"), 
                               leafletOutput("map", 
                                             height = 700)
                          )
                 ),
                 h5("Data source: Guidotti and Ardia (2020). See", a(href="https://covid19datahub.io", "https://covid19datahub.io"),
                    align = "center")
)


#### Server ------------------------------------------------------------------
server <- function(input, output) {
     
## PLOT
        
     # Plot Header
     output$plotheader <- renderText({
          print(input$variablePLOT)
     })
     
     # Plot Variable Descriptions
     output$descriptionPLOT <- renderText({
          vars      <- input$variablePLOT
          show_text <- explainations %>% 
                        filter(c.colnames.data.. == vars)
          show      <- show_text[1, 2]
          print(paste("'",vars,"'", 
                      "is defined as", 
                      show))
     })
     
     # Plot Variable
     output$desc <- renderText({
          paste("Description of displayed variable:", input$variablePLOT)
     })
     
     # Plot inputs
     plotInput <- reactive({
          # Plot inputs from UI
          date_min <- input$datesPLOT[1]
          date_max <- input$datesPLOT[2]
          ids      <- input$idPLOT
          vars     <- input$variablePLOT
          # Relevant data
          df <- data %>% 
                  filter(Date     >=    date_min,
                         Date     <=    date_max,
                         Country  %in%  ids) %>% 
                  select(Country, Date, vars)
          # Defining plot
          p <- ggplot(data    = df,
                      aes(x   = Date,
                          y   = df[[input$variablePLOT]],
                          col = Country)) + 
               geom_line(size = 1.3) +
               scale_y_continuous(labels = scales::comma) +
               scale_x_date(date_breaks = "1 month",
                            date_labels = "%b") +
               xlab("Date") +
               ylab("")+
               labs(title    = paste("COVID-19:", input$variablePLOT),
                    subtitle = paste(format.Date(input$datesPLOT[1], format = "%d %B 20%y"), 
                                     "-", 
                                     format.Date(input$datesPLOT[2], format = "%d %B 20%y")),
                    caption  = "Data source: Guidotti and Ardia (2020), www.covid19datahub.io",
                    fill     = "Country") +
               theme_linedraw(base_size = 16,
                              base_family = "serif") + 
               theme(plot.title    = element_text(face   = "bold"),
                     plot.caption  = element_text(face   = "italic"),
                     legend.title  = element_text(face   = "bold"),
                     axis.title.x  = element_text(vjust  = -0.5)
                     )
     })
     
     # Draw the plot
     output$plot2 <- renderPlot({
             print(plotInput())
     })
     
     # Download the plot
     output$downloadPlot <- downloadHandler(
          # Filename: Downloaded Plot
          filename = function(){paste("BAN400,", 
                                      input$variablePLOT, 
                                      ",", 
                                      unique(list(input$idPLOT)), 
                                      input$datesPLOT[1], 
                                      " to", 
                                      input$datesPLOT[2], 
                                      ".png")
                               },
          # Content: Downloaded Plot
          content = function(file) {ggsave(file, 
                                           plot   = plotInput(), 
                                           device = "png", 
                                           dpi    = "retina",
                                           units  = "cm",
                                           width  = input$width,
                                           height = input$height)
                                   }
     )
     
     
## TABLE 
     
     # Table Header
     output$tableheader <- renderText({
          print(input$variableTABLE)
     })
     
     # Table data
     tabledata <- reactive({
             # Table inputs from UI
             date_min <- input$datesTABLE[1]
             date_max <- input$datesTABLE[2]
             ids      <- input$idTABLE
             vars     <- input$variableTABLE
             # Relevant data set
             data_app <- data %>% 
                     filter(Date      >=   date_min,
                            Date      <=   date_max,
                            Country  %in%  ids) %>% 
                     select(Country, Date, vars)
             # Formatting date column
             data_app$Date <- format(as.Date(data_app$Date), "20%y-%m-%d") 
             # Reshaping table
             data_app %>% 
                     reshape::cast(., Date ~ Country)
             })
              
             # Table itself
             output$table <- renderTable({
                     tabledata()
             },
             # Table options
             digits = 4, 
             na     = "Not Available")
     
     # Table download 
     output$downloadTABLE <- downloadHandler(
             # Filename: Downloaded Table
             filename = function(){paste("COVID-19 Data,",
                                         input$variableTABLE,
                                         ".csv")},
             # Content: Downloaded Table
             content = function(filename) {write.csv(tabledata(), filename)}
     )
    
      
## MAP
     
     # Map Header
     output$mapheader <- renderText({
             print(paste(input$variableMAP,
                         "per", 
                         format(input$dateMAP, "%A, %B %d, %Y")))
     })
     
     # Creating map
     output$map <- renderLeaflet({
          # Map inputs
          date_map <- input$dateMAP
          vars     <- input$variableMAP
          # Relevant data
          data_app <- data %>% 
                        filter(Date == date_map)
          # sfc_MULTIPLOYGON data
          world <- spData::world
          # Adding geoms to our relevant data set
          df <- merge(data_app, world[ ,c(1,11)],
                      by = "iso_a2") %>% 
                  sf::st_as_sf()
          # Set colors for map
          pal <- colorNumeric(palette  = "Reds", 
                              domain   = df[[input$variableMAP]], 
                              na.color = "#000000")
          # Map itself
          leaflet(df) %>% 
               addProviderTiles("CartoDB.Voyager") %>% 
               addPolygons(
                    fillColor    = ~pal(df[[input$variableMAP]]),
                    weight       = 2,
                    opacity      = 1,
                    color        = "white",
                    dashArray    = "3",
                    fillOpacity  = 0.9, 
                    highlight    = highlightOptions(weight       = 1,
                                                    color        = "red",
                                                    dashArray    = "",
                                                    fillOpacity  = 0.7,
                                                    bringToFront = TRUE),
                    label        = ~paste(Country, ":" ,format(round(as.numeric(df[[input$variableMAP]]), 7), nsmall=0, big.mark=",")),
                    labelOptions = labelOptions(style     = list("font-weight" = "normal", 
                                                                 padding       = "3px 8px"),
                                                textsize  = "15px",
                                                direction = "auto")) %>% 
               addLegend(pal      = pal, 
                         values   = ~df[[input$variableMAP]], 
                         opacity  = 1, 
                         title    = NULL,
                         position = "bottomright")
     })
     
}

#### App ---------------------------------------------------------------------
runApp(shinyApp(ui     = ui, 
                server = server), 
       launch.browser  = T)
