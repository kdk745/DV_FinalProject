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
      labs(title='Top 5 Causes of Deaths in Children Ages 0-27 Days') +
      labs(x=paste("Country"), y=paste("Number of Deaths in Children Ages 0-27 Days")) +
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
  output$text <- renderText({
    paste("This graph shows the top 5 causes of death in children ages 0-27 days in the 5 countries with the highest number of child deaths.", "", "Top 5 Causes: Acute lower respiratory infections, Congenital Anomalies, Injuries, Other communicable, perinatal, & nutritional conditions, and Prematurity", "", "Top 5 Countries: Dominican Republic, Guatemala, Haiti, Mexico, USA", "", "Interestingly enough, the U.S. ranks the highest in 3/5 categories (Congenital anomalies, Other communicable, prenatal, & nutritional conditions, and Prematurity) despite the advanced technologies and healthcare that the other nations may not have access to", "", "Prematurity in particulary is a very interesting category because the U.S. has about 4-5X the number of deaths as the Dominican Republic, which ranks last in this set", "", "Deaths in the U.S. is higher than average in 4/5 categories (all except for acute lower respiratory infections)", sep="\n")
  })
  
  df2 <- eventReactive(input$clicks2, {df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select GBDCHILDCAUSES, country, sum(sum_deaths_1_to_59_months) as sum_deaths_1_to_59_months, avg(sum_deaths_1_to_59_months) OVER (PARTITION BY gbdchildcauses) as window_avg from (select country, GBDCHILDCAUSES, sum(deaths_1_to_59_months) as sum_deaths_1_to_59_months, avg(deaths_1_to_59_months) as avg_deaths_1_to_59_months from child_deaths where (country = \'Dominican Republic\' or country = \'Guatemala\' or country = \'Haiti\' or country = \'Mexico\' or country = \'USA\') and (gbdchildcauses = \'Acute lower respiratory infections\' or  gbdchildcauses = \'Congenital anomalies\' or gbdchildcauses = \'Injuries\' or gbdchildcauses = \'Other communicable, perinatal and nutritional conditions\' or gbdchildcauses = \'Prematurity\') group by country, gbdchildcauses) group by country, gbdchildcauses, sum_deaths_1_to_59_months;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))})
  
  #spread(df, YEAR, SUM_PERCENTAGE)
  
  output$barchart2 <- renderPlot(height=800, width=1500, {
    plot2 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_wrap(~GBDCHILDCAUSES) +
      labs(title='Top 5 Causes of Death in Children Ages 1-59 Months') +
      labs(x=paste("Country"), y=paste("Number of Deaths in Children Ages 1-59 Months")) +
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
  output$text2 <- renderText({
    paste("This graph shows the top 5 causes of death in children ages 1-59 months in the 5 countries with the highest number of child deaths.", "", "Top 5 Causes: Acute lower respiratory infections, Congenital Anomalies, Injuries, Other communicable, perinatal, & nutritional conditions, and Prematurity", "", "Top 5 Countries: Dominican Republic, Guatemala, Haiti, Mexico, USA", "", "", "WHO's rankings of the world's health systems issued the following ranks: Dominican Republic (51), Guatemala (78), Haiti (138), Mexico (61), U.S. (37)", "", "One interesting thing is that although Haiti's health system is ranked the lowest out of all 5 countries in this set (the U.S. is ranked the highest in the set), it still had lower deaths than the U.S. in 3 categories (Congenital anomalies, Injuries, and Prematurity).", "", "Mexico's health system ranks the 2nd highest in the set, yet it has the highest number of deaths in 4/5 categories (all except prematurity, where it was as close 2nd to the U.S.).", "", "When comparing the age groups 0-27 days vs. 1-59 months:", "", "  -The averages increase in 3/5 of the Causes of Death (Acute lower respiratory infections, Other communicable, prenatal, & nutritional conditions, and Injuries) from the age group 0-27 days to the age group 1-59 months.", "", "  -The biggest increase in average is seen in Acute lower respirator infections, followed closely by Injuries.", "", "  -The biggest decrease in average is seen in Prematurity.", sep="\n")
  })
  
  df <- eventReactive(input$clicks3,{data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT * FROM CHILD_DEATHS WHERE COUNTRY IN (\\\'USA\\\', \\\'Mexico\\\') AND GBDCHILDCAUSES IN (\\\'Acute lower respiratory infections\\\', \\\'Congenital anomalies\\\', \\\'Injuries\\\', \\\'Prematurity\\\', \\\'Other communicable, perinatal and nutritional conditions\\\');"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  })
  
  
  output$scatterplot <- renderPlot (height=700, width=1300, {
    plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous() +
      labs(title='Five Highest Causes of Death in US and Mexico in Children 0 to 4 Years') +
      labs(x=paste("Years"), y=paste("Deaths")) +
      labs(color='Causes of Death') +
      facet_wrap (~COUNTRY) +
      layer(data=df(), 
            mapping=aes(x=as.numeric((YEAR)), y=DEATHS_0_TO_4_YEARS, color=GBDCHILDCAUSES), 
            stat="identity", 
            stat_params=list(), 
            geom="line",
            geom_params=list(), 
            position=position_identity()
            #position=position_jitter(width=0.3, height=0)
      )
    plot
  })
  
})
