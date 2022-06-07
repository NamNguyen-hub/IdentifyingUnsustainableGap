library(rstudioapi)

setwd(dirname(getActiveDocumentContext()$path))
getwd()

#bookdown::render_book('index.Rmd', "bookdown::beamer_presentation2", new_session = T)



options(kableExtra.latex.load_packages = FALSE)
options(knitr.table.format = "pandoc")
library('kableExtra')
library(dplyr)
library(knitr)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
getwd()

filepath='../Data/Output/Modelselection_512.csv'
df<-read.csv(filepath, sep = ",", header=TRUE)

#rownames(df) <- df[,1]
name1<- df[,1]
name1<- gsub("_", ".", name1)
name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
df[,1]<-name1

#df<-df[,-1]
df<-df[-c(27:nrow(df)),-c(10:ncol(df))]
#df<-df[-2,]

#colnames(df) <- c("Median", "10pct", "90pct", "Median", "10pct", "90pct", "Median", "10pct", "90pct")

#options(knitr.kable.NA = '')

#df = df %>% mutate_if(is.numeric, format, digits=4)

#kbl(data.frame(x=rnorm(10), y=rnorm(10), x= rnorm(10)), digits = c(1, 4, 4))

kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), escape=FALSE, linesep=c("","", "", "", "\\addlinespace")
      , row.names = FALSE) %>%
  kable_paper("striped") %>%
  #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
  #footnote(general="UK Bayesian regression results") %>%
  kable_styling(latex_options="scale_down") %>%
  column_spec(5, bold = TRUE) %>% #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0))
  gsub(".(begin|end){table.*}", "", ., perl = TRUE)%>%
  gsub(".centering", "", ., perl = TRUE)
  
# 
# filepath='../Data/Output/Modelselection_512.csv'
# df<-read.csv(filepath, sep = ",", header=TRUE)
# # 
# # 
# # filepath='../Data/Output/052219_Thu_BIC_unrestricted/Modelselection_512 copy.csv'
# # df<-read.csv(filepath, sep = ",", header=TRUE)
# 
# #rownames(df) <- df[,1]
# name1<- df[,1]
# name1<- gsub("_", ".", name1)
# name1[which(name1=="c.hp400k")]<-"BIS Basel gap"
# df[,1]<-name1
# 
# #df<-df[,-1]
# 
# df<-df[-c(13:17, 31:nrow(df)),-c(10:ncol(df))]
# #colnames(df) <- c("Median", "10pct", "90pct", "Median", "10pct", "90pct", "Median", "10pct", "90pct")
# 
# #options(knitr.kable.NA = '')
# 
# #df = df %>% mutate_if(is.numeric, format, digits=4)
# 
# #kbl(data.frame(x=rnorm(10), y=rnorm(10), x= rnorm(10)), digits = c(1, 4, 4))
# 
# kbl(df, "latex", booktabs = T, digits = c(4, 4, 4, 4, 4, 4, 4, 4), caption ='Variable selection', escape=FALSE, linesep=c("","", "", "", "\\addlinespace")) %>%
#   kable_paper("striped") %>%
#   #add_header_above(c("Parameters" = 1, "VAR2" = 3, "VAR2 1-cross lag" = 3, "VAR2 2-cross lags" = 3)) %>%
#   #footnote(general="UK Bayesian regression results") %>%
#   kable_styling(latex_options="scale_down") %>%
#   column_spec(6, bold = TRUE) %>% #c(0,0,1,0,0,0,1,0,0,0,0,0,0,0,0)) 
#   row_spec(c(2,which(df$Cycle=="BIS Basel gap")), bold=TRUE)


library(zoo)
library(ggplot2)
library(reshape2)


#US
crisis.start=(t(as.data.frame(c("1988-01-01", "2007-07-01"))))
crisis.end=(t(as.data.frame(c("1990-10-01", "2011-10-01"))))


#data.end=as.Date(t(as.data.frame(c(""))))

cris=data.frame()
cris = rbind(cris,t(crisis.start))
cris = cbind(cris,t(crisis.end))
names(cris) <- c('crisis.start','crisis.end')
cris$crisis.start <- as.Date(cris$crisis.start)
cris$crisis.end <- as.Date(cris$crisis.end)

cris$crisis.pre14=as.Date(as.yearqtr(cris$crisis.start)-1)
cris$crisis.pre512=as.Date(as.yearqtr(cris$crisis.start)-3)

enddatadate = as.Date("2017-10-01")

