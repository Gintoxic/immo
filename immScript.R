


library(XML)
library(rjson)
library(dplyr)

source("getImmo.R")
source("writeImmo.R")

# region = "Rheinland-Pfalz/Koblenz"
# region = "Rheinland-Pfalz/Mainz"
# region = "Berlin/Berlin"
# region = "Hamburg/Hamburg"
# region = "Bremen/Bremen"
# region = "Nordrhein-Westfalen/Koeln"
# region = "Nordrhein-Westfalen/Bonn"
# region ="Nordrhein-Westfalen/Dortmund"
# region ="Nordrhein-Westfalen/Duesseldorf"
# region ="Nordrhein-Westfalen/Leverkusen"
# region ="Nordrhein-Westfalen/Duisburg"
# region ="Nordrhein-Westfalen/Hagen"
# region ="Nordrhein-Westfalen/Siegen-Wittgenstein-Kreis/Siegen"


regionList<-c("Rheinland-Pfalz/Koblenz",
              "Rheinland-Pfalz/Mainz",
              "Nordrhein-Westfalen/Duesseldorf",
              "Nordrhein-Westfalen/Koeln",
              "Nordrhein-Westfalen/Bonn", 
              "Nordrhein-Westfalen/Leverkusen",
              "Nordrhein-Westfalen/Hagen",
              "Hamburg/Hamburg",
              "Bremen/Bremen",
              "Berlin/Berlin")
              

#regionList<-c("Nordrhein-Westfalen/Dortmund")

for (region in regionList)
{
f<-getImmo(region=region,maxPages = 1000)

attributes<-as.data.frame(matrix(unlist(strsplit(f$attributes, ";")), nrow=dim(f)[1], ncol=3, byrow = T), stringsAsFactors = F)

colnames(attributes)<-c("price","area", "rooms")

fa<-cbind(f,attributes)

fa$importdate<-Sys.Date()
fa$region<-region

region_<-gsub("/","_",region)
date_<-format(Sys.Date(), "%Y%m%d")

rms<-fa$rooms%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub("Zi.","",x) else x)%>%unlist() ###Zi.
fa$rooms<-as.numeric(gsub(",",".",rms))


prc<-fa$price%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub(" \u20ac","",x) else x)%>%unlist() ###€

lind<-which(nchar(prc) %in% c(5))
bef<-substr(prc[lind],1,1)
aft<-substr(prc[lind],3,5)
conc<-paste(bef,aft,sep = "")
prcw<-prc
prcw[lind]<-conc

fa$price<-as.numeric(prcw)


are<-fa$area%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub("m\u00b2","",x) else x)%>%unlist() ### m²
fa$area<-as.numeric(are)

tit<-fa$title%>%lapply(function(x) if(is.character(x)|is.factor(x)) gsub("\u0022","",x) else x)%>%unlist() ### """
fa$title<-tit

colnames(fa)[9]<-"attribs"

str(fa)
dir.create(paste("../immoData/",date_, sep=""))
filenameCSV<-paste("../immoData/",date_,"/",region_, "_",date_, ".csv",sep="")


write.table(fa,file =  filenameCSV, row.names = F, sep=";", fileEncoding="UTF-8", quote = TRUE)

filenameRda<-paste("../immoData/",date_,"/",region_, "_",date_, ".Rdata",sep="")
save("fa", file=filenameRda)

writeImmo(fa)
}


fa[1:10,]

str(fa)
