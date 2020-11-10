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