# crisis_shade<-geom_rect(data=cris, inherit.aes=F, 
#                      aes(xmin=crisis.start, xmax=crisis.end, ymin=-Inf, ymax=+Inf), 
#                      fill="darkgrey", alpha=0.5)
# pre14.crisis_shade<-geom_rect(data=cris, inherit.aes=F, 
#                         aes(xmin=crisis.pre14, xmax=crisis.start, ymin=-Inf, ymax=+Inf), 
#                         fill="darkgrey", alpha=0.5)
# pre512.crisis_shade<-geom_rect(data=cris, inherit.aes=F, 
#                               aes(xmin=crisis.pre512, xmax=crisis.pre14, ymin=-Inf, ymax=+Inf), 
#                               fill="lightcoral", alpha=0.5)

filepath='../Data/Output/crisis_weightedcycle_fullsample.csv'
df<-read.csv(filepath, sep = ",", header=TRUE)
df$date<- as.Date(df$date)

df<-df %>%
  subset(ID=='US')
df<-df[,c("date","c.hp400k","weightedcycle")]
names(df)<-c("date","BIS Basel Gap", "weighted gap")
df1<-melt(df,id.vars=c("date"))

df1$date<-as.Date(df1$date)
rects <- data.frame(ystart = c(cris$crisis.pre512[1],cris$crisis.start[1],cris$crisis.pre512[2],cris$crisis.start[2],enddatadate), yend = c(cris$crisis.pre14[1],cris$crisis.end[1],cris$crisis.pre14[2],cris$crisis.end[2],max(df1$date)), periods = c("1.pre-crisis","2.systemic-crisis","1.pre-crisis","2.systemic-crisis","3.end-of-crisis-data"))
fillss = c("lightcoral","darkgrey","black")
ggplot() +
  geom_rect(data = rects, aes(ymin = -Inf, ymax = Inf, xmin = ystart, xmax = yend, fill=periods), alpha = 0.3) +
  scale_fill_manual(values=fillss)+
  geom_line(data=df1, aes(x=date, y=value, color=variable))+
  coord_cartesian(ylim = c(min(df1$value), max(df1$value))) +
  theme(legend.position = "bottom") +
  theme_light() +
  theme(panel.grid = element_blank()) +
  # geom_hline(aes(yintercept= 3.06, linetype = "BIS gap = 3.06"), colour= 'lightsalmon') +
  # geom_hline(aes(yintercept= 2.92, linetype = "weighted gap  = 2.92"), colour= 'mediumturquoise') +
  # scale_linetype_manual(name = "threshold", values = c(2,2),
  #                       guide = guide_legend(override.aes = list(color = c("lightsalmon","mediumturquoise"))))+
  geom_hline(aes(yintercept= 3, linetype = "optimized threshold  = 3.00"), colour= 'blue') +
  scale_linetype_manual(name = "threshold", values = c(2),
                        guide = guide_legend(override.aes = list(color = c("blue"))))+
  
  labs(x = NULL, y = NULL,
       title = sprintf("Credit gap and systemic crisis: US"))
ggsave("../Data/Output/Graphs/Weighted_credit_gap_US.pdf", width=8, height=5)


