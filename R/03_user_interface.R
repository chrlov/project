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

