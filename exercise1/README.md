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

      An ugly feature of our application: the input field Number of
      bins only makes sense for the histogram, not for the boxplot, so
      it should not appear when we do a boxplot.
      
      **Hint:** use the `conditionalPanel()` function.

8. **Access predefined data sets**

    a. Let the user choose (using a drop down menu) to either generate the
    random data or use one of several datafiles available on the server.

    b. Save the data sets in the same folder as app.R, for example in CSV format

    c. We can read the data in the server with a command like

```
if(input$dataset=="Newcomb's Speed of Light") {
            x <- read.csv("newcomb.csv")
            return(x)
}
```
 
     github contains 3 datasets that you can use: euros, forbes, newcomb.

9. **Dataset upload**

   a. Let the user upload its own dataset (a file containing one value
   per row, no headers) so that it is plotted by the app.

   **Hint**: use the fileInput() function; note that this function does not
   return the file itself, but a structure containing metadata about the file,
   including a link that you can then use to open the file (have a look at the
   help page for more information).

   b. Add an output widget that displays the content of the file as a table

   **Hint**: use the tableOutput() widget.

10. **Several tabs**: Often it is a good idea to have several tabs to
organize the output when showing different information. Say we want to
separate the text, the graph and the table display

   **Hint**: look at the tabsetPanel() function.

11. **Use another library**: let us draw the graphs with ggplot2
instead of base R. For this purpose, you must add require(ggplot2) on
server side and change the render plot function call for histogram and
boxplot.

12. **Animation**: When generating random data we might want to do this a
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

13. **Conditional widgets**: again, at this point, there are items on
the left that only make sense in some cases, so they should only
appear when needed. For example, the graph options should only be present
when the the Graph tab is selected. Again, conditionalPanel() to the
rescue!


### Additional exercises

14. **Summary statistics**:

    In the text area we want a table of summary statistics.

    The idea here is to use R syntax to create a character vector
    which has the lines of the HTML code.

15. **Download a file**: let the user download a file produced by the
application.

16. **Table presentations**: These tables rarely look very good. To change
their appearance we need to use cascading style files. The easiest way
is to include that in the ui.R.

17. **Use the plotly or D3 libraries**


=========
 
