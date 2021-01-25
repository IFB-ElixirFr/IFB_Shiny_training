library(shiny)

ui <- fluidPage(
  titlePanel("Workshop - Example 1 – Basic  Histogram"),
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "n",
                   label = "Number of observations",
                   value = 1000), 
      numericInput(inputId = "bins",
                   label = "Number of bins",
                   value = 25)
      ),  
    mainPanel(
      plotOutput("plot"), 
      textOutput("hello"),
      textOutput("params"),
      textOutput("stats")
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    x <- rnorm(input$n)
    x })

  output$plot <- renderPlot({
    hist(data(), input$bins, main = "",  xlab = "x")
  })

  output$hello <- renderText({
    "Random histogram"
  })
  output$params <- renderText({
    paste0("Parameters: ",
           " n = ", input$n, "; bins = ", input$bins) 
  })
}


shinyApp(ui = ui, server = server)

