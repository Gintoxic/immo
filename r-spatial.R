#--------------------------------------------------------------------------------
#install.packages(c("gdata","RCurl","rjson","SDMTools",#"sp","gplots","gmt","maptools","geosphere", "png")

########## ßßß VORBEREITUNG ßßß ########## 

########## Pakete laden ########## 
library(gdata)    # Excel lesen
library(RCurl)    # Umgang mit Curl
library(rjson)    # Umgang mit Json
library(SDMTools) # Bestimmung ob Punkt im Polygon
library(sp)       # Spatial Package
library(gplots)   # Textplot
library(gmt)      # Map Tools (geodist)
library(maptools) # Map Tools
library(geosphere) # Spherische Berechnungen
library(png)      # Umgang mit PNG-Bilddateien

#library(plotrix) # boxed.labels
#library(RDSTK)   # R Data Science Toolkit

########## Variablen zuweisen, Pfade festlegen ########## 
par.fluesse<-c("Rhein", "Mosel","Main", "Sieg", "Ahr")
par.fluesse_col<-"darkblue"
par.fluesse_lwd<-2
par.bundeslaender<-c("Rheinland-Pfalz", "Nordrhein-Westfalen", "Hessen")

par.textOffset<-0.03 # Abstand f¸r Beschriftungen in L‰ngengraden
par.refPoint<-1     # Nummer des Referenzpunktes
par.edge<-0.2       # Rand auf der Karte in L‰ngen- / Breitengraden

par.staedte<-c("Bonn", "Koeln","Frankfurt","Mainz","Trier", "Siegen") #"Koblenz"
par.geocodeCities<-F  # St‰dte geokodieren (T) oder laden (F)
par.outputPdf<-F   # Output in PDF schreiben (T) 
par.fluesseLesen<-F
par.logo<-T
par.logoWidth<-30000 #in m
par.useProxy<-T

# Arebeitsverzeichnis
#setwd("\\\\DCD-STORAGE\\public\\r-spatial")
setwd("C:\\Users\\e.harschack\\Documents\\R\\r-spatial")
getwd()

# Pfad der perl.exe (herunterzuladen bei http://strawberryperl.com)
#pf<-"\\\\DCD-STORAGE\\software\\Statistik\\Portable\\perl\\bin\\perl.exe"
pf<-"C:\\Tools\\strawberry\\perl\\bin\\perl.exe"


#################################################################################
#################################################################################
#################################################################################

getwd()

########## ßßß IMPORT ßßß ########## 

########## Flussl‰ufe importieren oder laden ########## 
if (par.fluesseLesen)
{
  # Quelle: http://www.geofabrik.de
  fluesse_hes <- readShapeLines("./hessen-latest/waterways.shp")
  fluesse_nrw <- readShapeLines("./nordrhein-westfalen-latest/waterways.shp")
  fluesse_rlp <- readShapeLines("./rheinland-pfalz-latest/waterways.shp")
  save("fluesse_hes", "fluesse_nrw", "fluesse_rlp", file="fluesse.Rdata")
}else{
  load (file="fluesse.Rdata")
}


########## Adressen einlesen ########## 
installXLSXsupport(perl=pf)

xlsFile<-"Adressen.xls"
adressen_imp<-read.xls(xls=xlsFile, perl=pf)

Name<-adressen_imp$Name
adressen<-as.data.frame(Name)
adressen$Name<-as.character(adressen$Name)
adressen$Adresse<-as.character(adressen_imp$Adresse)
adressen$Bahnfahrer<-as.numeric(adressen_imp$Bahnfahrer)
adressen$kreis<-adressen$land<-adressen$dist<-adressen$lon<-adressen$lat<-NA

adressen

########## ßßß GEOKODIERUNG ßßß ########## 
########## Geokodierung Adressen ########## 
numAdr<-dim(adressen)[1]

print(paste("[Hinweis:]", numAdr, "Adressen wurden gelesen"))

## Nominatim-API URL (OpenStreetMap) 
base_url<-"http://nominatim.openstreetmap.org/search?q=<TO_REPLACE>&format=json&polygon=0&addressdetails=1"

## Googlemaps API URL: Ausgabenverarbeitung muﬂ angepaﬂt werden
#base_url<-"http://maps.googleapis.com/maps/api/geocode/json?address=<TO_REPLACE>&sensor=false"

