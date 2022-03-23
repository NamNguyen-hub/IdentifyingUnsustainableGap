library(miceadds)

mod2 <- miceadds::glm.cluster(data=df, formula=crisis ~ credit_gap,
                              cluster="id", family="binomial")
summary(mod2)
plot(x=df$credit_gap, y=mod2$glm_res$fitted.values)
plot(mod2$glm_res$residuals, df$credit_gap)
plot(x=df$credit_gap, y=df$crisis)
  lines(x=df$credit_gap, y=mod2$glm_res$fitted.values, type='p')
# library(plm)
# library(pglm)
# library(stargazer)
# data("UnionWage", package = "pglm")
# 
# ## Identification
# ### Index = 'id' by default
# 
# anb2 <- pglm(union ~ wage + exper + rural, UnionWage, family = "binomial",
#              model = "random", method = "bfgs")
# 
# # A "fake" model
# anb0 <- plm(union ~ wage + exper + rural, UnionWage, family = "binomial",
#             model = "random", method = "bfgs")
# 
# tstats <- summary(anb2)$estimate[,3][-5]
# pvs <- summary(anb2)$estimate[,4][-5]
# SEs <- summary(anb2)$estimate[,2][-5]
# coefs <- summary(anb2)$estimate[,1][-5]
# 
# stargazer(anb0, type="text", coef=list(coefs), se=list(SEs),
#           p = list(pvs), omit.stat="all")
# 
# ## Test 2

#Merge Data
library("DataCombine")
library(dplyr)

#Merge Data

setwd("D:/GitHub/HPCredit/Data Collection")

df1 <- read.table("FCdummy.txt", header=TRUE, sep=",")
as.Date(df1$date)
min(as.Date((df1$date))
    
    df2 <- read.table("PrCredit.txt", header=TRUE, sep=",")
    df3 <- read.table("HHCredit_GDP_gap.txt", header=TRUE, sep=",")
    df4 <- read.table("NFECredit_GDP_gap.txt", header=TRUE, sep=",")
    df5 <- read.table("GDP_gap.txt", header=TRUE, sep=",")
    df6 <- read.table("HP_inc_gap.txt", header=TRUE, sep=",")
    
    #df <- merge(df1, df2, by=c("ID","date"), all=TRUE)
    
    View(df)
    df <- merge(df2, df3, by=c("ID","date"), all.x=TRUE)
    df <- merge(df, df4, by=c("ID","date"), all.x=TRUE)
    df <- merge(df, df5, by=c("ID","date"), all.x=TRUE)
    df <- merge(df, df6, by=c("ID","date"), all.x=TRUE)
    df <- merge(df, df1, by=c("ID","date"), all.x=TRUE)
    
    write.table(df, "MergedData-Raw.txt", sep=",")
    
    #Read raw data
    df1 <- read.table("MergedData-Raw.txt", header=TRUE, sep=",")
    
    df1 <- na.omit(df) 
    
    #table(df1$date)
    #df2 <- df1["date">="1999-01-01"]
    
    #Reorder data
    df1 <- df1[order(df1$ID, df1$date),]
    
    df1<-na.omit(df1)
    
    
    
    #Running Probit model
    
    myprobit <- glm(FCdummy ~ PrCredit + HHCredit_GDP_gap + NFECredit_GDP_gap + GDP_gap + HP_inc_gap, family = binomial(link = "probit"), 
                    data = df1)
    
    ## model summary
    summary(myprobit)
    
    #BE DE DK ES FI FR GB IT JP KR NL NO US 13 countries
    
    
    #List earliest date by ID
    df6$date = as.Date(df6$date)
    
    df6 %>% 
      group_by(ID) %>%
      filter(date == min(date))
    
    
