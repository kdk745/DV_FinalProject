
# server.R
require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")
library("shiny")
require("shinydashboard")
require("leaflet")

shinyServer(function(input, output) {
    
    df <- eventReactive(input$clicks1,{data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT * FROM CHILD_DEATHS WHERE COUNTRY IN (\\\'USA\\\', \\\'Mexico\\\') AND GBDCHILDCAUSES IN (\\\'Acute lower respiratory infections\\\', \\\'Congenital anomalies\\\', \\\'Injuries\\\', \\\'Prematurity\\\', \\\'Other communicable, perinatal and nutritional conditions\\\');"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
    })
    
    
    output$scatterplot <- renderPlot (height=500, width=1000, {
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
    observeEvent(input$clicks, {
      print(as.numeric(input$clicks))
    })
    
    df2 <- eventReactive(input$clicks2, {df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select majortopic, year, sum(sum_percentage) as sum_percentage, avg_percentage, avg(avg_percentage) OVER (PARTITION BY majortopic) as window_avg from (select year, majortopic, sum(PERCENTAGE) as sum_percentage, avg(percentage) as avg_percentage from GALLUPS group by year, majortopic) where ((year="1990" or year="1995" or year="2000" or year="2005" or year="2010") and (majortopic!=\'Agriculture\' and majortopic!=\'Domestic Commerce\' and majortopic!=\'Housing  and  Development\' and majortopic!=\'Labor\' and majortopic!=\'Public Lands\' and majortopic!=\'Transportation\')) group by year, majortopic, avg_percentage order by majortopic, year "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))})
    
    #spread(df, YEAR, SUM_PERCENTAGE)
    
    output$barchart <- renderPlot(height=2000, width=2500, {
      plot1 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_wrap(~MAJORTOPIC, ncol=1) +
      labs(title='Major Topic Public Opinion Poll Barchart') +
      labs(x=paste("YEAR"), y=paste("SUM_PERCENTAGE")) +
      layer(data=df2(), 
            mapping=aes(x=factor(YEAR), y=SUM_PERCENTAGE, fill=SUM_PERCENTAGE), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="blue"), 
            position=position_identity()
      ) + coord_flip() +
      layer(data=df2(), 
            mapping=aes(yintercept = WINDOW_AVG), 
            geom="hline",
            geom_params=list(colour="red")
      ) + 
      layer(data=df2(), 
            mapping=aes(x=factor(YEAR), y=SUM_PERCENTAGE, label=sprintf("%2.4f",SUM_PERCENTAGE)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="black", hjust=-0.5), 
            position=position_identity()
      ) +
      layer(data=df2(), 
            mapping=aes(x=factor(YEAR), y=AVG_PERCENTAGE, label=sprintf("%2.4f",WINDOW_AVG)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            label=value,
            geom_params=list(colour="red", hjust=-5), 
            position=position_identity()
      ) 
      plot1
      })
    
 #   frame <- (data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select YEAR, MAJORTOPIC, PERCENTAGE from GALLUPS where (MAJORTOPIC = \\\'Macroeconomics\\\' or MAJORTOPIC = \\\'Defense\\\') and YEAR >= 2007;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))) %>%  mutate(KPI = ifelse(PERCENTAGE < 0.1, 'Low', ifelse(PERCENTAGE < 0.25, 'Moderate', 'High')))  
    

    
    output$distPlot <- renderPlot({
      # Start your code here.
      
      # The following is equivalent to KPI Story 2 Sheet 2 and Parameters Story 3 in "Crosstabs, KPIs, Barchart.twb"
      
      KPI_Low_Max_value = input$KPI1     
      KPI_Medium_Max_value = input$KPI2
      
      
      df3 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select YEAR, MAJORTOPIC, PERCENTAGE from GALLUPS where (MAJORTOPIC = \\\'Crime\\\' or MAJORTOPIC = \\\'Defense\\\') and (YEAR >= 1999 and YEAR <=2005);"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
      
      df3 <- df3 %>% mutate(KPI = ifelse(PERCENTAGE < KPI_Low_Max_value, 'Low', ifelse(PERCENTAGE < KPI_Medium_Max_value, 'Moderate', 'High'))) 
      
      ct <- ggplot(df3, aes(MAJORTOPIC, YEAR)) + geom_tile(aes(fill = KPI)) + theme_bw() + xlab("") + ylab("") +  geom_text(aes(label = PERCENTAGE)) + labs(title = "Gallup Poll Crosstab") + theme(panel.grid.major = element_line(colour = "black")) + scale_fill_manual(values=c("#78C3FB", "#16E0BD", "#98838F"))
      
      # End your code here.
      return(ct)
    })
}
)
