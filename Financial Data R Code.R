##Financial Data
##Project: Squeeze Project
##Created By: Mirit Friedman
##Version Date: 7/10/2021

##---------------------------------

##Clear working directory
rm(list=ls())
library(dplyr)
library(tidyr)
library(plyr)

setwd("/Users/miritfriedman/Desktop/financial")
fin<-read.csv("MunicipalData.csv")

vars<- c("FIPS_Code_State","FIPS_County","FIPS_Place","FIPS_Combined", "Name","Year4","Total_Revenue", "Total_Expenditure", "Total_Taxes","Water_Utility_Revenue","Water_Util_Total_Exp", 
         "Water_Util_Inter_Exp", "Water_Util_Cap_Outlay", "Water_Util_Current_Exp",
         "Water_Util_Construct", "Transit_Sub_Total_Exp", "Health_Total_Expend", "Parks___Rec_Total_Exp",
         "Police_Prot_Total_Exp", "Total_Debt_Outstanding", "Total_IG_Revenue", "Total_Rev_Own_Sources")
watfin<- select(fin, all_of(vars))

watfin$Debt_Ratio <- watfin$Total_Debt_Outstanding/watfin$Total_Revenue
watfin<-watfin%>%unite("FIPS","FIPS_Code_State","FIPS_Place", sep = "")

#read in the master FIPS code list to cut the data 
masterFIPS <- read.csv("/Users/miritfriedman/Desktop/moisture/modified files/final_moisture.csv")
masterFIPS<- rename(masterFIPS, FIPS = subject.FIPS)

#subset the large financial database using the master list of FIPS codes
output_M <- match_df(watfin, masterFIPS, on = "FIPS")

#see how many municipalities were output - appears to be 2351
length(unique(output$FIPS))

#do the same for the county data
c_fin<-read.csv("CountyData.csv")
c_watfin<- select(c_fin, all_of(vars))

c_watfin$Debt_Ratio <- c_watfin$Total_Debt_Outstanding/c_watfin$Total_Revenue
c_watfin<-c_watfin%>%unite("FIPS","FIPS_Code_State","FIPS_Place", sep = "")

#subset the large financial database using the master list of FIPS codes
output_C <- match_df(c_watfin, masterFIPS, on = "FIPS")


#do the same for the township data
t_fin<-read.csv("TownshipData.csv")
t_watfin<- select(t_fin, all_of(vars))

t_watfin$Debt_Ratio <- t_watfin$Total_Debt_Outstanding/t_watfin$Total_Revenue
t_watfin<-t_watfin%>%unite("FIPS","FIPS_Code_State","FIPS_Place", sep = "")

#subset the large financial database using the master list of FIPS codes
output_T <- match_df(t_watfin, masterFIPS, on = "FIPS")

#see how many townships were output - appears to be 2
length(unique(output_T$FIPS))




#Merge the files together


#write the output file
write.csv(output,"final_financial.csv")


##Creeate new dataframe with all the FIPS codes, and a row for each year in the study period

library(tidyr)
#find unique FIPS codes
FIPS<-unique(output$FIPS,)
FIPS<-data.frame(FIPS, "ID", "YEAR",1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,
                 2009,2010,2011,2012,2013,2014,2015,2016,2017,2018)
#create the tidy format with a year 1997-2018 for each FIPS code
FIPS<-gather(FIPS,"ID","YEAR","X1997","X1998","X1999","X2000","X2001","X2002","X2003","X2004","X2005","X2006","X2007","X2008",
             "X2009","X2010","X2011","X2012","X2013","X2014","X2015","X2016","X2017","X2018", 2:22)
FIPS<-FIPS[!(FIPS$YEAR=="ID" | FIPS$YEAR=="YEAR"),]
FIPS<-subset(FIPS,select=-c(ID))


#merge the financial data with the new tidy data
output<-unite(output,"unite",FIPS,Year4,sep="_")
FIPS<-unite(FIPS,"unite",FIPS,YEAR,sep="_")

#merge the tidy version with the full financial dataset, but keep years with no data
fin_tidy<-merge(FIPS,output,by="unite", all=TRUE)

fin_tidy<-separate(fin_tidy, col = "unite", into = c("FIPS", "YEAR"), sep = "\\_")
fin_tidy<-transform(fin_tidy, YEAR=as.numeric(YEAR))

fin_tidy<-subset(fin_tidy, fin_tidy$YEAR>=1997 & fin_tidy$YEAR<=2018)

write.csv(fin_tidy,"final_financial_tidy.csv")








