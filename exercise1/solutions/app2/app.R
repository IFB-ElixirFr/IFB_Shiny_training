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
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output) {
  data <- reactive({
    x <- rnorm(input$n)
    x })
  
  output$plot <- renderPlot({
    hist(data(), input$bins, main = "",  xlab = "x")
  })
}


shinyApp(ui = ui, server = server)

