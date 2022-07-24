# Collect Data

## Set up
rm(list = ls())

#1. Parameter Setup
#https://www.bis.org/statistics/full_data_sets.htm
#----

# Libraries
library(dplyr)
library(ggplot2)
library(zoo)
#library(reshape2)
library(rstudioapi)
library(data.table)
library(xts)
library(tsbox)
library(rio)
library(stringr)
library(readxl)

enddate = "2017-10-01"

# create a temporary directory
td <- tempdir()
# create a temporary file
tf <- tempfile(tmpdir = td, fileext = ".zip")
# download file from internet into temporary location
download.file("https://www.bis.org/statistics/full_credit_gap_csv.zip", tf)
# list zip archive
file_names <- unzip(tf, list=TRUE)
# extract files from zip file
unzip(tf, exdir=td, overwrite=TRUE)
# use when zip file has only one file
data <- import(file.path(td, file_names$Name[1]))
# use when zip file has multiple files
#data_multiple <- lapply(file_names$Name, function(x) import(file.path(td, x)))
# delete the files and directories
rm(td)
rm(tf)

setwd(dirname(getActiveDocumentContext()$path))

latest_date = file_names$Date[1]

### filter reference: https://dplyr.tidyverse.org/reference/filter.html\
#filter(  optionA, 
#         optionB, 
#         optionC %in% c("a","b")) 
#             is also available

## Process data
rates_plot2 <- data %>%
  filter(.data[["Credit gap data type"]]
  == "A:Credit-to-GDP ratios (actual data)")
  #filter(grepl(clist2, BORROWERS_CTY))%>%

rates_plot3 <- data %>%
  filter(.data[["Credit gap data type"]] == "C:Credit-to-GDP gaps (actual-trend)")
#filter(grepl(clist2, BORROWERS_CTY))%>%

t_rates_plot2 <- transpose(rates_plot2)

# get row and colnames in order
colnames(t_rates_plot2) <- rownames(rates_plot2)
rownames(t_rates_plot2) <- colnames(rates_plot2)
colnames(t_rates_plot2) <- t_rates_plot2[2,] # changes col names to country id
#t_rates_plot2 <- t_rates_plot2[-c(1:2,4:11),]
t_rates_plot2 <- t_rates_plot2[-c(1:7),] # Removing other naming scheme rows
t_rates_plot2$date <- rownames(t_rates_plot2) #extract rownames -> column for date

dim(t_rates_plot2)
#t_rates_plot2 <- na.omit(t_rates_plot2)
#dim(t_rates_plot2)


## Gap data
# get row and colnames in order
t_rates_plot3 <- transpose(rates_plot3)

colnames(t_rates_plot3) <- rownames(rates_plot3)
rownames(t_rates_plot3) <- colnames(rates_plot3)
colnames(t_rates_plot3) <- t_rates_plot3[2,] # changes col names to country id
#t_rates_plot3 <- t_rates_plot3[-c(1:2,4:11),]
t_rates_plot3 <- t_rates_plot3[-c(1:7),]
t_rates_plot3$date <- rownames(t_rates_plot3)
df3 <- t_rates_plot3

df3$date <- as.Date(as.yearqtr(df3$date,           # Convert dates to quarterly
                              format = "%Y-Q%q"))


### data type transforming
df <- t_rates_plot2

df$date <- as.Date(as.yearqtr(df$date,           # Convert dates to quarterly
                              format = "%Y-Q%q"))
#df <- xts(df, order.by=df$date)
#df <- ts_ts(df)

## Filter out countries with data available from 1970:Q1 
df1 = subset(df, date >= as.Date('1970-01-01')) 
clist1 <- names(which(colSums(is.na(df1))>0))
#df1 <- select(df1,-clist1) # 21 countries remains (CA,AU,ZA does not have systemic crisis)
clist1 <- colnames(df1)
#clist1 <- clist1[-c(which(clist1=="ZA:South Africa"))]
df1 <- df[, clist1]


name11<- str_sub(names(df1[-ncol(df1)]), end=2)
name21<- str_sub(names(df1[-ncol(df1)]), start=4) 

name11<- c(name11,"date")

## Remove south-africa from calculation since no crisis data is available from ZA


## Filter out countries from 1970:Q1 onward
df$date <- as.Date(df$date)
#df2 = subset(df, date >= as.Date('1970-01-01')) 
df2 <- df
clist2 <- names(which(colSums(is.na(df2))>0))
#df2 <- select(df2,-clist2) 
#clist2 <- colnames(df2)
#clist2 <- clist1[-c(which(clist2=="ZA:South Africa"))]
#df2 <- df2[,clist2] # 20 countries
names(df2)


name1<- str_sub(names(df2[-ncol(df2)]), end=2)
name2<- str_sub(names(df2[-ncol(df2)]), start=4)


colnames(df2) <- c(name1,"date")
colnames(df2)[which(names(df2)=="GB")] <- "UK"
name1 <- colnames(df2)
## Gap data

# df3 <- df3[,c(clist2)] # 33 countries
# names(df3) <- c(name1,"date")
# colnames(df3)[which(names(df3)=="GB")] <- "UK"
# name1 <- names(df2)
# names(df3)


## Output data into data folder
q=1

