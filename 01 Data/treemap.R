require("portfolio")
require("RColorBrewer")
require("jsonlite")
require("RCurl")
require("extrafont")

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT GBDCHILDCAUSES, YEAR, sum(DEATHS_0_TO_4_YEARS) FROM CHILD_DEATHS WHERE YEAR = \\\'2010\\\' GROUP BY GBDCHILDCAUSES, YEAR ORDER BY YEAR;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

df2 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT GBDCHILDCAUSES, YEAR, COUNTRY, sum(DEATHS_0_TO_4_YEARS) FROM CHILD_DEATHS GROUP BY GBDCHILDCAUSES, YEAR, COUNTRY ORDER BY YEAR;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

df3 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="SELECT * FROM CHILD_DEATHS;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_znk74', PASS='orcl_znk74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
VAR <- df3 %>% group_by(YEAR) %>% summarise(total=sum(DEATHS_0_TO_4_YEARS))

df2 %>% filter(YEAR == 2000) %>% mutate(total=cumsum(SUM.DEATHS_0_TO_4_YEARS.)) %>% df2
df %>% mutate(total=cumsum(DEATHS_0_TO_4_YEARS))
View(tbl_df)
#names(df)
head(df2)
View(df2)
head(df)

VAR[12]

#df$GBDCHILDCAUSES is a number of items
map.market(id = df$GBDCHILDCAUSES, area = df$SUM.DEATHS_0_TO_4_YEARS., group = df$YEAR, color = df$SUM.DEATHS_0_TO_4_YEARS.,
           
           lab   = c(TRUE, TRUE),
           main  = "Map of the Market",
           print = TRUE)
