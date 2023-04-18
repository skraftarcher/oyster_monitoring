# plot oyster condition

source("scripts/calculate_oyster_condition.R")
theme_set(theme_bw()+theme(panel.grid=element_blank()))
# within site variability
ggplot(data=oc2)+
  geom_boxplot(aes(y=oc1,fill=site))+
  ylab("Oyster condition index")