for (i in 1:numAdr)
{
  curAd<-adressen$Adresse[i]
  curAdNoblank<-requrl<-gsub(" ", "", curAd)
  requrl<-gsub("<TO_REPLACE>", curAdNoblank, base_url)

  if(par.useProxy){
    curlHandle <- getCurlHandle()
    curlSetOpt(.opts = list(proxy = '10.1.5.3:3128'), curl = curlHandle)
    r <- try(getURL(requrl,curl = curlHandle))
  }else{
    r <- try(getURL(requrl))
  }
  
  
  f <- try(fromJSON(r))
  if(length(f)>0)
  {
    fs<-f[[1]]
    adressen$lat[i]<-as.numeric(fs$lat)
    adressen$lon[i]<-as.numeric(fs$lon)
    print(paste("Geokodierung erfolgreich f¸r", curAd))
  }else{
    print(paste("Geokodierung fehlgeschlagen f¸r", curAd))
  }
}

#save("adressen", file="adressen.RData")
#load(file="adressen.RData")

print(paste("[Hinweis:]", length(which(!is.na(adressen$lat))), "Adressen wurden kodiert"))
print(paste("[Hinweis:]", length(which(is.na(adressen$lat))), "Adressen wurden nicht kodiert"))

########## Berechnung Kartenausschnitt ########## 
latSpan<-c(min(adressen$lat)-par.edge,max(adressen$lat)+par.edge)
lonSpan<-c(min(adressen$lon)-par.edge,max(adressen$lon)+par.edge)

########## Geokodierung St‰dte ########## 

if (par.geocodeCities)
{
Stadt<-par.staedte
staedte<-as.data.frame(Stadt)
staedte$Stadt<-as.character(staedte$Stadt)
staedte$lat<-staedte$lon<-NA

numStaedte<-length(par.staedte)
for (i in 1:numStaedte)
{
  curSt<-staedte$Stadt[i]
  curStNoblank<-requrl<-gsub(" ", "", curSt)
  requrl<-gsub("<TO_REPLACE>", curStNoblank, base_url)
  
  if(par.useProxy){
    curlHandle <- getCurlHandle()
    curlSetOpt(.opts = list(proxy = '10.1.5.3:3128'), curl = curlHandle)
    r <- try(getURL(requrl,curl = curlHandle))
  }else{
    r <- try(getURL(requrl))
  }
  
  f <- try(fromJSON(r))
  if(length(f)>0)
    {
    fs<-f[[1]]
    staedte$lat[i]<-as.numeric(fs$lat)
    staedte$lon[i]<-as.numeric(fs$lon)
    print(paste("Geokodierung erfolgreich f¸r", curSt))
    }  
  }
  save("staedte", file="staedte.Rdata")
}else{
 load(file="staedte.Rdata") 
}
numStaedte<-dim(staedte)[1]

########## R‰umliche Daten laden ########## 
#Qelle: http://www.gadm.org/
load('DEU_adm3.RData')



deSubInd<-which(gadm$NAME_1 %in% par.bundeslaender)
deSub<-gadm[deSubInd,]


########## Kreise aus gadm ermitteln ########## 
numKr<-length(deSub)
Id<-deSub$ID_3
kreise<-as.data.frame(Id)
kreise$Kreis<-as.character(deSub$NAME_3)
kreise$Bundesland<-as.character(deSub$NAME_1)
kreise$Anz<-as.integer(0)
kreise$Col<-""

kreise

########## Verteilung der Geookordingaten auf Kreise ########## 
# Erste Adresse ist Referenz (Decadis Hauptquartier)
for (i in 2:numAdr)
{
  x=adressen$lon[i]
  pnt<-as.data.frame(x)
  pnt$y<-adressen$lat[i]

  for (j in 1:numKr)
  {
  xVec<-deSub[j,]@polygons[[1]]@Polygons[[1]]@coords[,1]
  yVec<-deSub[j,]@polygons[[1]]@Polygons[[1]]@coords[,2]
  polypnts = cbind(x=xVec, y=yVec)
  
  isIn<-pnt.in.poly(pnt,polypnts)$pip
  if(isIn)
    {
      print(paste("Adresse:",adressen$Adresse[i]," Kreis:", kreise$Kreis[j]))
      kreise$Anz[j]<-kreise$Anz[j]+1
      
      adressen$kreis[i]<-kreise$Kreis[j]
      adressen$land[i]<-kreise$Bundesland[j]
    }  
  }
}

kreise
numCols<-max(kreise$Anz)

########## Kreisen Farbe zuweisen ########## 
cols<-c("white",rev(terrain.colors(numCols*2)[1:numCols]))

