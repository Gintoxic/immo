


library(XML)
library(rjson)

source("getImmo.R")


region = "Rheinland-Pfalz/Koblenz"
region = "Rheinland-Pfalz/Mainz"
region = "Berlin/Berlin"
region = "Hamburg/Hamburg"
region = "Bremen/Bremen"
region = "Nordrhein-Westfalen/Koeln"
region = "Nordrhein-Westfalen/Bonn"

f<-getImmo(region=region,maxPages = 1000)

f$date<-Sys.Date()
f$region<-region

region_<-gsub("/","_",region)
date_<-format(Sys.Date(), "%Y%m%d")

dir.create(paste("../immoData/",date_, sep=""))
filenameCSV<-paste("../immoData/",date_,"/",region_, "_",date_, ".csv",sep="")

write.table(f,file =  filenameCSV, row.names = F, sep="\t", fileEncoding="UTF-8", quote = F)

table(f$district)
