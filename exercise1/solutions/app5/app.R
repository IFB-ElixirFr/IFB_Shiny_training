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
      numericInput(inputId = "bins",
                   label = "Number of bins",
                   value = 25),
      radioButtons("plottype", "Plot type:",
                   c("Histogram" = "hist",
                     "Boxplot" = "boxplot"))
    ),  
    mainPanel(
      plotOutput("plot") ,
      textOutput("hello"),
      textOutput("params"),
      textOutput("mean"),
      textOutput("sd")
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    x <- rnorm(n = input$n, mean = input$mean, sd = input$sd)
    x })

  output$plot <- renderPlot({
    if (input$plottype == "hist") {
      hist(data(), input$bins, xlab = "x", main = input$main); 
      abline(v = input$mean, col = "blue", lwd = 2)
      
    } else if (input$plottype == "boxplot") {
      boxplot(data(), xlab = "x", main = input$main)
    }
  })
  output$hello <- renderText({
    "Random histogram"
  })
  output$params <- renderText({
    paste0("Parameters: ",
           " n = ", input$n, "; bins = ", input$bins)
  })
  output$mean <- renderText({
    paste0("Mean = ", input$mean)
  })
  output$sd <- renderText({
    paste0("Sd = ", input$sd)
  })
  
  
}


shinyApp(ui = ui, server = server)