barplot(1:10, col=cols)

#cols<-c("white",rev(heat.colors(numCols)))
#cols<-c("white",rev(terrain.colors(numCols)))

for (i in 1:numKr)
{
  kreise$Col[i]<-cols[kreise$Anz[i]+1]
}
deSubC<-merge(x=deSub, y=kreise, by.x="ID_3", by.y="Id")

########## ßßß PLOTS ßßß ########## 
if (par.outputPdf)
{
  pdfFilename<-paste("./_output/output",format(Sys.time(),"%Y%m%d_%H%M"), ".pdf", sep="")
  pdf(pdfFilename,width=11.69,height=8.27)
}

########## Textplot Kreise ########## 
bewohnteKreise<-kreise[which(kreise$Anz>0),]
bewohnteKreiseSort<-bewohnteKreise[order(-bewohnteKreise$Anz),c("Id", "Kreis", "Bundesland", "Anz", "Col")]

textplot(bewohnteKreiseSort[c("Id", "Kreis", "Bundesland", "Anz")])
title("Tabelle: Anzahl Kollegen nach Kreisen")

########## Barplot Kreise ########## 
mids<-barplot(bewohnteKreiseSort$Anz, col=bewohnteKreiseSort$Col, axes=F)
text(mids, 
     max(bewohnteKreiseSort$Anz)/2, 
     paste(bewohnteKreiseSort$Kreis,"\n",bewohnteKreiseSort$Bundesland, sep=""), 
     srt=90 )
axis(2, at=0:max(bewohnteKreiseSort$Anz))
title("Barplot: Anzahl Kollegen nach Kreis")

########## Plot Karte ########## 
plot(deSubC, xlim=lonSpan,ylim=latSpan, col=deSubC$Col)
title("Wohnorte der Kollegen")

########## Fluesse plotten ########## 
lines(fluesse_hes[which(fluesse_hes$name %in% par.fluesse),], col=par.fluesse_col, lwd=par.fluesse_lwd)
lines(fluesse_nrw[which(fluesse_nrw$name %in% par.fluesse),], col=par.fluesse_col, lwd=par.fluesse_lwd)
lines(fluesse_rlp[which(fluesse_rlp$name %in% par.fluesse),], col=par.fluesse_col, lwd=par.fluesse_lwd)

########## Staedte plotten ########## 
for (i in 1:numStaedte)
{
  points( staedte$lon[i],staedte$lat[i], pch=15, cex=1) #col="red1"
  text( staedte$lon[i],staedte$lat[i]+par.textOffset,staedte$Stadt[i])
  #boxed.labels(x=staedte$lon[i],y=staedte$lat[i]+par.textOffset,labels=staedte$Stadt[i], bg="white")
}

########## Punkte, Texte, Linien ########## 
for (i in 1:numAdr)
{
  lines(c(adressen$lon[par.refPoint], adressen$lon[i]), c(adressen$lat[par.refPoint], adressen$lat[i])) 
  points( adressen$lon[i],adressen$lat[i], pch=20, cex=1) 
  #text( adressen$lon[i],adressen$lat[i]+par.textOffset,adressen$Name[i])
  adressen$dist[i]<-geodist(adressen$lon[i], adressen$lat[i],adressen$lon[par.refPoint],adressen$lat[par.refPoint], units="km")
}

######### Logo lesen und plotten #########
if (par.logo)
{
  logoPng = readPNG("decadis.png")
  logoBild = as.raster(logoPng[,,1:3])

  logoRatio<-dim(logoBild)[2]/dim(logoBild)[1]
  
  logoHeight<-par.logoWidth/logoRatio
      
  logoMid<-c(adressen$lon[par.refPoint],adressen$lat[par.refPoint])
  
  logoHyp<-sqrt( (logoHeight/2)^2 +(par.logoWidth/2)^2)
  
  angle<-90-acos( (par.logoWidth/2) / logoHyp )*180/pi
  
  logoUpRight<-destPoint(logoMid,angle,logoHyp)
  logoLowLeft<-destPoint(logoMid,angle+180,logoHyp)

  rasterImage(logoBild, logoLowLeft[1], logoLowLeft[2],
              logoUpRight[1],logoUpRight[2])
  
}

########## Textplot Adressenliste ########## 
textplot(adressen[,c("Name","Adresse","dist","Bahnfahrer")])
title("Adressenliste")

if (par.outputPdf){dev.off()}

