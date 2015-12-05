#ui.R 

library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(

# Application title
headerPanel("KPI Control"),

# Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("KPI1", 
                "KPI_Low_Max_value:", 
                min = 0,
                max = 0.1, 
                value = 0.1),
    sliderInput("KPI2", 
                "KPI_Medium_Max_value:", 
                min = 0.1,
                max = 0.25, 
                value = 0.25)
  ),

# Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
    #plotOutput("distTable")
  )
))
