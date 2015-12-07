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
    
    #KPI_Low_Max_value = input$KPI1     
    #KPI_Medium_Max_value = input$KPI2
    
    KPI_Low_Max_value = 0.49   
    KPI_Medium_Max_value = 0.6
    
    
    df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select country, gbdchildcauses, sum(DEATHS_0_TO_4_YEARS) as sum_deaths_0_to_4_years, sum(DEATHS_0_TO_27_DAYS)/sum(DEATHS_0_TO_4_YEARS) as KPI_proportion from child_deaths where (gbdchildcauses = \'Acute lower respiratory infections\' or  gbdchildcauses = \'Congenital anomalies\' or gbdchildcauses = \'Injuries\' or gbdchildcauses = \'Other communicable, perinatal and nutritional conditions\' or gbdchildcauses = \'Prematurity\') group by country, gbdchildcauses;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
    
    df <- df %>% mutate(KPI = ifelse(KPI_PROPORTION <= KPI_Low_Max_value, 'Low', ifelse(KPI_PROPORTION <= KPI_Medium_Max_value, 'Moderate', 'High')))
    View(df)
    
    ct <- ggplot(df, aes(GBDCHILDCAUSES, COUNTRY)) + geom_tile(aes(fill = KPI)) + theme_bw() + xlab("") + ylab("") +  geom_text(aes(label = DEATHS_0_TO_4_YEARS)) + labs(title = "Causes of Death in Children Ages 0-4 Years Crosstab") + theme(panel.grid.major = element_line(colour = "black")) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_fill_manual(values=c("#78C3FB", "#16E0BD", "#98838F"))
    
    # End your code here.
    return(ct)
  }, height=1000, width=1800) # output$distPlot
})
