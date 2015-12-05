require(tidyr)
require(dplyr)
require(ggplot2)
require(jsonlite)
require(RCurl)
require(extrafont)



df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT * FROM CHILD_DEATHS WHERE COUNTRY IN (\\\'USA\\\', \\\'Mexico\\\') AND GBDCHILDCAUSES IN (\\\'Acute lower respiratory infections\\\', \\\'Congenital anomalies\\\', \\\'Injuries\\\', \\\'Prematurity\\\', \\\'Other communicable, perinatal and nutritional conditions\\\');"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

View(df)

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Five Highest Causes of Death in US and Mexico in Children 0 to 4 Years') +
  labs(x=paste("Years"), y=paste("Deaths")) +
  labs(color='Causes of Death') +
  facet_wrap (~COUNTRY) +
  layer(data=df, 
        mapping=aes(x=as.numeric((YEAR)), y=DEATHS_0_TO_4_YEARS, color=GBDCHILDCAUSES), 
        stat="identity", 
        stat_params=list(), 
        geom="line",
        geom_params=list(), 
        position=position_identity()
        #position=position_jitter(width=0.3, height=0)
  )