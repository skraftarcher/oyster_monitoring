# script to organize oyster abundance data
source("scripts/install_packages_function.R")
source("scripts/pull_oyster_abundance_data-EX.R")

# load packages

lp("lubridate")

# bring in data and organize data

oa<-read.csv(paste0("odata/oyster_abundance_",Sys.Date(),".csv"))%>%
  mutate(barnical.rank=as.numeric(ifelse(barnical.rank=="-",NA,barnical.rank)),
         volume.with.hash.and.live..ml.=as.numeric(ifelse(volume.with.hash.and.live..ml.=="-",NA,volume.with.hash.and.live..ml.)),
         b2.start.volume..ml.=as.numeric(ifelse(b2.start.volume..ml.=="-",NA,b2.start.volume..ml.)),
         b2.volume.with.hash..ml.=as.numeric(ifelse(b2.volume.with.hash..ml.=="-",NA,b2.volume.with.hash..ml.)),
         bs2volume.with.hash.and.live..ml.=as.numeric(ifelse(bs2volume.with.hash.and.live..ml.=="-",NA,bs2volume.with.hash.and.live..ml.)),
         hash.volume.b1=volume.with.hash..ml.-start.volume..ml.,
         hash.volume.b2=b2.volume.with.hash..ml.-b2.start.volume..ml.,
         live.volume.b1=volume.with.hash.and.live..ml.-volume.with.hash..ml.,
         live.volume.b2=bs2volume.with.hash.and.live..ml.-b2.volume.with.hash..ml.,
         hash.volume=ifelse(is.na(hash.volume.b1),0,hash.volume.b1)+ifelse(is.na(hash.volume.b2),0,hash.volume.b2),
         live.volume=ifelse(is.na(live.volume.b1),0,live.volume.b1)+ifelse(is.na(live.volume.b2),0,live.volume.b2),
         total.reef.volume=hash.volume+live.volume)%>%
  select(date,site,quadrat,mussel.number,barnical.rank,oyster.number,sed.bag.label,hash.volume,live.volume,total.reef.volume)



  
write.csv(oa,paste0("wdata/oyster_abundance_",Sys.Date(),".csv"),row.names = FALSE)
