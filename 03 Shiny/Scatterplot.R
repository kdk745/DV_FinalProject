require("jsonlite")
require("RCurl")
require("ggplot2")
require("extrafont")

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT Year, Majortopic, Congress, Percentage FROM GALLUPS WHERE ((MAJORTOPIC=\\\'Civil Rights\\\' OR MAJORTOPIC=\\\'Crime\\\' OR MAJORTOPIC=\\\'Education\\\' OR MAJORTOPIC = \\\'Health\\\' OR MAJORTOPIC=\\\'Social Welfare\\\') AND (YEAR > 1960)) ORDER BY YEAR;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Most Important Problems in Social Issues 1960 - 2012') +
  labs(x=paste("Years"), y=paste("Percentage")) +
  layer(data=df, 
        mapping=aes(x=as.numeric((YEAR)), y=PERCENTAGE, color=MAJORTOPIC), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        position=position_identity()
        #position=position_jitter(width=0.3, height=0)
  )


