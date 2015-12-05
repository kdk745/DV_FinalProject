require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select majortopic, year, sum(sum_percentage) as sum_percentage, avg_percentage, avg(avg_percentage) OVER (PARTITION BY majortopic) as window_avg from (select year, majortopic, sum(PERCENTAGE) as sum_percentage, avg(percentage) as avg_percentage from GALLUPS group by year, majortopic) where ((year="1990" or year="1995" or year="2000" or year="2005" or year="2010") and (majortopic!=\'Agriculture\' and majortopic!=\'Domestic Commerce\' and majortopic!=\'Housing  and  Development\' and majortopic!=\'Labor\' and majortopic!=\'Public Lands\' and majortopic!=\'Transportation\')) group by year, majortopic, avg_percentage order by majortopic, year "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

spread(df, YEAR, SUM_PERCENTAGE)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_wrap(~MAJORTOPIC, ncol=1) +
  labs(title='Major Topic Public Opinion Poll Barchart') +
  labs(x=paste("YEAR"), y=paste("SUM_PERCENTAGE")) +
  layer(data=df, 
        mapping=aes(x=factor(YEAR), y=SUM_PERCENTAGE, fill=SUM_PERCENTAGE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="blue"), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=df, 
        mapping=aes(yintercept = WINDOW_AVG), 
        geom="hline",
        geom_params=list(colour="red")
  ) + 
layer(data=df, 
mapping=aes(x=factor(YEAR), y=SUM_PERCENTAGE, label=sprintf("%2.4f",SUM_PERCENTAGE)), 
stat="identity", 
stat_params=list(), 
geom="text",
label=value,
geom_params=list(colour="black", hjust=-0.5), 
position=position_identity()
) +
layer(data=df, 
mapping=aes(x=factor(YEAR), y=AVG_PERCENTAGE, label=sprintf("%2.4f",WINDOW_AVG)), 
stat="identity", 
stat_params=list(), 
geom="text",
label=value,
geom_params=list(colour="red", hjust=-5), 
position=position_identity()
) 
