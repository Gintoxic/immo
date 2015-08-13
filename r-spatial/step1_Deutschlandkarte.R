library(sp)  

setwd("C:\\Users\\e.harschack\\Documents\\R\\r-spatial")

load('DEU_adm1.RData')

#Viktoriastr., 15,  Koblenz
lat<- 50.35528 
lon<- 7.594029    


png(filename="_output/deutschland.png", width=600, height=700)

plot(gadm)

points(lon, lat, cex=2, pch=20, col="red")
text(lon, lat+0.2, "Decadis", col="red",font=2, cex=1.5)

dev.off()