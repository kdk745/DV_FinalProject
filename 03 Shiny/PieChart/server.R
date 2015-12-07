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
      
  Year = input$Min_Year     
 
  df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from CHILD_DEATHS where (Country = \\\'Haiti\\\') ;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE),))
  
  df_2 <- df %>% filter(YEAR == Year)
  bp<-ggplot(df_2,aes(x='',y=DEATHS_0_TO_4_YEARS,fill=GBDCHILDCAUSES))+geom_bar(width=1,stat="identity")
  
  pie <- bp + coord_polar("y",start=0) + labs(title="Haiti")

  # End your code here.
        return(pie)
  }) # output$distPlot
})
