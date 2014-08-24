library(rJava)
library( RJDBC ) 


postgres <- JDBC( "org.postgresql.Driver", "postgresql-9.3-1101.jdbc3.jar")
connectPostgres=function()
{
  con <- dbConnect(postgres, "jdbc:postgresql://localhost:5432/immo", user = "postgres", password = "postgres" )
  return(con)
}

disconnectPostgres=function(con)
{
  dbDisconnect(con)
}

######################


writeImmoLog<-function (fa, region, curDate)
{
  channel<-connectPostgres()  #, pwd = "locknload"
  qr<-paste("select max(importdate) from immolog where region='",region, "'", sep="")
  mx<-dbGetQuery(channel, qr)
  disconnectPostgres(channel)
  
  
  if (as.POSIXlt(mx$max,tz = "GMT")<as.POSIXlt(curDate,tz = "GMT")|is.na(mx$max))
  {
    #write
    fr<-fa[,c("id", "importdate", "region")]
    fnd<-fr[!duplicated(fr[,"id"]),]
      
    startzeit<-Sys.time()
    
    channel<-connectPostgres()  #, pwd = "locknload"
    
    dbWriteTable(channel, name="immolog", value=fnd , append=TRUE, row.names=FALSE, overwrite=FALSE)
    #dbWriteTable(channel, name="immolog", value=fnd )
    
    disconnectPostgres(channel)
    
    laufzeit<-Sys.time()-startzeit
    print("ImmoLog Written")
    print(laufzeit)
    
    
      
  }else{
    print("Immolog Skipped")
  }

}


writeImmoList=function(fa)
{
  
  
  fand<-fa[!duplicated(fa[,"id"]),]
  ids<-fand[,c("id","importdate")]
  
  channel<-connectPostgres()  
  dbWriteTable(channel, name="newrows", value=ids)
  try(dbSendPQuery(conn = channel, statement = "delete from immolist where id in (select id from newrows)"))
  
  #dbWriteTable(channel, name="immolist", value=fand)
  dbWriteTable(channel, name="immolist", value=fand,append=TRUE, row.names=FALSE, overwrite=FALSE)
  disconnectPostgres(channel) 


}



