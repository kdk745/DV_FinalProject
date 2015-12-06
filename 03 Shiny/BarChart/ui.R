# ui.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
library(shiny)

navbarPage(
  title = "DV_FinalProject",
  tabPanel(title= "Barchart",
           sidebarPanel(
             actionButton(inputId="clicks2", label = "Click me")
           ),
           mainPanel(plotOutput("barchart"))
          )
           )
#))
#fluidPage(
#  sliderInput(inputId = "num",
#              label="Choose a number",
#              value = 25, min = 1, max = 100),
#  plotOutput("scatterplot")
#)
