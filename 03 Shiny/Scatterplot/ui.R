# ui.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
library(shiny)

navbarPage(
  title = "DV_SProject1",
  tabPanel(title= "Scatterplot",
           sidebarPanel(
             actionButton(inputId = "clicks1", label = "Click me")
           ),
           mainPanel(plotOutput("scatterplot"))
           ),
  tabPanel(title= "Barchart",
           sidebarPanel(
             actionButton(inputId="clicks2", label = "Click me")
           ),
           mainPanel(plotOutput("barchart"))
  ),
  tabPanel(title= "Crosstab",
           sidebarPanel(
             sliderInput("KPI1", "KPI Low Max Value:",
                         min = 0, max = .1, value = .1),
             sliderInput("KPI2", "KPI Medium Max Value:",
                         min = .1, max = .25, value = .25)
           ),
           mainPanel(plotOutput("distPlot"))
           )
           )
#))
#fluidPage(
#  sliderInput(inputId = "num",
#              label="Choose a number",
#              value = 25, min = 1, max = 100),
#  plotOutput("scatterplot")
#)
