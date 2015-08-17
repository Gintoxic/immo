
library(sp)       # Spatial Package
library(rgeos)    # Polygonberechnungen
library(SDMTools) # Bestimmung ob Punkt im Polygon

load('DEU_adm3.RData')
load("r-spatial/shiny-hist/immodat.RData")

gadm<-deSub
numKr<-length(deSub)
Id<-deSub$ID_3
kreise<-as.data.frame(Id)
kreise$Kreis<-as.character(deSub$NAME_3)
kreise$Bundesland<-as.character(deSub$NAME_1)
kreise$Anz<-as.integer(0)
kreise$Col<-""

kreise


immodat$kreis<-""
immodat$land<-""
########## Verteilung der Geookordingaten auf Kreise ########## 
for (i in 1:10)
{
  print(i)
  x=immodat$lon
  pnt<-as.data.frame(x)
  pnt$y<-immodat$lat[i]
  
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
      
      immodat$kreis[i]<-kreise$Kreis[j]
      immodat$land[i]<-kreise$Bundesland[j]
    }  
  }
}

immodat[1:10,]
