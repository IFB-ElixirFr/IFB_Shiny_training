## Exercise 1: build and learn

1. Let us start: copy and run the first application presented today.

```R
ui <- fluidPage(
  titlePanel("Workshop - Example 1 - Basic Histogram"),
  sidebarLayout(
    sidebarPanel(
       numericInput(inputId="n",
                    label="Number of observations",
                    value=1000) ),  
       mainPanel(plotOutput(outputId="plot"))
  )
)

server <- function(input, output) {
   data <- reactive({
                     x <- rnorm(input$n)
                     x })

   output$plot <- renderPlot({
         	        hist(data(), breaks=50, main="",  xlab="x")
                   })
}
shinyApp(ui = ui, server = server)
```

2. **Bin numbers**: Change the application to allow the user to enter
the numbers of bins when plotting the histogram.

3. **Add some text to the output**: Change the application to add some
text to the output. The text should depend on the dataset; for example,
indicate the average and standard deviation of the data points.

4. **Choose mean and standard deviation**: Change the application so that

    - The user can enter different values for the mean and standard deviation. 
    - The mean and standard deviation are shown in the mainPanel.
    - The user can enter a title for the histogram.

5. **Different displays**: Change the application so that the user can
choose to do a histogram or a boxplot.

6. **Change the appearance of the widgets**: you can customize the size of
the bars and plots:

    - change the size of the sidebar; the "width" option of the sidebarPanel
      accepts values between 1 and 12.
    - Change the aspect ratio of the graph:
      plotOutput("plot", width="500px", height = "500px")

7. **Panel appears and disappears**:

      An ugly feature of our app: the input field Number of bins only makes sense for the histogram, not for the boxplot, so it should not appear when we do a boxplot.
      
      **Hint:** `conditionalPanel()`

8. Predefined data sets

    Let us read files on the server files. For this purpose, first we need to save the data sets in the same folder as ui.R and server.R, say with dump. Then we can read the data in the server with

```
if(input$dataset=="Newcomb's Speed of Light") {

            source("newcomb.R")

            return(newcomb)
}
```
 
Your turn: Read the 3 data sets available on github


9. Let the user upload a dataset (a file containing one value per row,
no headers) for display.

10. Summary statistics:

    In the text area we want a table of summary statistics.

    The idea here is to use R syntax to create a character vector which
has the lines of the HTML code.


11. Table presentations: These tables rarely look very good. To change
their appearance we need to use cascading style files. The easiest way
is to include that in the ui.R.


12. Several panels: Often it is a good idea to have several panels to
show different things. Say we want to separate the text from the
graph.

 

13. Graph displays: Again there are items on the left that only make
sense for the graphs, so they should only appear when the Graph panel
is selected. Again conditionalPanel to the rescue!

 

14. Animation: When generating random data we might want to do this a
number of times. Slowly, so one can watch the changes.

On ui side use :

```
sliderInput("k","Repeat!",min=1, max=10, value=0,step=1,
                animate=animationOptions(interval = 500,playButton="Go!")
         )
````

on server side use:

```
if(input$dataset=="Random") {
            for(i in 1:input$k) mu<-input$mu
            return(rnorm(input$n,input$mu,input$sig))
        } 
```

14. Use the gglot2 library: Now let us draw the graphs with ggplot2. For
this purpose, you must add require(ggplot2) on server side and change
the render plot function call for histogram and boxplot.

 
=========
 
