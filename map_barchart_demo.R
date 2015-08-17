ddf = read.table(header=T, sep=",", text="
country, val1, val2, val3
Nigeria,5,10,8
China,8,12,20
Brazil,15,9,20
Italy,9,25,5
Australia,15,5,25
")
library(rworldmap)
i=1
ddf[1,]

library(Hmisc)


sPDF <- joinCountryData2Map(ddf
                            , joinCode = "NAME"
                            , nameJoinColumn = "country"
                            , verbose = TRUE)

df <- merge(x=ddf, y=sPDF@data[sPDF@data$ADMIN, c("ADMIN", "LON", "LAT")], by.x="country", by.y="ADMIN", all.x=TRUE)


plot(getMap())
for (i in 1:5)
{
  subplot(
    plot(ddf[,i],axes=F,xlab = "", ylab="", type="l",lwd=5) 
    
      
#     barplot(height=as.numeric(as.character(unlist(df[i, 2:4], use.names=F))), 
#               
#                   col=rainbow(3), ylim=range(df[,2:4]))
#           
          
          ,x=df[i, 'LON'], y=df[i, 'LAT'], size=c(.3, .3))

}
legend("topright", legend=names(df[, 2:4]), fill=rainbow(3))