


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
region ="Nordrhein-Westfalen/Dortmund"
region ="Nordrhein-Westfalen/Duesseldorf"
region ="Nordrhein-Westfalen/Leverkusen"
region ="Nordrhein-Westfalen/Duisburg"
region ="Nordrhein-Westfalen/Hagen"
region ="Nordrhein-Westfalen/Siegen-Wittgenstein-Kreis/Siegen"

f<-getImmo(region=region,maxPages = 1000)

attributes<-as.data.frame(matrix(unlist(strsplit(f$attributes, ";")), nrow=dim(f)[1], ncol=3, byrow = T), stringsAsFactors = F)

colnames(attributes)<-c("price","area", "rooms")

fa<-cbind(f,attributes)

fa$date<-Sys.Date()
fa$region<-region

region_<-gsub("/","_",region)
date_<-format(Sys.Date(), "%Y%m%d")

dir.create(paste("../immoData/",date_, sep=""))
filenameCSV<-paste("../immoData/",date_,"/",region_, "_",date_, ".csv",sep="")

write.table(fa,file =  filenameCSV, row.names = F, sep="|", fileEncoding="UTF-8", quote = F)