# 
# dd <- structure(list(xmin = structure(c(11382, 13848), class = "Date"), 
#                      xmax = structure(c(11656, 14425), class = "Date"), ymin = c(-Inf, 
# 
#                                                                                                                                                                   -Inf), ymax = c(Inf, Inf), fill = c("a", "a")), .Names = c("xmin", 
#                                                                                                                                             "xmax", "ymin", "ymax", "fill"), row.names = 1:2, class = "data.frame")
# ggplot() + geom_rect(data=dd, aes(xmin=xmin, xmax=xmax, 
#                                   ymin=ymin, ymax=ymax, fill=fill), alpha=0.2) + 
#   geom_line(data=values.melted, aes(x=Date, y=value, color=Series), 
#             size=2) + labs(x= "Date", y = "Case-Shiller Index Value") + 
#   scale_fill_manual(name = "", values="black", label="US Recessions")
# 
# ggplot() + 
#   geom_rect(aes(xmin=c(as.Date("2001-03-01"),as.Date("2007-12-01")), 
#                 xmax=c(as.Date("2001-11-30"),as.Date("2009-06-30")),
#                 ymin=c(-Inf, -Inf), ymax=c(Inf, Inf),
#                 fill = "US Recessions"),alpha=0.2) +
#   scale_fill_manual("", breaks = "US Recessions", values ="black")+
#   geom_line(data=values.melted, aes(x=Date, y=value, color=Series), size=2) + 
#   labs(x= "Date", y="Case-Shiller Index Value")
# 
# 
# 
# values.melted<-structure(list(Date = structure(c(10957, 11048, 11139, 11231,  11323, 11413, 11504, 11596, 11688, 11778, 11869, 11961, 12053,     12143, 12234, 12326, 12418, 12509, 12600, 12692, 12784, 12874,     12965, 13057, 13149, 13239, 13330, 13422, 13514, 13604, 13695,     13787, 13879, 13970, 14061, 14153, 14245, 14335, 14426, 14518,     14610, 14700, 14791, 14883, 14975, 15065, 15156, 15248, 15340,     15431, 15522, 15614, 15706, 10957, 11048, 11139, 11231, 11323, 
#                                   11413, 11504, 11596, 11688, 11778, 11869, 11961, 12053, 12143,     12234, 12326, 12418, 12509, 12600, 12692, 12784, 12874, 12965,     13057, 13149, 13239, 13330, 13422, 13514, 13604, 13695, 13787,     13879, 13970, 14061, 14153, 14245, 14335, 14426, 14518, 14610,     14700, 14791, 14883, 14975, 15065, 15156, 15248, 15340, 15431,    15522, 15614, 15706), class = "Date"), 
#                Series = structure(c(1L,     1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,     1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,    1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,     1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,2L, 2L, 2L, 2L, 2L,     2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,     2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,     2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), 
#                                   .Label = c("US Composite",    "Atlanta"), class = "factor"),
#                value = c(100.78, 103.42, 105.68,     108.07, 110.1, 112.36, 114.8, 116.38, 118.87, 121.93, 125.38,     128.72, 131.44, 133.9, 137.57, 142.43, 147.39, 152.61, 157.43,    163.17, 170.77, 176.33, 181.47, 187.06, 190.99, 189.46, 185.93,     186.47, 187.91, 182.52, 177.35, 170.78, 162.82, 155.1, 147.79,     139.51, 132.6, 132.16, 134.71, 136.24, 136.03, 136.89, 132.64,     131.32, 129.72, 129.22, 128.02, 126.55, 128.12, 131.2, 132.65,     135.8, 141.15, 100.37, 102.69, 104.31, 105.42, 107.06, 108.34,     109.67, 111.05, 111.66, 112.75, 113.66, 114.6, 115.65, 116.57,     117.03, 118.03, 119.3, 120.83, 121.29, 122.72, 124.64, 126.97,     127.76, 128.85, 131.71, 132.92, 133.14, 133.7, 134.98, 136.11,
#                          134.09, 132.67, 129.7, 125.62, 121.91, 118.67, 111.48, 107.36,     106.99, 109.15, 109.35, 107.73, 106.4, 102.51, 102.69, 103.82,     100.76, 90.63, 87.55, 86.12, 90.59, 95.05, 99.4)), .Names = c("Date",  "Series", "value"), row.names = c(NA, -106L), class = "data.frame")
# 
# 
# ggplot() + 
#   geom_rect(aes(xmin=c(as.Date("2001-03-01"),as.Date("2007-12-01")), 
#                 xmax=c(as.Date("2001-11-30"),as.Date("2009-06-30")),
#                 ymin=c(-Inf, -Inf), ymax=c(Inf, Inf),
#                 fill = "US Recessions"),alpha=0.2) +
#   scale_fill_manual("", breaks = "US Recessions", values ="black")+
#   geom_line(data=values.melted, aes(x=Date, y=value, color=Series), size=2) + 
#   labs(x= "Date", y="Case-Shiller Index Value")
# 
# scale_fill_manual("", breaks = "Systemic Crisis", values ="black")
# 
# ggplot() + 
#   geom_rect(data=cris, inherit.aes=F, 
#             aes(xmin=crisis.start, xmax=crisis.end, ymin=c(-Inf, -Inf), ymax=c(Inf, Inf), 
#             fill="US Recessions"), alpha=0.5) +
#   scale_fill_manual("", breaks = "US Recessions", values ="black")+
#   geom_line(data=df1, aes(x=date, y=value, color=variable), size=2) + 
#   labs(x= "Date", y="Credit gap")
# 

# crisis.start=(t(as.data.frame(c("1988-01-01", "2007-07-01"))))
# crisis.end=(t(as.data.frame(c("1990-10-01", "2011-10-01"))))

library(ggplot2)
library(reshape2)
library(dplyr)
library(zoo)
## UK plot
filepath='../Data/Output/crisis_weightedcycle_fullsample.csv'
df<-read.csv(filepath, sep = ",", header=TRUE)
df$date<- as.Date(df$date)

df<-df %>%
  subset(ID=='UK')
df<-df[,c("date","c.hp400k","weightedcycle")]
names(df)<-c("date","BIS Basel Gap", "weighted gap")
df1<-melt(df,id.vars=c("date"))
crisis.start=(t(as.data.frame(c("1973-10-01","1991-07-01", "2007-07-01"))))
crisis.end=(t(as.data.frame(c("1977-07-01","1994-04-01", "2014-06-01"))))

