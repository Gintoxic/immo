

library(sp)
library(XML)
library(rjson)
library(dplyr)
library(RJDBC)
library(stringr)
library(RCurl)

source("dbFunctions.R")
# source("readExpose.R")
# source("extractFunctions.R")

startzeit<-Sys.time()
channel<-connectPostgres()  

stmnt<-
  "with add as(select distinct on(address) id, address from immolist where qtype=1 and importdate='<IMPDATE>') select a.* from add a left join immogeo g on a.address=g.address where g.id is null"

stmnt<-gsub("<IMPDATE>",as.character(Sys.Date(), "%Y-%m-%d"),stmnt)

# stmnt = paste("select distinct on(address) id, address from immolist where qtype=1 and importdate='",
#               as.character(Sys.Date(), "%Y-%m-%d"),"' ",sep="")

#stmnt = paste("select distinct on(address) id, address from immolist where qtype=1")


whgm<-dbGetQuery(conn = channel, statement = stmnt)

disconnectPostgres(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)

str(whgm)
whgm[1:10,]

proc.started<-0
for (i in 1:3000)
{
addr<-gsub("(Kreis)","",gsub(" ","%20",gsub("ß","ss",gsub("ä","ae",gsub("ö","oe",gsub("ü","ue", whgm$address[i]))))))


base_url<-"http://nominatim.openstreetmap.org/search?q=<ADDRESS>&format=json&polygon=0&addressdetails=1"

requrl<-gsub("<ADDRESS>", addr, base_url)
r <- getURL(requrl)
f <- fromJSON(r)
print (requrl)
print(length(f))

if(length(f)>0)
{
  
lon<-f[[1]]$lon
df<-as.data.frame(lon)
df$lon<-as.numeric(f[[1]]$lon)
df$lat<-as.numeric(f[[1]]$lat)
df$placeid<-as.integer(f[[1]]$place_id)
df$id<-whgm$id[i]
df$address<-whgm$address[i]
if (proc.started==0){
  dfa<-df
}else{
  dfa<-rbind(dfa,df)
}
proc.started=1
}




}



startzeit<-Sys.time()
channel<-connectPostgres()  #, pwd = "locknload"
dbWriteTable(channel, name="immogeo", value=dfa , append=TRUE, row.names=FALSE, overwrite=FALSE)
#dbWriteTable(channel, name="immogeo", value=dfa , row.names=FALSE)
disconnectPostgres(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)





# 
# 
# 
# 
# numlloops<-dim(whgm)[1]
# 
# for (i in 1:10000)
#   #for (i in 1:numlloops)
# {
#   print(paste(i," of ",numlloops))
#   
#   xp<-try(readExpose(whgm$id[i], paste(as.character(Sys.Date(), "%Y-%m-%d"),sep="")))
#   
#   if(i==1 ){
#     allxp<-xp
#   }else{
#     allxp<-rbind(allxp,xp)
#   }
#   
# }
# 
# dim(allxp)
# length(unique(allxp$id))
# 
# 
# startzeit<-Sys.time()
# channel<-connectPostgres()  #, pwd = "locknload"
# dbWriteTable(channel, name="immoxp1", value=allxp , append=TRUE, row.names=FALSE, overwrite=FALSE)
# disconnectPostgres(channel)
# laufzeit<-Sys.time()-startzeit
# print(laufzeit)
# 
# 

