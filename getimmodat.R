startzeit<-Sys.time()
channel<-connectPostgres()  

stmnt<-
  "select g.id, g.lon, g.lat, l.attribs,split_part(l.attribs,';',1) as val1,split_part(l.attribs,';',2) as val2,split_part(l.attribs,';',3) as val3 from immogeo g inner join immolist l on g.id=l.id"
immodat<-dbGetQuery(conn = channel, statement = stmnt)

disconnectPostgres(channel)

laufzeit<-Sys.time()-startzeit
print(laufzeit)

str(immodat)


plot(immodat$lon, immodat$lat)


v1a<-gsub(pattern = "\U20ac", replacement = "", x = immodat$val1)
v1b<-gsub(pattern = "\\.", replacement = "", x = v1a)
immodat$preis<-as.numeric(v1b)


v2a<-gsub(pattern = "\\m²", replacement = "", x = immodat$val2)
immodat$qm<-as.numeric(v2a)


v3a<-gsub(pattern = "\\Zi.", replacement = "", x = immodat$val3)
v3b<-gsub(pattern = "\\,", replacement = ".", x = v3a)
immodat$zimmmer<-as.numeric(v3b)

library(gplots)

?hist2d
#ginhist2d( y=immodat$lat, x=immodat$lon,val=immodat$preis)
#ginhist2d( y=immodat$lat, x=immodat$lon,val=immodat$preis)
#ginhist2d( y=immodat$lat, x=immodat$lon,val=immodat$qm)

#mycol<-c("#ffffff",(colorRampPalette(c("#ffffff", "#003193"))(20)[10:20]))

mycol<-colorRampPalette(c("#ffffff", "#003193"))(50)

mycol<-c("#ffffff", colorRampPalette(c("#A6B7D9", "#003193"))(50))
im.ret<-ginhist2d( y=immodat$lat, x=immodat$lon,val=immodat$qm, nbins = 20, col=mycol, func="mean")


str(im.ret)
a<-im.ret
b<-as.matrix(a)
b[1,2:5]
attributes(a)

mm<-as.matrix(im.ret)
print(c(i,j))
i=2
j=3
if (mm[i,j]!=0){
  text(xx[i]+(xx[2]-xx[1])/2, yy [j], i, pos=3)
}

str(im.ret)

im.unl<-unlist(im.ret)



a[,1]
a[1,1]==0.0


im.unl
load("DEU_adm1.RData")

a<-gadm@polygons[[1]]

for (i in 1:16)
{
  poly<-gadm@polygons[[i]]@Polygons
  print(  length(poly))

  for (j in 1:length(poly))
  {
    lines(poly[[j]])
  }
}
  

