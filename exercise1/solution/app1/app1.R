ui <- fluidPage(
  titlePanel("Workshop - Example 1 – Basic  Histogram"),
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "n",
                   label = "Number of observations",
                   value = 1000) ),  
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output) {
  data <- reactive({
    x <- rnorm(input$n)
    x })
  
  output$plot <- renderPlot({
    hist(data(), 50, main = "",  xlab = "x")
  })
}


shinyApp(ui = ui, server = server)

