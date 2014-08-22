library(rJava)
library( RJDBC ) 


writeImmo = function(fa)
  
{
postgres <- JDBC( "org.postgresql.Driver", "postgresql-9.3-1101.jdbc3.jar")

connectStaging=function()
{
  con <- dbConnect(postgres, "jdbc:postgresql://localhost:5432/immo", user = "postgres", password = "postgres" )
  return(con)
}

disconnectStaging=function(con)
{
  dbDisconnect(con)
}


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