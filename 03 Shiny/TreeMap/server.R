#server.R
require("portfolio")
require("RColorBrewer")
require("jsonlite")
require("RCurl")
require("extrafont")



shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    # Start your code here.
    

    
    Year = input$Min_Year     
    
    df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT GBDCHILDCAUSES, YEAR, sum(DEATHS_0_TO_4_YEARS) FROM CHILD_DEATHS GROUP BY GBDCHILDCAUSES, YEAR ORDER BY YEAR;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
    
    df2 <- df %>% filter(YEAR == Year)
    #df <- df %>% filter(YEAR == 2010)
    
    
    #df$GBDCHILDCAUSES is a number of items
    treemap <- map.market(id = df2$GBDCHILDCAUSES, area = df2$SUM.DEATHS_0_TO_4_YEARS., group = df2$YEAR, color = df2$SUM.DEATHS_0_TO_4_YEARS.,
               
               lab   = c("group" = TRUE, "id" = TRUE, "area" = TRUE, "color" = TRUE),
               main  = "Deaths 0 to 4 Years by Cause",
               print = TRUE)
    
    # End your code here.
    return(treemap)
  }) # output$distPlot
})
