## Set up
rm(list=ls())


#library(DataCombine)
library(reshape2)
library(dplyr)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
#library(time)

startdate="2000-01-01"
enddate="2017-10-01"
#Merge Data

df1 <- read.table("../data/Input/credit_gap.csv", header=TRUE, sep=",")
df1$date<-as.Date(df1$date)
min(as.Date((df1$date)))
names(df1)    

df2 <- read.table("../data/Input/crisis_h4.csv", header=TRUE, sep=",")
    # df3 <- read.table("HHCredit_GDP_gap.txt", header=TRUE, sep=",")
    # df4 <- read.table("NFECredit_GDP_gap.txt", header=TRUE, sep=",")
    # df5 <- read.table("GDP_gap.txt", header=TRUE, sep=",")
    # df6 <- read.table("HP_inc_gap.txt", header=TRUE, sep=",")
df2$date <- as.Date(df2$date)
#names2 <- names(df2)
#names2=sort(names2[-which(names2 == "date")])

#write.table(names2, "../Data/processed/countrylist.txt", sep=',', row.names=FALSE)

## Limit df1 year and countries here
Reduce(intersect, list(names(df1),names(df2)))
df1 = subset(df1, date>= as.Date(startdate) & date<=as.Date(enddate)) 
#df1 <- df1[names2]


df1 <- melt(df1, id=c("date"))
names(df1)<- c("date","id","credit_gap")
    
    
## Limit df2 year and countries here
df2 = subset(df2, date >= as.Date(startdate)) 
df2 <- melt(df2, id=c("date"))


names(df2)<- c("date","id","crisis")



# Merge the two df by ID and date
df <- merge(df1, df2, by=c("id","date"), all=TRUE)
#df$date <- as.Date(df$date)

dfh2<- df %>%
  group_by(id) %>%
  #mutate(gap= dplyr::lag(credit_gap, n=2)) #%>%
  na.omit()

  
  
  
dfh8<- df %>%
  group_by(id) %>%
  mutate(gap= dplyr::lag(credit_gap, n=8)) #%>%
  #na.omit()



library(dplyr)
df<- df %>%
  group_by(id) %>%
  mutate(gap_h1= dplyr::lag(credit_gap, n=1)) %>%
  mutate(gap_h2= dplyr::lag(credit_gap, n=2)) %>%
  mutate(gap_h3= dplyr::lag(credit_gap, n=3)) %>%
  mutate(gap_h4= dplyr::lag(credit_gap, n=4)) %>%
  mutate(gap_h5= dplyr::lag(credit_gap, n=5)) %>%
  mutate(gap_h6= dplyr::lag(credit_gap, n=6)) %>%
  mutate(gap_h7= dplyr::lag(credit_gap, n=7)) %>%
  mutate(gap_h8= dplyr::lag(credit_gap, n=8)) %>%
  mutate(gap_h9= dplyr::lag(credit_gap, n=9)) %>%
  mutate(gap_h10= dplyr::lag(credit_gap, n=10)) %>%
  mutate(gap_h11= dplyr::lag(credit_gap, n=11)) %>%
  mutate(gap_h12= dplyr::lag(credit_gap, n=12))



df <- df %>% group_by(id) %>% mutate(gap_h1 = stats::tlag(credit_gap, order_by =date, k =1))
       ## https://stackoverflow.com/questions/8910268/general-lag-in-time-series-panel-data                          
df<-df[with(df, order(id,date)), ]

library(plm)
df<-pdata.frame(df,index=c("id","date"))  
df<-transform(df, gaph1=plm::lag(credit_gap,k=1))   


library(xts)
library(tsbox)
df <- xts(df,order.by=as.Date(df$date))

credit_gap_h1 <- ts_lag(df$credit_gap, by =1)

# pglm Panel probit regression

library(pglm)
model1 <- pglm(crisis ~ credit_gap, df, family = "binomial",
                           model = "random", method = "bfgs")
summary(model1)


    # View(df)
    # df <- merge(df2, df3, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df4, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df5, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df6, by=c("ID","date"), all.x=TRUE)
    # df <- merge(df, df1, by=c("ID","date"), all.x=TRUE)
    # 
    # write.table(df, "MergedData-Raw.txt", sep=",")
    # 
    # #Read raw data
    # df1 <- read.table("MergedData-Raw.txt", header=TRUE, sep=",")
    # 
    # df1 <- na.omit(df) 
    # 
    # #table(df1$date)
    # #df2 <- df1["date">="1999-01-01"]
    # 
    # #Reorder data
    # df1 <- df1[order(df1$ID, df1$date),]
    # 
    # df1<-na.omit(df1)



# Test 2
library(collapse)
L(df, n=1, by = 'id', t='date', cols=4)