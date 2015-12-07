# ui.R
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
  )
           )
#))
#fluidPage(
#  sliderInput(inputId = "num",
#              label="Choose a number",
#              value = 25, min = 1, max = 100),
#  plotOutput("scatterplot")
#)
