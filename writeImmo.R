


writeImmo = function(fa)
  
{


startzeit<-Sys.time()
#channel<-odbcConnect("staging", uid = "staging") 
#sqlSave(channel, dat=airports, tablename="staging.of_airports", rownames=FALSE, fast=TRUE)

channel<-connectStaging()  #, pwd = "locknload"
#dbWriteTable(channel, name="immolist", value=fa ,row.names=FALSE)
dbWriteTable(channel, name="immolist", value=fa , append=TRUE, row.names=FALSE, overwrite=FALSE)



disconnectStaging(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)
}