cris=data.frame()
cris = rbind(cris,t(crisis.start))
cris = cbind(cris,t(crisis.end))
names(cris) <- c('crisis.start','crisis.end')
cris$crisis.start <- as.Date(cris$crisis.start)
cris$crisis.end <- as.Date(cris$crisis.end)
cris$crisis.pre14=as.Date(as.yearqtr(cris$crisis.start)-1)
cris$crisis.pre512=as.Date(as.yearqtr(cris$crisis.start)-3)
enddatadate = as.Date("2017-10-01")

rects <- data.frame(ystart = c(cris$crisis.pre512[1],cris$crisis.start[1],cris$crisis.pre512[2],cris$crisis.start[2],cris$crisis.pre512[3],cris$crisis.start[3],enddatadate),
                    yend = c(cris$crisis.pre14[1],cris$crisis.end[1],cris$crisis.pre14[2],cris$crisis.end[2],cris$crisis.pre14[3],cris$crisis.end[3],max(df1$date))
                    , periods = c("1.pre-crisis","2.systemic-crisis","1.pre-crisis","2.systemic-crisis","1.pre-crisis","2.systemic-crisis","3.end-of-crisis-data"))
fills = c("lightcoral","darkgrey","black")

ggplot() +
  geom_rect(data = rects, aes(ymin = -Inf, ymax = Inf, xmin = ystart, xmax = yend, fill=periods), alpha = 0.3) +
  scale_fill_manual(values=fills)+
  geom_line(data=df1, aes(x=date, y=value, color=variable))+
  coord_cartesian(ylim = c(min(df1$value), max(df1$value))) +
  theme(legend.position = "bottom") +
  theme_light() +
  theme(panel.grid = element_blank()) +
  # geom_hline(aes(yintercept= 3.06, linetype = "NRW limit"), colour= 'red') +
  # geom_hline(aes(yintercept= 0.6, linetype = "Geochemical atlas limit"), colour= 'blue') +
  # scale_linetype_manual(name = "limit", values = c(2, 2),
  #                       guide = guide_legend(override.aes = list(color = c("blue", "red"))))+
  #geom_hline(aes(yintercept= 3.06, linetype = "BIS gap = 3.06"), colour= 'lightsalmon') +
  #geom_hline(aes(yintercept= 2.92, linetype = "weighted gap  = 2.92"), colour= 'mediumturquoise') +
  #      scale_linetype_manual(name = "threshold", values = c(2,2),
  #                      guide = guide_legend(override.aes = list(color = c("lightsalmon","mediumturquoise"))))+
  geom_hline(aes(yintercept= 3, linetype = "optimized threshold  = 3.00"), colour= 'blue') +
        scale_linetype_manual(name = "threshold", values = c(2),
                        guide = guide_legend(override.aes = list(color = c("blue"))))+
  labs(x = NULL, y = NULL,
       title = sprintf("Credit gap and systemic crisis: UK"))
ggsave("../Data/Output/Graphs/Weighted_credit_gap_UK.pdf", width=8, height=5)


# 
# df1$date<-as.Date(df1$date)
# rects <- data.frame(ystart = c(cris$crisis.pre512[1],cris$crisis.start[1],cris$crisis.pre512[2],cris$crisis.start[2],enddatadate), yend = c(cris$crisis.pre14[1],cris$crisis.end[1],cris$crisis.pre14[2],cris$crisis.end[2],max(df1$date)), periods = c("1.pre-crisis","2.systemic-crisis","1.pre-crisis","2.systemic-crisis","3.end-of-crisis-data"))
# fillss = c("lightcoral","darkgrey","black")
# p<-ggplot() +
#   geom_rect(data = rects, aes(ymin = -Inf, ymax = Inf, xmin = ystart, xmax = yend, fill=periods), alpha = 0.3) +
#   scale_fill_manual(values=fillss)+
#   geom_line(data=df1, aes(x=date, y=value, color=variable))+
#   coord_cartesian(ylim = c(-15, 15)) +
#   theme(legend.position = "bottom") +
#   theme_light() +
#   theme(panel.grid = element_blank()) +
#   geom_hline(aes(yintercept= 5.5, linetype = "Optimized threshold = 5.5"), colour= 'blue') +
#   scale_linetype_manual(name = "threshold", values = c(2),
#                         guide = guide_legend(override.aes = list(color = c("blue"))))+
#     labs(x = NULL, y = NULL,
#        title = sprintf("Credit gap and systemic crisis: US"))
# ggsave("../Data/Output/Graphs/Weighted_credit_gap_US.pdf", width=8, height=5)


