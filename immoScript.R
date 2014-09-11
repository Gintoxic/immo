

library(sp)
library(XML)
library(rjson)
library(dplyr)
library(RJDBC)

source("getImmo.R")
source("dbFunctions.R")
source("readWriteExpose.R")
source("extractFunctions.R")
source("scriptQFrame.R")
source("scriptRegionList.R")              


for (typeind in 1:dim(qframe)[1])
{

for (region in regionList)
{
  qtype<-as.integer(as.character(qframe$qtype[typeind]))
  
  fa<-getImmo(region=region,type=qframe$qstring[typeind],maxPages = 10000)

  
  
# attributes<-as.data.frame(matrix(unlist(strsplit(f$attributes, ";")), nrow=dim(f)[1], ncol=3, byrow = T), stringsAsFactors = F)
# colnames(attributes)<-c("price","area", "rooms")
# fa<-cbind(f,attributes)


curDate<-as.character(Sys.Date())

fa$importdate<-curDate
fa$region<-region
fa$qtype<-qtype

region_<-gsub("/","_",region)
date_<-format(Sys.Date(), "%Y%m%d")

tit<-fa$title%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub("\u0022","",x) else x)%>%unlist() ### """
fa$title<-tit

colnames(fa)[9]<-"attribs"
fa$id<-as.integer(fa$id)
fa$privateOffer<-as.logical(fa$privateOffer)


dir.create(paste("../immoData/",date_, sep=""))
#filenameCSV<-paste("../immoData/",date_,"/",region_, "_",date_, ".csv",sep="")
#write.table(fa,file =  filenameCSV, row.names = F, sep=";", fileEncoding="UTF-8", quote = TRUE)

filenameRda<-paste("../immoData/",date_,"/"  ,date_,"_",qtype,"_"  ,region_,  ".Rdata",sep="")
save("fa", file=filenameRda)

writeImmoLog(fa, region, curDate)
writeImmoList(fa)

}}
