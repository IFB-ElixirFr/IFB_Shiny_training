    ui <- fluidPage(
      titlePanel("Workshop - Example 1 – Basic  Histogram"),
      sidebarLayout(
        sidebarPanel(
          textInput(inputId = "main", label = "Plot title", value = "Random sampling distribution"),
          
          numericInput(inputId = "mean",
                       label = "Mean",
                       value = 5), 
          numericInput(inputId = "sd",
                       label = "Standard deviation",
                       value = 2), 
          numericInput(inputId = "n",
                       label = "Number of observations",
                       value = 1000), 
          
          radioButtons("plotType", "Plot type:",
                       c("Histogram" = "hist",
                         "Boxplot" = "boxplot")),
          
          
          # Only show the option "Number of bins" if the plot type is a histogram,
          # since this parameter makes no sense for the other plot type (boxplot)
          conditionalPanel(
            condition = "input.plotType == 'hist'",
            numericInput(inputId = "bins",
                         label = "Number of bins",
                         value = 25)        
          )
          
          ),  
        mainPanel(
          textOutput("mean"),
          textOutput("sd"),
          plotOutput("plot") 
        )
      )
    )
    
    server <- function(input, output) {
      data <- reactive({
        x <- rnorm(n = input$n, mean = input$mean, sd = input$sd)
        x })
    
      output$mean <- renderText({
        paste0("mean = ", input$mean)
      })
      output$sd <- renderText({
        paste0("sd = ", input$sd)
      })
      output$plot <- renderPlot({
        if (input$plotType == "hist") {
          hist(data(), input$bins, xlab = "x", main = input$main, 
               col = "#BBDDEE", las = 1); 
          abline(v = input$mean, col = "blue", lwd = 2)
    
        } else if (input$plotType == "boxplot") {
          boxplot(data(), xlab = "x", main = input$main)
        }
      })
      
      
    }
    
    
    shinyApp(ui = ui, server = server)
    
