#ui.R 

require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
library(shiny)

navbarPage(
  title = "DV_FinalProject",
  tabPanel(title= "Barchart: 0-27 Days",
           sidebarPanel(
             actionButton(inputId="clicks1", label = "Show Barchart: 0-27 Days")
           ),
           mainPanel(plotOutput("barchart"))
  ), 
  tabPanel(title= "Barchart: 1-59 Months",
           sidebarPanel(
             actionButton(inputId="clicks2", label = "Show Barchart: 1-59 Months")
           ),
           mainPanel(plotOutput("barchart2"))
  ),
  tabPanel(title= "Pie Chart: Haiti",
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
  )
)


