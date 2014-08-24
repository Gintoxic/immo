

library(sp)
library(XML)
library(rjson)
library(dplyr)

source("getImmo.R")
source("dbFunctions.R")
              

for (region in regionList)
{
fa<-getImmo(region=region,maxPages = 10000)

# attributes<-as.data.frame(matrix(unlist(strsplit(f$attributes, ";")), nrow=dim(f)[1], ncol=3, byrow = T), stringsAsFactors = F)
# colnames(attributes)<-c("price","area", "rooms")
# fa<-cbind(f,attributes)


curDate<-as.character(Sys.Date())

fa$importdate<-curDate
fa$region<-region

region_<-gsub("/","_",region)
date_<-format(Sys.Date(), "%Y%m%d")

tit<-fa$title%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub("\u0022","",x) else x)%>%unlist() ### """
fa$title<-tit

colnames(fa)[9]<-"attribs"


dir.create(paste("../immoData/",date_, sep=""))
#filenameCSV<-paste("../immoData/",date_,"/",region_, "_",date_, ".csv",sep="")
#write.table(fa,file =  filenameCSV, row.names = F, sep=";", fileEncoding="UTF-8", quote = TRUE)

filenameRda<-paste("../immoData/",date_,"/",region_, "_",date_, ".Rdata",sep="")
save("fa", file=filenameRda)

writeImmoLog(fa, region, curDate)
writeImmoList(fa)

}

