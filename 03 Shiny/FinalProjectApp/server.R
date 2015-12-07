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
  
  df1 <- eventReactive(input$clicks1, {df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select GBDCHILDCAUSES, country, sum(sum_deaths_0_to_27_days) as sum_deaths_0_to_27_days, avg(sum_deaths_0_to_27_days) OVER (PARTITION BY gbdchildcauses) as window_avg from (select country, GBDCHILDCAUSES, sum(deaths_0_to_27_days) as sum_deaths_0_to_27_days, avg(deaths_0_to_27_days) as avg_deaths_0_to_27_days from child_deaths where (country = \'Dominican Republic\' or country = \'Guatemala\' or country = \'Haiti\' or country = \'Mexico\' or country = \'USA\') and (gbdchildcauses = \'Acute lower respiratory infections\' or  gbdchildcauses = \'Congenital anomalies\' or gbdchildcauses = \'Injuries\' or gbdchildcauses = \'Other communicable, perinatal and nutritional conditions\' or gbdchildcauses = \'Prematurity\') group by country, gbdchildcauses) group by country, gbdchildcauses, sum_deaths_0_to_27_days;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))})
  
  #spread(df, YEAR, SUM_PERCENTAGE)
  
  output$barchart <- renderPlot(height=800, width=1500, {
    plot1 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_wrap(~GBDCHILDCAUSES) +
      labs(title='Child Deaths Barchart') +
      labs(x=paste("Cause of Death"), y=paste("Deaths")) +
      layer(data=df1(), 
            mapping=aes(x=COUNTRY, y=SUM_DEATHS_0_TO_27_DAYS, fill=COUNTRY), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="blue"), 
            position=position_identity()
      ) +
      layer(data=df1(), 
            mapping=aes(yintercept = WINDOW_AVG), 
            geom="hline",
            geom_params=list(colour="red")
      ) + 
      layer(data=df1(), 
            mapping=aes(x=COUNTRY, y=SUM_DEATHS_0_TO_27_DAYS, label=SUM_DEATHS_0_TO_27_DAYS), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="black", hjust=-0.5), 
            position=position_identity()
      ) +
      layer(data=df1(), 
            mapping=aes(x=COUNTRY, y=WINDOW_AVG, label=WINDOW_AVG), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="red", hjust=-5), 
            position=position_identity()
      ) 
    plot1
  })
  
  df2 <- eventReactive(input$clicks2, {df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select GBDCHILDCAUSES, country, sum(sum_deaths_1_to_59_months) as sum_deaths_1_to_59_months, avg(sum_deaths_1_to_59_months) OVER (PARTITION BY gbdchildcauses) as window_avg from (select country, GBDCHILDCAUSES, sum(deaths_1_to_59_months) as sum_deaths_1_to_59_months, avg(deaths_1_to_59_months) as avg_deaths_1_to_59_months from child_deaths where (country = \'Dominican Republic\' or country = \'Guatemala\' or country = \'Haiti\' or country = \'Mexico\' or country = \'USA\') and (gbdchildcauses = \'Acute lower respiratory infections\' or  gbdchildcauses = \'Congenital anomalies\' or gbdchildcauses = \'Injuries\' or gbdchildcauses = \'Other communicable, perinatal and nutritional conditions\' or gbdchildcauses = \'Prematurity\') group by country, gbdchildcauses) group by country, gbdchildcauses, sum_deaths_1_to_59_months;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))})
  
  #spread(df, YEAR, SUM_PERCENTAGE)
  
  output$barchart2 <- renderPlot(height=800, width=1500, {
    plot2 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_wrap(~GBDCHILDCAUSES) +
      labs(title='Child Deaths Barchart') +
      labs(x=paste("Cause of Death"), y=paste("Deaths")) +
      layer(data=df2(), 
            mapping=aes(x=COUNTRY, y=SUM_DEATHS_1_TO_59_MONTHS, fill=COUNTRY),               stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="blue"), 
            position=position_identity()
      ) +
      layer(data=df2(), 
            mapping=aes(yintercept = WINDOW_AVG), 
            geom="hline",
            geom_params=list(colour="red")
      ) + 
      layer(data=df2(), 
            mapping=aes(x=COUNTRY, y=SUM_DEATHS_1_TO_59_MONTHS, label=SUM_DEATHS_1_TO_59_MONTHS), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="black", hjust=-0.5), 
            position=position_identity()
      ) +
      layer(data=df2(), 
            mapping=aes(x=COUNTRY, y=WINDOW_AVG, label=WINDOW_AVG), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="red", hjust=-5), 
            position=position_identity()
      ) 
    plot2
  })
  
})
