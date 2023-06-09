# script to generate a regression line between wet and dry weight for oyster tissue

# Stephanie Archer and Kay Schlacther 6/9/2023

# load data----
source("scripts/pull_oyster_condition_data-EX.R")

oys<-read.csv(paste0("odata/oyster_condition_",Sys.Date(),".csv"))%>%
  mutate(shell.tin.weight=as.numeric(ifelse(shell.tin.weight=="-",0,shell.tin.weight)),
         tdw=tissue.dry.weight-tissue.tin.weight,
         tww=tissue.wet.weight-tissue.tin.weight,)%>%
  group_by(date.collected,siteID,oyster.id)%>%
  summarize(tdw=sum(tdw),
            tww=sum(tww))


# now make a plot----
theme_set(theme_bw()+theme(panel.grid=element_blank()))
par(mfrow=c(2,2))


(p1<-ggplot(data=oys,#%>%filter(tww<70),
       aes(x=tww,y=tdw))+
  geom_point()+
  geom_smooth(method="lm"))

ggsave(plot=p1,"figures/oyster_tissue_regression.jpg",width=7,height=5)

# do regression----
oys.lm<-lm(tdw~0+tww,data=oys)
plot(oys.lm)
summary(oys.lm)

# fit new data----
# where you'd load Sam's tissue subsample data
# demonstration making a dataset

sam.dat<-data.frame(tww=rnorm(30,mean=.1,sd=.05))

(sam.fitted.dry<-predict(oys.lm,newdata=sam.dat))
