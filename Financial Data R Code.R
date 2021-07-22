##Financial Data
##Project: Squeeze Project
##Created By: Mirit Friedman
##Version Date: 7/10/2021

##---------------------------------

##Clear working directory
rm(list=ls())
library(dplyr)

setwd("/Users/miritfriedman/Desktop/Financial")
fin<-read.csv("MunicipalData.csv")

vars<- c("ID","Year4","Total_Revenue", "Total_Expenditure", "Total_Taxes","Water_Utility_Revenue","Water_Util_Total_Exp", 
         "Water_Util_Inter_Exp", "Water_Util_Cap_Outlay", "Water_Util_Current_Exp",
         "Water_Util_Construct", "Transit_Sub_Total_Exp", "Health_Total_Expend", "Parks___Rec_Total_Exp",
         "Police_Prot_Total_Exp", "Total_Debt_Outstanding", "Total_IG_Revenue", "Total_Rev_Own_Sources")
watfin<- select(fin, all_of(vars))
watfin$Debt_Ratio <- watfin$Total_Debt_Outstanding/watfin$Total_Revenue

#read in the master FIPS code list to cut the data 
masterFIPS <- read.csv("")

output <- subset(watfin, FIPS %in% masterFIPS)

write.csv(output,"final_financial.csv")























