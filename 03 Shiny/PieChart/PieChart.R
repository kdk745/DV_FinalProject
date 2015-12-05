
df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from CHILD_DEATHS where (Country = \\\'Haiti\\\') ;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df_2 <- df %>% filter(YEAR == 2000)

bp<-ggplot(df_2,aes(x='',y=DEATHS_0_TO_4_YEARS,fill=GBDCHILDCAUSES))+geom_bar(width=1,stat="identity")

pie <- bp + coord_polar("y",start=0)

