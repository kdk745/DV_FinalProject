# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
  # Start your code here.

  # The following is equivalent to KPI Story 2 Sheet 2 and Parameters Story 3 in "Crosstabs, KPIs, Barchart.twb"
      
  KPI_Low_Max_value = input$KPI1     
  KPI_Medium_Max_value = input$KPI2
      
  
  df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select YEAR, MAJORTOPIC, PERCENTAGE from GALLUPS where (MAJORTOPIC = \\\'Crime\\\' or MAJORTOPIC = \\\'Defense\\\') and (YEAR >= 1999 and YEAR <=2005);"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  
  df <- df %>% mutate(KPI = ifelse(PERCENTAGE < KPI_Low_Max_value, 'Low', ifelse(PERCENTAGE < KPI_Medium_Max_value, 'Moderate', 'High'))) 
  
  ct <- ggplot(df, aes(MAJORTOPIC, YEAR)) + geom_tile(aes(fill = KPI)) + theme_bw() + xlab("") + ylab("") +  geom_text(aes(label = PERCENTAGE)) + labs(title = "Gallup Poll Crosstab") + theme(panel.grid.major = element_line(colour = "black")) + scale_fill_manual(values=c("#78C3FB", "#16E0BD", "#98838F"))

  # End your code here.
        return(ct)
  }) # output$distPlot
})