for (q in 1:12)
{
  ## Crisis data
  #Import European data #2021:DEC (quarter level data)
  # https://www.esrb.europa.eu/pub/financial-crises/html/index.en.html
  # https://www.esrb.europa.eu/pub/fcdb/esrb.fcdb20220120.en.xlsx
  
  
  #rm(td)
  #rm(tf)
  # create a temporary directory
  #td <- tempdir()
  # create a temporary file
  #tf <- tempfile(tmpdir=td, fileext=".xlsx")
  # download file from internet into temporary location
  #download.file("https://www.esrb.europa.eu/pub/fcdb/esrb.fcdb20220120.en.xlsx", tf)
  # list zip archive
  #file_names <- unzip(tf, list=TRUE)
  # extract files from zip file
  #unzip(tf, exdir=td, overwrite=TRUE)
  # use when zip file has only one file
  tf <- "../Data/Input/esrb.fcdb20220120.en.xlsx"
  data1 <-read_excel(tf, sheet="Systemic crises")
  
  #data <- rio::import(tf)
  data <- data1[-c(1, (nrow(data1)-3):nrow(data1)),-c(6:10,12:ncol(data1))]
  ncountry=length(table(data$Country)) #number of countries in database
  names(data)[3]<-"Start_date"
  names(data)[4]<-"End_date"
  names(data)[5]<-"bnormal_date"
  names(data)[6]<-"import"
  
  importedcountry<- data[,c(1,6)] %>%
    group_by(Country) %>%
    summarize(import = paste(import, collapse =","))
  importedcountry<- importedcountry$Country[grepl("1", importedcountry$import) & !grepl("0|2", importedcountry$import)]
  
 
  data$Start_date <- as.Date(as.yearmon(data$Start_date,           # Convert dates to monthly
                                        format = "%Y-%m"))
  data$End_date <- as.Date(as.yearmon(data$End_date,           # Convert dates to monthly
                                      format = "%Y-%m"))
  
  data$bnormal_date <- as.Date(as.yearmon(data$bnormal_date,           # Convert dates to monthly
                                      format = "%Y-%m"))
  
  lubridate::quarter(data$Start_date) -> data$Start_quarter
  lubridate::year(data$Start_date) -> data$Start_year
  data$startdate <- paste(data$Start_year, data$Start_quarter, sep="-Q")
  data$startdate <- as.Date(as.yearqtr(data$startdate,           # Convert dates to quarterly
                                       format = "%Y-Q%q"))
  
  lubridate::quarter(data$End_date) -> data$End_quarter
  lubridate::year(data$End_date) -> data$End_year
  data$enddate <- paste(data$End_year, data$End_quarter, sep="-Q")
  data$enddate <- as.Date(as.yearqtr(data$enddate,           # Convert dates to quarterly
                                     format = "%Y-Q%q"))
  
  lubridate::quarter(data$bnormal_date) -> data$bnormal_quarter
  lubridate::year(data$bnormal_date) -> data$bnormal_year
  data$bnormaldate <- paste(data$bnormal_year, data$bnormal_quarter, sep="-Q")
  data$bnormaldate <- as.Date(as.yearqtr(data$bnormal_date,           # Convert dates to quarterly
                                     format = "%Y-Q%q"))
  data <- data[c("Country","Event","startdate","enddate","bnormaldate","import")]
  
  data1<-data
  data<-data[!grepl("1", data$import),] #remove imported crises episode
  data1<-data1[grepl("1", data1$import),] #tomark crisis events periods -> NA
  
    a<-table(data$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  ## Create a data frame of time series
  ### Assign 1st row to be country names
  ### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
  c_begindate_1 = as.yearqtr(min(data$startdate)) - 12/4
  
  V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
  m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
  names(m) <- a
  m$date <- V
  m$date <- as.Date(m$date)
  
  ##ym <- yearmon(2006) + 0:11/12   # months in 2006
  ##ym + 0.25 # one quarter later
  
  ### 1st event
  for (i in 1:nrow(data)){
    ai = data$Country[i]
    for (j in 1:length(V)){
      for(y in 1:12) {
        if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=NA}
      }
      if((as.yearqtr(m[["date"]][j])+q/4) == (as.yearqtr(data[["startdate"]][i]))){m[[ai]][j]=1}
      if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["bnormaldate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry
  
  a<-table(data1$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  
  #Ignore signal during imported crisis periods
  for (i in 1:nrow(data1)){
    ai = data1$Country[i]
    for (j in 1:length(V)){
      if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["bnormaldate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  
  m1 <- m
  
  name3 <- names(m)
  #name3 <- c(Reduce(intersect, list(name1,name3))) ## 11 countries
  
  #m1<-m1[name3]
  # 
  # use when zip file has multiple files
  #data_multiple <- lapply(file_names$Name, function(x) import(file.path(td, x)))
  # delete the files and directories
  
  
  rm(td)
  rm(tf)
  
  #Import IMF data #2017:Q4 (annual crisis)
  #https://www.imf.org/en/Publications/WP/Issues/2018/09/14/Systemic-Banking-Crises-Revisited-46232
  # https://www.imf.org/-/media/Files/Publications/WP/2018/datasets/wp18206.ashx
  
  tf <- "../Data/Input/SYSTEMIC BANKING CRISES DATABASE_2018.xlsx"
  data <-read_excel(tf, sheet="Crisis Resolution and Outcomes")
  
  data2 <- read_excel(tf, sheet="Additional Details", col_names=FALSE)
  data2 <- t(data2)
  data2 <- as.data.frame(data2)
  data2<-data2[,1:2]
  names(data2)<-data2[1,]
  data2 <- data2[-1,]
  data2<-na.omit(data2)
  library(janitor)
  data2[,2] <- convert_to_date(data2[,2],character_fun = lubridate::ymd,string_conversion_failure="warning")
  data2<-na.omit(data2)
  names(data2)<-c("Country","Start_date")

  data2<-data2%>% group_by(Country) %>% mutate(event = row_number(Country))
  
  
  ## Combine crisis data 
  ### with priority data overwrite given to European , more minutes data available to quarter level
  library(stringr)
  
  data[grepl('/', data$Country), ]$Country <- str_sub(data[grepl('/', data$Country), ]$Country, end=-4)
  data[grepl('/', data$End), ]$End <- str_sub(data[grepl('/', data$End), ]$End, end=-4)
  data = data[-nrow(data), -c(4:11)]
  
  a<-as.character(as.data.frame(table(data$Country))[,1])
  
  
  data$Start <- paste(data$Start, "-Q1", sep='')
  data$End <- paste(data$End, "-Q4", sep='')
  data$Start <- as.Date(as.yearqtr(data$Start,           # Convert dates to quarterly
                                   format = "%Y-Q%q"))
  data$End <- as.Date(as.yearqtr(data$End,           # Convert dates to quarterly
                                 format = "%Y-Q%q"))
  data <- na.omit(data)
  
  data<-data%>% group_by(Country) %>% mutate(event = row_number(Country))
  
  data2$Start_date <- as.Date(as.yearqtr(data2$Start_date))
  data2[which(data2$Country=="Dominican Republic"),1]="Dominican Rep"
  
  data3<- merge(data, data2, by=c("Country","event"), all=TRUE)
  

data4<-  data3 %>%
  group_by(Country) %>%
  mutate(lagstart = lag(Start_date)) 

data4<-  data4 %>%
    group_by(Country) %>%
    mutate(newstart2 = 
      case_when(as.yearqtr(Start_date)-as.yearqtr(Start) <= 4/4 
                ~ Start_date,
                as.yearqtr(lagstart)-as.yearqtr(Start) <= 4/4 
                ~ lagstart,
                is.na(as.yearqtr(Start_date)-as.yearqtr(Start))
                ~ Start,
                is.na(as.yearqtr(lagstart)-as.yearqtr(Start))
                ~ Start))

data4<-  data4 %>%
  mutate_at(
    vars("newstart2"), 
    funs(case_when(
      is.na(Start)~Start_date,
      TRUE ~ newstart2
    )))

data4<-  data4 %>%
  mutate_at(
    vars("End"), 
    funs(case_when(
      is.na(End)~as.Date(as.yearqtr(newstart2)+5),
      TRUE ~ End
    )))



data4 <- data4[c("Country","newstart2","End","event")]
names(data4)<- c("Country","startdate","enddate","event")
data4$startdate <- as.Date(data4$startdate)
data4$enddate <- as.Date(data4$enddate)


data <- data4
ncountry = length(table(data$Country))
c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4

data<-data[-which(data$Country=="Indonesia" & data$event == 1),] #imported crisis Asia 1997

data1 <-data4
data1<-data1[which(data1$Country=="Indonesia" & data1$event == 1),] #imported crisis Asia 1997
importedcountry = names(table(data1$Country))

V <- seq(as.Date(c_begindate_2), as.Date(enddate), by="quarters")

a<-table(data$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)
## Create a data frame of time series
### Assign 1st row to be country names
### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4

V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
names(m) <- a
m$date <- V
m$date <- as.Date(m$date)

##ym <- yearmon(2006) + 0:11/12   # months in 2006
##ym + 0.25 # one quarter later

### 1st event
for (i in 1:nrow(data)){
  ai = data$Country[i]
  for (j in 1:length(V)){
    for(y in 1:12) {
      if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=NA}
    }
    if((as.yearqtr(m[["date"]][j])+q/4) == (as.yearqtr(data[["startdate"]][i]))){m[[ai]][j]=1}
    if(m[["date"]][j] >= data[["startdate"]][i] & (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=NA} 
    if(m[["date"]][j] >= data[["startdate"]][i] & (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
  }
}

names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry

a<-table(data1$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)

#Ignore signal during imported crisis periods
for (i in 1:nrow(data1)){
  ai = data1$Country[i]
  for (j in 1:length(V)){
    if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=NA} 
    if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
  }
}

  m2<-m

  names(m2)[which(names(m2)=="China, Mainland")] = "China"
  name4 <- names(m2)
  additionallist = c("Australia","Canada","South Africa", "Hong Kong SAR", "Saudi Arabia", "Singapore","New Zealand")
  m2 <- cbind(m2,matrix(0,nrow(m2),length(additionallist)))
  
  name42 <- c(name4,additionallist)
  names(m2) <- name42
  # Israel have crisis before 1985
  ## Include Israel in analysis / (not enough credit data >1985)
  # Philippines credit data have been removed from BIS
  
name43<-sort(Reduce(intersect, list(name2,name42))) #27 - AT, BE, DE, DK , ES, FI, FR, UK, GR, HU, IE, IT, NL, NO, PT, SE (= 11 SW switzerland included in second data)

  # Use credit names to convert to abbreviation 2 letters

m2<-m2[c(name43,"date")]

name44 = rep("",length(name43))
for (i in 1:length(name43)){
  name44[i]=name1[which(name2==name43[i])]
} ## convert to 2 letter abbreviation

names(m2)<-c(name44,"date")
  
name51<-Reduce(intersect,(list(name3,name1))) ## EU crisis and credit
name52 <-Reduce(intersect,(list(name51,name44))) ## EU crisis and LV crisis

for (i in 1:length(name52)){
  name44<-name44[-which(name44==name52[i])]
} ## Remove EU crisis from LV crisis name list


  ## Combined and separate file for each countries
  ### Combine data for 70 onward
  ### 1985 onward
  m1 <- m1[name51] # EU crisis and credit
  m2 <- m2[name44] # not EU crisis, LV crisis and credit

  m <- cbind(m1, m2)
  name_m<-sort(names(m)[-which(names(m)=="date")])
  name_m<-c(name_m,"date")
  m<-m[name_m]
  #m <- c(m, as.data.frame(matrix(0,nrow(m),3)))
  #m <- as.data.frame(m)
  
  ### Export data
  
  m <- as.data.frame(m)
  m$date <- as.Date(m$date)
  
  filepath=sprintf("../Data/input/crisis_h%s.csv",q)
  write.table(m, filepath, sep=',', row.names=FALSE)
}


##### 1-12 horizon crisis matrix
horizonloop = matrix(NA, 4,3)
horizonloop[1,] = c(5,8,"58")
horizonloop[2,] = c(9,12,"912")
horizonloop[3,] = c(5,12,"512")
horizonloop[4,] = c(1,12,"112")
horizonloop<-as.data.frame(horizonloop)
horizonloop[,1]<-as.numeric(horizonloop[,1])
horizonloop[,2]<-as.numeric(horizonloop[,2])

#if((as.yearqtr(m[["date"]][j])+horizonstart/4) <= (as.yearqtr(data[["startdate"]][i]))
#   && (as.yearqtr(m[["date"]][j])+horizonend/4) >= (as.yearqtr(data[["startdate"]][i]))){m[[ai]][j]=1}


for (i in 1:nrow(horizonloop)){
  
  horizonstart = horizonloop[i,1]
  horizonend = horizonloop[i,2]
  horizonchar = horizonloop[i,3]
  
  tf <- "../Data/Input/esrb.fcdb20220120.en.xlsx"
  data1 <-read_excel(tf, sheet="Systemic crises")
  
  #data <- rio::import(tf)
  data <- data1[-c(1, (nrow(data1)-3):nrow(data1)),-c(6:10,12:ncol(data1))]
  ncountry=length(table(data$Country)) #number of countries in database
  names(data)[3]<-"Start_date"
  names(data)[4]<-"End_date"
  names(data)[5]<-"bnormal_date"
  names(data)[6]<-"import"
  
  importedcountry<- data[,c(1,6)] %>%
    group_by(Country) %>%
    summarize(import = paste(import, collapse =","))
  importedcountry<- importedcountry$Country[grepl("1", importedcountry$import) & !grepl("0|2", importedcountry$import)]
  
  
  data$Start_date <- as.Date(as.yearmon(data$Start_date,           # Convert dates to monthly
                                        format = "%Y-%m"))
  data$End_date <- as.Date(as.yearmon(data$End_date,           # Convert dates to monthly
                                      format = "%Y-%m"))
  
  data$bnormal_date <- as.Date(as.yearmon(data$bnormal_date,           # Convert dates to monthly
                                          format = "%Y-%m"))
  
  lubridate::quarter(data$Start_date) -> data$Start_quarter
  lubridate::year(data$Start_date) -> data$Start_year
  data$startdate <- paste(data$Start_year, data$Start_quarter, sep="-Q")
  data$startdate <- as.Date(as.yearqtr(data$startdate,           # Convert dates to quarterly
                                       format = "%Y-Q%q"))
  
  lubridate::quarter(data$End_date) -> data$End_quarter
  lubridate::year(data$End_date) -> data$End_year
  data$enddate <- paste(data$End_year, data$End_quarter, sep="-Q")
  data$enddate <- as.Date(as.yearqtr(data$enddate,           # Convert dates to quarterly
                                     format = "%Y-Q%q"))
  
  lubridate::quarter(data$bnormal_date) -> data$bnormal_quarter
  lubridate::year(data$bnormal_date) -> data$bnormal_year
  data$bnormaldate <- paste(data$bnormal_year, data$bnormal_quarter, sep="-Q")
  data$bnormaldate <- as.Date(as.yearqtr(data$bnormal_date,           # Convert dates to quarterly
                                         format = "%Y-Q%q"))
  data <- data[c("Country","Event","startdate","enddate","bnormaldate","import")]
  
  data1<-data
  data<-data[!grepl("1", data$import),] #remove imported crises episode
  data1<-data1[grepl("1", data1$import),] #tomark crisis events periods -> NA
  
  a<-table(data$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  ## Create a data frame of time series
  ### Assign 1st row to be country names
  ### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
  c_begindate_1 = as.yearqtr(min(data$startdate)) - 12/4
  
  V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
  m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
  names(m) <- a
  m$date <- V
  m$date <- as.Date(m$date)
  
  ##ym <- yearmon(2006) + 0:11/12   # months in 2006
  ##ym + 0.25 # one quarter later
  
  ### 1st event
  for (i in 1:nrow(data)){
    ai = data$Country[i]
    for (j in 1:length(V)){
      for(y in 1:12) {
        if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=NA}
      }
      if((as.yearqtr(m[["date"]][j])+horizonstart/4) <= (as.yearqtr(data[["startdate"]][i]))
         && (as.yearqtr(m[["date"]][j])+horizonend/4) >= (as.yearqtr(data[["startdate"]][i]))){m[[ai]][j]=1}
      if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["bnormaldate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry
  
  a<-table(data1$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  
  #Ignore signal during imported crisis periods
  for (i in 1:nrow(data1)){
    ai = data1$Country[i]
    for (j in 1:length(V)){
      if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["bnormaldate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  
  m1 <- m
  
  name3 <- names(m)
  #name3 <- c(Reduce(intersect, list(name1,name3))) ## 11 countries
  
  #m1<-m1[name3]
  # 
  # use when zip file has multiple files
  #data_multiple <- lapply(file_names$Name, function(x) import(file.path(td, x)))
  # delete the files and directories
  
  
  rm(td)
  rm(tf)
  
  #Import IMF data #2017:Q4 (annual crisis)
  #https://www.imf.org/en/Publications/WP/Issues/2018/09/14/Systemic-Banking-Crises-Revisited-46232
  # https://www.imf.org/-/media/Files/Publications/WP/2018/datasets/wp18206.ashx
  
  tf <- "../Data/Input/SYSTEMIC BANKING CRISES DATABASE_2018.xlsx"
  data <-read_excel(tf, sheet="Crisis Resolution and Outcomes")
  
  data2 <- read_excel(tf, sheet="Additional Details", col_names=FALSE)
  data2 <- t(data2)
  data2 <- as.data.frame(data2)
  data2<-data2[,1:2]
  names(data2)<-data2[1,]
  data2 <- data2[-1,]
  data2<-na.omit(data2)
  library(janitor)
  data2[,2] <- convert_to_date(data2[,2],character_fun = lubridate::ymd,string_conversion_failure="warning")
  data2<-na.omit(data2)
  names(data2)<-c("Country","Start_date")
  
  data2<-data2%>% group_by(Country) %>% mutate(event = row_number(Country))
  
  
  ## Combine crisis data 
  ### with priority data overwrite given to European , more minutes data available to quarter level
  library(stringr)
  
  data[grepl('/', data$Country), ]$Country <- str_sub(data[grepl('/', data$Country), ]$Country, end=-4)
  data[grepl('/', data$End), ]$End <- str_sub(data[grepl('/', data$End), ]$End, end=-4)
  data = data[-nrow(data), -c(4:11)]
  
  a<-as.character(as.data.frame(table(data$Country))[,1])
  
  
  data$Start <- paste(data$Start, "-Q1", sep='')
  data$End <- paste(data$End, "-Q4", sep='')
  data$Start <- as.Date(as.yearqtr(data$Start,           # Convert dates to quarterly
                                   format = "%Y-Q%q"))
  data$End <- as.Date(as.yearqtr(data$End,           # Convert dates to quarterly
                                 format = "%Y-Q%q"))
  data <- na.omit(data)
  
  data<-data%>% group_by(Country) %>% mutate(event = row_number(Country))
  
  data2$Start_date <- as.Date(as.yearqtr(data2$Start_date))
  data2[which(data2$Country=="Dominican Republic"),1]="Dominican Rep"
  
  data3<- merge(data, data2, by=c("Country","event"), all=TRUE)
  
  
  data4<-  data3 %>%
    group_by(Country) %>%
    mutate(lagstart = lag(Start_date)) 
  
  data4<-  data4 %>%
    group_by(Country) %>%
    mutate(newstart2 = 
             case_when(as.yearqtr(Start_date)-as.yearqtr(Start) <= 4/4 
                       ~ Start_date,
                       as.yearqtr(lagstart)-as.yearqtr(Start) <= 4/4 
                       ~ lagstart,
                       is.na(as.yearqtr(Start_date)-as.yearqtr(Start))
                       ~ Start,
                       is.na(as.yearqtr(lagstart)-as.yearqtr(Start))
                       ~ Start))
  
  data4<-  data4 %>%
    mutate_at(
      vars("newstart2"), 
      funs(case_when(
        is.na(Start)~Start_date,
        TRUE ~ newstart2
      )))
  
  data4<-  data4 %>%
    mutate_at(
      vars("End"), 
      funs(case_when(
        is.na(End)~as.Date(as.yearqtr(newstart2)+5),
        TRUE ~ End
      )))
  
  
  
  data4 <- data4[c("Country","newstart2","End","event")]
  names(data4)<- c("Country","startdate","enddate","event")
  data4$startdate <- as.Date(data4$startdate)
  data4$enddate <- as.Date(data4$enddate)
  
  
  data <- data4
  ncountry = length(table(data$Country))
  c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4
  
  data<-data[-which(data$Country=="Indonesia" & data$event == 1),] #imported crisis Asia 1997
  
  data1 <-data4
  data1<-data1[which(data1$Country=="Indonesia" & data1$event == 1),] #imported crisis Asia 1997
  importedcountry = names(table(data1$Country))
  
  V <- seq(as.Date(c_begindate_2), as.Date(enddate), by="quarters")
  
  a<-table(data$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  ## Create a data frame of time series
  ### Assign 1st row to be country names
  ### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
  c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4
  
  V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
  m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
  names(m) <- a
  m$date <- V
  m$date <- as.Date(m$date)
  
  ##ym <- yearmon(2006) + 0:11/12   # months in 2006
  ##ym + 0.25 # one quarter later
  
  ### 1st event
  for (i in 1:nrow(data)){
    ai = data$Country[i]
    for (j in 1:length(V)){
      for(y in 1:12) {
        if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=NA}
      }
      if((as.yearqtr(m[["date"]][j])+horizonstart/4) <= (as.yearqtr(data[["startdate"]][i]))
         && (as.yearqtr(m[["date"]][j])+horizonend/4) >= (as.yearqtr(data[["startdate"]][i]))){m[[ai]][j]=1}
      if(m[["date"]][j] >= data[["startdate"]][i] & (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data[["startdate"]][i] & (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry
  
  a<-table(data1$Country)
  a <- as.data.frame(a)[,1]
  a <- as.character(a)
  
  #Ignore signal during imported crisis periods
  for (i in 1:nrow(data1)){
    ai = data1$Country[i]
    for (j in 1:length(V)){
      if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=NA} 
      if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=NA} 
    }
  }
  
  m2<-m
  
  names(m2)[which(names(m2)=="China, Mainland")] = "China"
  name4 <- names(m2)
  additionallist = c("Australia","Canada","South Africa", "Hong Kong SAR", "Saudi Arabia", "Singapore","New Zealand")
  m2 <- cbind(m2,matrix(0,nrow(m2),length(additionallist)))
  
  name42 <- c(name4,additionallist)
  names(m2) <- name42
  # Israel have crisis before 1985
  ## Include Israel in analysis / (not enough credit data >1985)
  # Philippines credit data have been removed from BIS
  
  name43<-sort(Reduce(intersect, list(name2,name42))) #27 - AT, BE, DE, DK , ES, FI, FR, UK, GR, HU, IE, IT, NL, NO, PT, SE (= 11 SW switzerland included in second data)
  
  # Use credit names to convert to abbreviation 2 letters
  
  m2<-m2[c(name43,"date")]
  
  name44 = rep("",length(name43))
  for (i in 1:length(name43)){
    name44[i]=name1[which(name2==name43[i])]
  } ## convert to 2 letter abbreviation
  
  names(m2)<-c(name44,"date")
  
  name51<-Reduce(intersect,(list(name3,name1))) ## EU crisis and credit
  name52 <-Reduce(intersect,(list(name51,name44))) ## EU crisis and LV crisis
  
  for (i in 1:length(name52)){
    name44<-name44[-which(name44==name52[i])]
  } ## Remove EU crisis from LV crisis name list
  
  
  ## Combined and separate file for each countries
  ### Combine data for 70 onward
  ### 1985 onward
  m1 <- m1[name51] # EU crisis and credit
  m2 <- m2[name44] # not EU crisis, LV crisis and credit
  
  m <- cbind(m1, m2)
  name_m<-sort(names(m)[-which(names(m)=="date")])
  name_m<-c(name_m,"date")
  m<-m[name_m]
  #m <- c(m, as.data.frame(matrix(0,nrow(m),3)))
  #m <- as.data.frame(m)
  
  ### Export data
  
  m <- as.data.frame(m)
  m$date <- as.Date(m$date)
  
  filepath=sprintf("../Data/input/crisis_h%s.csv",horizonchar)
  write.table(m, filepath, sep=',', row.names=FALSE)
}


df2$AR[which(df2$AR==max(as.numeric(na.omit(df2$AR))))]<-35.5 #fix anomaly in data for Argentina
#summary(as.numeric(na.omit(df2$AR)))
write.table(df2, "../Data/input/credit_fullsample.csv", sep=',', row.names=FALSE)

df22<- read.csv("../Data/input/credit70.csv")
summary(df22)
#write.table(df3, "../Data/input/credit_gap.csv", sep=',', row.names=FALSE)




## Will have to remove Greece because of ongoing crisis -> 28 countries in final sample
## 20 countries in beginning sample 1970:Q1 forward for credit data 
#-> generate credit cycle component from 1985:Q1 onward
#-> generate credit cycle from 2000:Q1 onward


## Next step
### panel logistic regression





###No horizon, just crisis indicator-------------- 
### 

tf <- "../Data/Input/esrb.fcdb20220120.en.xlsx"
data1 <-read_excel(tf, sheet="Systemic crises")

#data <- rio::import(tf)
data <- data1[-c(1, (nrow(data1)-3):nrow(data1)),-c(6:10,12:ncol(data1))]
ncountry=length(table(data$Country)) #number of countries in database
names(data)[3]<-"Start_date"
names(data)[4]<-"End_date"
names(data)[5]<-"bnormal_date"
names(data)[6]<-"import"

importedcountry<- data[,c(1,6)] %>%
  group_by(Country) %>%
  summarize(import = paste(import, collapse =","))
importedcountry<- importedcountry$Country[grepl("1", importedcountry$import) & !grepl("0|2", importedcountry$import)]


data$Start_date <- as.Date(as.yearmon(data$Start_date,           # Convert dates to monthly
                                      format = "%Y-%m"))
data$End_date <- as.Date(as.yearmon(data$End_date,           # Convert dates to monthly
                                    format = "%Y-%m"))

data$bnormal_date <- as.Date(as.yearmon(data$bnormal_date,           # Convert dates to monthly
                                        format = "%Y-%m"))

lubridate::quarter(data$Start_date) -> data$Start_quarter
lubridate::year(data$Start_date) -> data$Start_year
data$startdate <- paste(data$Start_year, data$Start_quarter, sep="-Q")
data$startdate <- as.Date(as.yearqtr(data$startdate,           # Convert dates to quarterly
                                     format = "%Y-Q%q"))

lubridate::quarter(data$End_date) -> data$End_quarter
lubridate::year(data$End_date) -> data$End_year
data$enddate <- paste(data$End_year, data$End_quarter, sep="-Q")
data$enddate <- as.Date(as.yearqtr(data$enddate,           # Convert dates to quarterly
                                   format = "%Y-Q%q"))

lubridate::quarter(data$bnormal_date) -> data$bnormal_quarter
lubridate::year(data$bnormal_date) -> data$bnormal_year
data$bnormaldate <- paste(data$bnormal_year, data$bnormal_quarter, sep="-Q")
data$bnormaldate <- as.Date(as.yearqtr(data$bnormal_date,           # Convert dates to quarterly
                                       format = "%Y-Q%q"))
data <- data[c("Country","Event","startdate","enddate","bnormaldate","import")]

data1<-data
data<-data[!grepl("1", data$import),] #remove imported crises episode
data1<-data1[grepl("1", data1$import),] #tomark crisis events periods -> NA

a<-table(data$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)
## Create a data frame of time series
### Assign 1st row to be country names
### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
c_begindate_1 = as.yearqtr(min(data$startdate)) - 12/4

V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
names(m) <- a
m$date <- V
m$date <- as.Date(m$date)

##ym <- yearmon(2006) + 0:11/12   # months in 2006
##ym + 0.25 # one quarter later

### 1st event
for (i in 1:nrow(data)){
  ai = data$Country[i]
  for (j in 1:length(V)){
    for(y in 5:12) {
      if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=2}
    }
    for(y in 1:4) {
      if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=3}
    }
    if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["bnormaldate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=1} 
  }
}

names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry

a<-table(data1$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)

#Ignore signal during imported crisis periods
for (i in 1:nrow(data1)){
  ai = data1$Country[i]
  for (j in 1:length(V)){
    if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["bnormaldate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=1} 
  }
}


m1 <- m

name3 <- names(m)
#name3 <- c(Reduce(intersect, list(name1,name3))) ## 11 countries

#m1<-m1[name3]
# 
# use when zip file has multiple files
#data_multiple <- lapply(file_names$Name, function(x) import(file.path(td, x)))
# delete the files and directories


rm(td)
rm(tf)

#Import IMF data #2017:Q4 (annual crisis)
#https://www.imf.org/en/Publications/WP/Issues/2018/09/14/Systemic-Banking-Crises-Revisited-46232
# https://www.imf.org/-/media/Files/Publications/WP/2018/datasets/wp18206.ashx

tf <- "../Data/Input/SYSTEMIC BANKING CRISES DATABASE_2018.xlsx"
data <-read_excel(tf, sheet="Crisis Resolution and Outcomes")

data2 <- read_excel(tf, sheet="Additional Details", col_names=FALSE)
data2 <- t(data2)
data2 <- as.data.frame(data2)
data2<-data2[,1:2]
names(data2)<-data2[1,]
data2 <- data2[-1,]
data2<-na.omit(data2)
library(janitor)
data2[,2] <- convert_to_date(data2[,2],character_fun = lubridate::ymd,string_conversion_failure="warning")
data2<-na.omit(data2)
names(data2)<-c("Country","Start_date")

data2<-data2%>% group_by(Country) %>% mutate(event = row_number(Country))


## Combine crisis data 
### with priority data overwrite given to European , more minutes data available to quarter level
library(stringr)

data[grepl('/', data$Country), ]$Country <- str_sub(data[grepl('/', data$Country), ]$Country, end=-4)
data[grepl('/', data$End), ]$End <- str_sub(data[grepl('/', data$End), ]$End, end=-4)
data = data[-nrow(data), -c(4:11)]

a<-as.character(as.data.frame(table(data$Country))[,1])


data$Start <- paste(data$Start, "-Q1", sep='')
data$End <- paste(data$End, "-Q4", sep='')
data$Start <- as.Date(as.yearqtr(data$Start,           # Convert dates to quarterly
                                 format = "%Y-Q%q"))
data$End <- as.Date(as.yearqtr(data$End,           # Convert dates to quarterly
                               format = "%Y-Q%q"))
data <- na.omit(data)

data<-data%>% group_by(Country) %>% mutate(event = row_number(Country))

data2$Start_date <- as.Date(as.yearqtr(data2$Start_date))
data2[which(data2$Country=="Dominican Republic"),1]="Dominican Rep"

data3<- merge(data, data2, by=c("Country","event"), all=TRUE)


data4<-  data3 %>%
  group_by(Country) %>%
  mutate(lagstart = lag(Start_date)) 

data4<-  data4 %>%
  group_by(Country) %>%
  mutate(newstart2 = 
           case_when(as.yearqtr(Start_date)-as.yearqtr(Start) <= 4/4 
                     ~ Start_date,
                     as.yearqtr(lagstart)-as.yearqtr(Start) <= 4/4 
                     ~ lagstart,
                     is.na(as.yearqtr(Start_date)-as.yearqtr(Start))
                     ~ Start,
                     is.na(as.yearqtr(lagstart)-as.yearqtr(Start))
                     ~ Start))

data4<-  data4 %>%
  mutate_at(
    vars("newstart2"), 
    funs(case_when(
      is.na(Start)~Start_date,
      TRUE ~ newstart2
    )))

data4<-  data4 %>%
  mutate_at(
    vars("End"), 
    funs(case_when(
      is.na(End)~as.Date(as.yearqtr(newstart2)+5),
      TRUE ~ End
    )))



data4 <- data4[c("Country","newstart2","End","event")]
names(data4)<- c("Country","startdate","enddate","event")
data4$startdate <- as.Date(data4$startdate)
data4$enddate <- as.Date(data4$enddate)


data <- data4
ncountry = length(table(data$Country))
c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4

data<-data[-which(data$Country=="Indonesia" & data$event == 1),] #imported crisis Asia 1997

data1 <-data4
data1<-data1[which(data1$Country=="Indonesia" & data1$event == 1),] #imported crisis Asia 1997
importedcountry = names(table(data1$Country))

V <- seq(as.Date(c_begindate_2), as.Date(enddate), by="quarters")

a<-table(data$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)
## Create a data frame of time series
### Assign 1st row to be country names
### Length of data -> 1973:Q4->2017:Q4 132 qtrs (33 yrs) x 28 countries
c_begindate_2 = as.yearqtr(min(data$startdate)) - 12/4

V <- seq(as.Date(c_begindate_1), as.Date(enddate), by="quarters")
m <- as.data.frame(matrix(0, ncol=ncountry, nrow =length(V)))
names(m) <- a
m$date <- V
m$date <- as.Date(m$date)

##ym <- yearmon(2006) + 0:11/12   # months in 2006
##ym + 0.25 # one quarter later

### 1st event
for (i in 1:nrow(data)){
  ai = data$Country[i]
  for (j in 1:length(V)){
    for(y in 5:12) {
      if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=2}
    }
    for(y in 1:4) {
      if((as.yearqtr(m[["date"]][j])+y/4) == (as.yearqtr(data[["startdate"]][i]))) {m[[ai]][j]=3}
    }
    if(m[["date"]][j] >= data[["startdate"]][i] && (m[["date"]][j] <= data[["enddate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data[["startdate"]][i])+8/4))){m[[ai]][j]=1} 
  }
}

names(m)[(ncol(m)-length(importedcountry)+1-1):(ncol(m)-1)]<-importedcountry

a<-table(data1$Country)
a <- as.data.frame(a)[,1]
a <- as.character(a)

#Ignore signal during imported crisis periods
for (i in 1:nrow(data1)){
  ai = data1$Country[i]
  for (j in 1:length(V)){
    if(m[["date"]][j] >= data1[["startdate"]][i] && (m[["date"]][j] <= data1[["enddate"]][i])){m[[ai]][j]=1} 
    if(m[["date"]][j] >= data1[["startdate"]][i] && (as.yearqtr(m[["date"]][j]) <= (as.yearqtr(data1[["startdate"]][i])+8/4))){m[[ai]][j]=1} 
  }
}

m2<-m

names(m2)[which(names(m2)=="China, Mainland")] = "China"
name4 <- names(m2)
additionallist = c("Australia","Canada","South Africa", "Hong Kong SAR", "Saudi Arabia", "Singapore","New Zealand")
m2 <- cbind(m2,matrix(0,nrow(m2),length(additionallist)))

name42 <- c(name4,additionallist)
names(m2) <- name42
# Israel have crisis before 1985
## Include Israel in analysis / (not enough credit data >1985)
# Philippines credit data have been removed from BIS

name43<-sort(Reduce(intersect, list(name2,name42))) #27 - AT, BE, DE, DK , ES, FI, FR, UK, GR, HU, IE, IT, NL, NO, PT, SE (= 11 SW switzerland included in second data)

# Use credit names to convert to abbreviation 2 letters

m2<-m2[c(name43,"date")]

name44 = rep("",length(name43))
for (i in 1:length(name43)){
  name44[i]=name1[which(name2==name43[i])]
} ## convert to 2 letter abbreviation

names(m2)<-c(name44,"date")

name51<-Reduce(intersect,(list(name3,name1))) ## EU crisis and credit
name52 <-Reduce(intersect,(list(name51,name44))) ## EU crisis and LV crisis

for (i in 1:length(name52)){
  name44<-name44[-which(name44==name52[i])]
} ## Remove EU crisis from LV crisis name list


## Combined and separate file for each countries
### Combine data for 70 onward
### 1985 onward
m1 <- m1[name51] # EU crisis and credit
m2 <- m2[name44] # not EU crisis, LV crisis and credit

m <- cbind(m1, m2)
name_m<-sort(names(m)[-which(names(m)=="date")])
name_m<-c(name_m,"date")
m<-m[name_m]
#m <- c(m, as.data.frame(matrix(0,nrow(m),3)))
#m <- as.data.frame(m)

### Export data

m <- as.data.frame(m)
m$date <- as.Date(m$date)

filepath="../Data/input/crisis_indicator.csv"
write.table(m, filepath, sep=',', row.names=FALSE)