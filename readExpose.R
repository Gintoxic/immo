


readExpose=function (id,importdate)
{
idc<-as.character(id)
before<-"http://www.immobilienscout24.de/expose/"
urllink<-paste(before, idc,sep="")
Sys.sleep(0.1)


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

###
#newrowsxp<-df$id
# channel<-connectPostgres()  
# dbWriteTable(channel, name="newrowsxp", value=newrowsxp)
# try(dbSendQuery(conn = channel, statement = paste("delete from immoxp1 where id=",idc,sep="")))
# dbWriteTable(channel, name="immoxp1", value=df, row.names=FALSE,append=TRUE, overwrite=FALSE)
# disconnectPostgres(channel) 
return(df)
}