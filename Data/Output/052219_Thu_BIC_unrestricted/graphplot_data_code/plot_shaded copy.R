library(ggplot2)
library(reshape2)
library(dplyr)
library(zoo)
## UK plot
filepath='crisis_weightedcycle_fullsample.csv'
df<-read.csv(filepath, sep = ",", header=TRUE)
df$date<- as.Date(df$date)

df<-df %>%
  subset(ID=='UK')
df<-df[,c("date","c.hp400k1","weightedcycle")]
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
  coord_cartesian(ylim = c(-28, 22)) +
  theme(legend.position = "bottom") +
  theme_light() +
  theme(panel.grid = element_blank()) +
  geom_hline(aes(yintercept= 5.5, linetype = "Optimized threshold = 5.5"), colour= 'blue') +
  scale_linetype_manual(name = "threshold", values = c(2),
                        guide = guide_legend(override.aes = list(color = c("blue"))))+
  labs(x = NULL, y = NULL,
       title = sprintf("Credit gap and systemic crisis: UK"))
ggsave("../Data/Output/Graphs/Weighted_credit_gap_UK.pdf", width=8, height=5)
