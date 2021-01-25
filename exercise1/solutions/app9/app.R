library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Workshop - Example 1 – Basic Histogram"),
  sidebarLayout(
    sidebarPanel(
      width=3,      
      ## Choose the data type between 5 options
      ## - random number sampling 
      ## - Newcomb dataset (loaded from file)
      ## - Euros dataset (loaded from file)
      ## - Forbes dataset (loaded from file)
      ## - User own dataset (loaded from file)
      selectInput("dataset", "Data type",  
                  c("Random numbers" = "rand",
                    "Newcomb's Speed of Light" = "newcomb",
                    "Euros" = "euros",
                    "Forbes" = "forbes",
                    "My own dataset" = "mydata"
                  ), 
                  multiple = FALSE, selectize = TRUE, width = "300px"),
      
      ## For the Forbes dataset, enable the user to specify the column of values to analyse
      conditionalPanel(
        condition = "input.dataset == 'forbes'",
        selectInput("column", "Data column", 
                    c("Assets",
                      "Sales",
                      "Market_Value",
                      "Profits",
                      "Cash_Flow",
                      "Employees"))
      ),
      
      ## Display the options of random number sampling only if
      ## the user has selected "rand" in the dataset option. 
      conditionalPanel(
        condition = "input.dataset == 'rand'",
        textInput(inputId = "main", label = "Plot title", value = "Random sampling distribution"),
        numericInput(inputId = "mean",
                     label = "Mean",
                     value = 5, width = "100px"), 
        numericInput(inputId = "sd",
                     label = "Standard deviation",
                     value = 2, width = "200px"), 
        numericInput(inputId = "n",
                     label = "Number of observations",
                     value = 1000, width = "200px")
       ),     
      
      ## Display the file input and the title panel only if
      ## the user want to use his dataset. 
      conditionalPanel(
        condition = "input.dataset == 'mydata'",
        fileInput(inputId = "myfile", label = "Upload your data (one value per row)"),
        textInput(inputId = "main", label = "Plot title", value = "My data sampling distribution")
      ),


      ## Choose the plot type between histogram and box plot
      radioButtons("plotType", "Plot type:",
                   c("Histogram" = "hist",
                     "Boxplot" = "boxplot")),
      
      # Only show the option "Number of bins" if the plot type is an histogram,
      # since this parameter makes no sense for the other plot type (boxplot)
      conditionalPanel(
        condition = "input.plotType == 'hist'",
        numericInput(inputId = "bins",
                     label = "Number of bins",
                     value = 25, width = "150px")      
      )
    ),  
    
    ## Define the output panel
    mainPanel(
      plotOutput("plot", height="500px", width="500px"),  # Panel to display the plot
      textOutput("hello"), # Panel to display the title
      textOutput("params"), # Panel to display the parameters
      textOutput("mean"), # Panel to display the standard deviation 
      textOutput("sd"), # Panel to display the mean
      dataTableOutput("datatable") # Panel to display the table
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    if (input$dataset == "newcomb") {
      message("Loading Newcomb dataset")
      x <- list(
        values = unlist(read.csv("newcomb.csv")[2]),
        main = "Newcomb")

    } else if (input$dataset == "forbes") {
      message("Loading Forbes dataset")
      forbes <- read.csv("forbes.csv") ## Load the forbes data table
      x <- list(
        values = forbes[, input$column], ## select the user-specified column
        main = paste("Forbes", input$column))

    } else if (input$dataset == "euros") {
      message("Loading Euros dataset")
      x <- list(
        values = unlist(read.csv("euros.csv")[2]),
        main = "Euros")

    } else if (input$dataset == "rand") {
      message("Generating random numbers")
      x <- list(
        values = rnorm(n = input$n, mean = input$mean, sd = input$sd),
        main = input$main)

    } else if (input$dataset == "mydata") {
      message("Loading your own dataset")
      inFile <- input$myfile
      if (is.null(inFile)) {
        x <- list(
          values = rnorm(input$n),
          main = input$main)
      } else {
        x <- list(
          values = read.csv(inFile$datapath, header=FALSE)[,1],
          main = input$main)
      }
      return(x)      
      
    } else {
      stop("Invalid dataset")
    }

    return(x) 
    
  })

  
  ## Draw the plot
  output$plot <- renderPlot({    
    if (input$plotType == "hist") {
      ## Histogram
      hist(data()$values, input$bins, xlab = "x", main = data()$main, 
           col = "#BBDDEE", las = 1); 
      abline(v = input$mean, col = "blue", lwd = 2)
      
    } else if (input$plotType == "boxplot") {
      ## Boxplot
      boxplot(data()$values, xlab = "x", main = data()$main)
    }
  })

  output$datatable <- renderDataTable(
      data.frame(data()$values),
      options = list(
          pageLength = 20)
  )

  output$hello <- renderText(data()$main)
  output$params <- renderText({
    if (input$dataset == "rand") {
      if (input$plotType == "hist") {
        paste0("Parameters: ",
               " n = ", input$n, "; bins = ", input$bins)
      } else {
        paste0("Parameters: n = ", input$n)
      }
    } else {
      if (input$plotType == "hist") {
        paste0("Parameters: bins = ", input$bins)
      }
    }
  })
  ## Display the user-specified mean for random sampling 
  output$mean <- renderText({
    paste0("mean = ", signif(digits = 3, mean(data()$values)))
  })
  
  ## Display the user-specified standard deviation for random sampling
  output$sd <- renderText({
    paste0("sd = ", signif(digits = 3, sd(data()$values)))
  })
  
}


shinyApp(ui = ui, server = server)

