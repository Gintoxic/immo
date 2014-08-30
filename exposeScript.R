library(RCurl)
library(XML)
library(stringr)


setwd("D:/Work/immo")
#source("getImmo.R")
source("dbFunctions.R")
source("extractFunctions.R")

qtype=1
importdate<-"2014-08-27"

for (region in regionList)
{
  print(region)
  
 

channel<-connectPostgres()  #, pwd = "locknload"
qr<-paste("select id from immolist where region='",region, "' and qtype=", qtype," and importdate='",importdate,"'", sep="")
idlist<-dbGetQuery(channel, qr)
disconnectPostgres(channel)

### Wohnung MIETEN ###############################################
##################################################################
#length(idlist)
counter<-0
for (id in idlist$id)
{
  

  
  
  idc<-as.character(id)
  before<-"http://www.immobilienscout24.de/expose/"
  urllink<-paste(before, idc,sep="")
  Sys.sleep(runif(min = 1.1, max=2,n = 1))
  
  print(paste(Sys.time(),region,counter,urllink))

  counter<-counter+1
  rm(list = "df")
  
  doc=try(htmlParse(urllink))
 


df<-as.data.frame(id)

df$id<-as.integer(id)
df$wohnungstyp<-immoExtractNodeDdRegular(doc, "is24qa-wohnungstyp")
df$zimmer<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-zimmer"))


df$wohnflaeche<-as.numeric(immoExtractNodeDdSpecialNumbers(doc, "is24qa-wohnflaeche-ca"))
df$etage<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-etage"))
df$etagenanzahl<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-etagenanzahl"))
df$schlafzimmer<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-schlafzimmer"))
df$badezimmer<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-badezimmer"))

df$bezugsfrei<-immoExtractNodeDdRegular(doc, "is24qa-bezugsfrei-ab")

df$stellplatz<-immoExtractNodeDdRegular(doc, "is24qa-garage-stellplatz")
df$anz_stellplatz<-as.integer(immoExtractNodeDdRegular(doc, "is24qa-anzahl-garage-stellplatz"))


df$balkon<-as.integer(immoExtractNodeDdSpecialCheck(doc,"is24qa-balkon-terrasse"))
df$keller<-as.integer(immoExtractNodeDdSpecialCheck(doc,"is24qa-keller"))
df$einbaukueche<-as.integer(immoExtractNodeDdSpecialCheck(doc,"is24qa-einbaukueche"))
df$gaeste_wc<-as.integer(immoExtractNodeDdSpecialCheck(doc,"is24qa-gaeste-wc"))

###########################################

kaltmiete<-immoExtractNodeDdSpecialNumbers(doc, "is24qa-kaltmiete")
df$kaltmiete<-as.numeric(gsub(",","",kaltmiete))


df$nebenkosten<-as.numeric(immoExtractNodeDdSpecialNumbers(doc, "is24qa-nebenkosten"))
df$heizkosten<-immoExtractNodeDdRegular(doc, "is24qa-heizkosten")

#immoExtractNodeDdSpecialNumbers(doc, "is24qa-gesamtkosten")

###########################################

df$provision<-immoExtractNodeDdRegular(doc, "is24qa-provision")
df$baujahr<-as.numeric(immoExtractNodeDdRegular(doc, "is24qa-baujahr"))
df$objektzustand<-immoExtractNodeDdRegular(doc, "is24qa-objektzustand")
df$heizungsart<-immoExtractNodeDdRegular(doc, "is24qa-heizungsart")
df$energietraeger<-immoExtractNodeDdRegular(doc, "is24qa-wesentliche-energietraeger")

df$importdate<-importdate

#df$objektbeschreibung<-immoExtractNodeP(doc, "is24qa-objektbeschreibung is24-pre")
#df$austattung<-immoExtractNodeP(doc, "is24qa-ausstattung is24-pre")
#print(df)

if (id==idlist[1])
{dfa<-df}
else {dfa<-rbind(dfa,df)}

}



newrowsxp<-as.data.frame(as.integer(dfa$id))
colnames(newrowsxp)<-"id"

channel<-connectPostgres()  
dbWriteTable(channel, name="newrowsxp", value=newrowsxp)
try(dbSendQuery(conn = channel, statement = "delete from immoxp1 where id in (select id from newrowsxp)"))

#dbWriteTable(channel, name="immoxp1", value=dfa, row.names=FALSE)
dbWriteTable(channel, name="immoxp1", value=dfa, row.names=FALSE,append=TRUE, overwrite=FALSE)
disconnectPostgres(channel) 


filenameRda<-paste("../immoData/",date_,"/"  ,date_,"_EX_",qtype,"_"  ,region,  ".Rdata",sep="")
save("dfa", file=filenameRda)
}

getwd()
urllink
dfa[1:29,]
