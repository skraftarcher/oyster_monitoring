# plot oyster condition ----

source("scripts/calculate_oyster_condition.R")

lp("pwr")

theme_set(theme_bw()+theme(panel.grid=element_blank()))

# within site variability
ggplot(data=oc)+
  geom_boxplot(aes(y=oc1,fill=siteID))+
  ylab("Oyster condition index")


# power analysis----
# use effect size between LUMO 1 and 3

paov<-aov(oc1~site,data=oc%>%filter(site %in% c("LUMO1","LUMO3")))

(paovs<-summary(paov)[[1]])
# effect size is factor ss/ (factor ss + residual ss)
(efs<-paovs[1,2]/(paovs[1,2]+paovs[2,2]))

pwr.anova.test(k=16,f=efs,sig.level=.05,power=.7)
