#ui.R 

require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
library(shiny)

navbarPage(
  title = "DV_FinalProject",
  tabPanel(title= "Treemap",
           # Application title
           headerPanel("Year Control"),
           
           # Sidebar with a slider input for number of observations
           sidebarPanel(
             sliderInput("slide_Year", 
                         "Year:", 
                         min = 2000,
                         max = 2013, 
                         value = 2000)
           ),
           
           # Show a plot of the generated distribution
           mainPanel(
             plotOutput("treemap")
             #plotOutput("distTable")
           )
  ),
  tabPanel(title= "Scatterplot",
           sidebarPanel(
             actionButton(inputId = "clicks3", label = "Show Scatterplot: U.S./Mexico")
           ),
           mainPanel(plotOutput("scatterplot"))
  ),
  tabPanel(title= "Crosstab",
           sidebarPanel(
             sliderInput("KPI1", 
                         "KPI_Low_Max_value:", 
                         min = 0,
                         max = 0.49, 
                         value = 0),
             sliderInput("KPI2", 
                         "KPI_Medium_Max_value:", 
                         min = 0.49,
                         max = 0.6, 
                         value = 0.49)
           ),
           mainPanel(plotOutput("crosstab"))
  ),
  tabPanel(title= "Barchart: 0-27 Days",
           sidebarPanel(
             actionButton(inputId="clicks1", label = "Show Barchart: 0-27 Days"),
             verbatimTextOutput("text")
           ),
           mainPanel(plotOutput("barchart"))
  ), 
  tabPanel(title= "Barchart: 1-59 Months",
           sidebarPanel(
             actionButton(inputId="clicks2", label = "Show Barchart: 1-59 Months"),
             verbatimTextOutput("text2")
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


