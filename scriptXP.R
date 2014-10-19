

library(sp)
library(XML)
library(rjson)
library(dplyr)
library(RJDBC)
library(stringr)

source("dbFunctions.R")
source("readExpose.R")
source("extractFunctions.R")


for (iii in 1:1)
{

startzeit<-Sys.time()
# try()


#channel<-odbcConnect("staging", uid = "staging") 
#sqlSave(channel, dat=airports, tablename="staging.of_airports", rownames=FALSE, fast=TRUE)

channel<-connectPostgres()  

stmnt = paste("select * from immolist il left join immoxp1 xp on il.id=xp.id where il.qtype=1 and il.importdate='",
              as.character(Sys.Date(), "%Y-%m-%d"),"' and xp.id is null",sep="")


whgm<-dbGetQuery(conn = channel, statement = stmnt)

disconnectPostgres(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)


numlloops<-dim(whgm)[1]

for (i in 1:300)
  #for (i in 1:numlloops)
{
  print(paste(i," of ",numlloops))

    xp<-try(readExpose(whgm$id[i], paste(as.character(Sys.Date(), "%Y-%m-%d"),sep="")))

  if(i==1 ){
    allxp<-xp
  }else{
    allxp<-rbind(allxp,xp)
  }

}

dim(allxp)
#length(unique(pxp$id))

# pxp<-allxp[1:240,]
# allxp<-pxp
str(allxp)

startzeit<-Sys.time()
channel<-connectPostgres()  #, pwd = "locknload"
dbWriteTable(channel, name="immoxp1", value=allxp , append=TRUE, row.names=FALSE, overwrite=FALSE)
disconnectPostgres(channel)
laufzeit<-Sys.time()-startzeit
print(laufzeit)
}


