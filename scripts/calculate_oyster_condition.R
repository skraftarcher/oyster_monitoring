# script to calcualte oyster condition
source("scripts/install_packages_function.R")
source("scripts/pull_oyster_condition_data-EX.R")

# load packages
lp("tidyverse")
lp("lubridate")

# bring in data

oc<-read.csv(paste0("odata/oyster_condition_",Sys.Date(),".csv"))


# organize data
oc2<-oc%>%
  mutate(shell.tin.weight=as.numeric(ifelse(shell.tin.weight=="-",0,shell.tin.weight)),
         tdw=tissue.dry.weight-tissue.tin.weight,
         sdw=dry.shell.weight-shell.tin.weight,
         sww=wet.shell.weight-shell.tin.weight,
         oc1=(tdw/(whole.oyster.weight-sww))*100,
         oc2=(tdw/(whole.oyster.weight-sdw))*100)%>%
  select(date=date.collected,oyster.label,oc1,oc2)%>%
  separate(oyster.label,into=c("site","quadrat","ID"),sep="-")%>%
  separate(quadrat,into=c("extra","quadrat"),sep=-1)%>%
  select(-extra)%>%
  mutate(quadrat=as.numeric(quadrat),
         ID=as.numeric(quadrat))

write.csv(oc2,paste0("wdata/oyster_condition_",Sys.Date(),".csv"),row.names = FALSE)
