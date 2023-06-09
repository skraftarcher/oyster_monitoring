# script to calcualte oyster condition
source("scripts/install_packages_function.R")
source("scripts/pull_oyster_condition_data-EX.R")

# load packages
lp("tidyverse")
lp("lubridate")

# bring in data and organize data
oc<-read.csv(paste0("odata/oyster_condition_",Sys.Date(),".csv"))%>%
  mutate(shell.tin.weight=as.numeric(ifelse(shell.tin.weight=="-",0,shell.tin.weight)),
         tdw=tissue.dry.weight-tissue.tin.weight,
         sdw=shell.dry.weight-shell.tin.weight,
         sww=shell.wet.weight-shell.tin.weight)%>%
  group_by(date.collected,siteID,oyster.id)%>%
  summarize(whole.oyster.weight=sum(whole.oyster.weight),
            tdw=sum(tdw),
            sdw=sum(sdw),
            sww=sum(sww))%>%
  mutate(oc1=(tdw/(whole.oyster.weight-sww))*100,
         oc2=(tdw/(whole.oyster.weight-sdw))*100)%>%
  select(date=date.collected,siteID,oyster.id,oc1,oc2)%>%
  separate(oyster.id,into=c("site2","oID"),sep=-1)%>%
  select(-site2)

write.csv(oc,paste0("wdata/oyster_condition_",Sys.Date(),".csv"),row.names = FALSE)
