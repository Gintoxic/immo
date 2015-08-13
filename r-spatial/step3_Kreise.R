setwd("C:\\Users\\e.harschack\\Documents\\R\\r-spatial")

library(sp)       # Spatial Package
library(rgeos)    # Polygonberechnungen

# Bundesländer
#par.bundeslaender<-c("Rheinland-Pfalz", "Nordrhein-Westfalen", "Hessen")
#par.bundeslaender<-c("Nordrhein-Westfalen")
par.bundeslaender<-c("Rheinland-Pfalz")
#par.bundeslaender<-c("Bayern")

load('DEU_adm3.RData')

paste(names(table(gadm$NAME_1)))

deSubInd<-which(gadm$NAME_1 %in% par.bundeslaender)
deSub<-gadm[deSubInd,]

labPt <- getSpPPolygonsLabptSlots(deSub) 
namesKr<-deSub$NAME_3
numKr<-length(deSub)

areaKrList<-sapply(slot(deSub, "polygons"), function(x) sapply(slot(x, "Polygons"), slot, "area"))
areaKr<-rep(NA,times=numKr)

for(i in 1:numKr)
{
  areaKr[i]<-sum(areaKrList[[i]])
}

# Intervalle und Farben bestimmen
vec=seq(from=0, to=1, by=0.01)
areaKr
interv<-findInterval(areaKr, vec, rightmost.closed = FALSE, all.inside = FALSE)
colVec<-rev(heat.colors(max(interv)))
intervCol<-colVec[interv]

# Plotten
plot(deSub, col=intervCol)
for(i in 1:numKr)
{
  text(labPt[i,1],labPt[i,2],namesKr[i], cex=1 )
}

title (par.bundeslaender)