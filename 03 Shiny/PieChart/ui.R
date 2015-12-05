#ui.R 

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(

# Application title
headerPanel("Year Control"),

# Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("Min_Year", 
                "Year:", 
                min = 2000,
                max = 2013, 
                value = 2000)
  ),

# Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
    #plotOutput("distTable")
  )
))
