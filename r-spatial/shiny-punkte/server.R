library(shiny)
library(sp)
library(rgeos)    # Polygonberechnungen
#options(warn=-1)

load('DEU_adm1.RData')
load('immodat.RData')

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    ###################### Reactive ###########################
    
#     print(input$xrange)
#     
#     print(input$yrange)
 plot(gadm, xlim=input$xrange/10, ylim=input$yrange/10)
 points(immodat$lon, immodat$lat)

 
#     deSubInd<-which(gadm$NAME_1 == input$bundesland)
#     deSub<-gadm[deSubInd,]
#     
#     labPt <- getSpPPolygonsLabptSlots(deSub) 
#     
# #     minLat<-min(labPt[,1])
# #     maxLat<-max(labPt[,1])
# #     minLon<-min(labPt[,2])
# #     maxLon<-max(labPt[,2])
#      
#     if (input$colormap=="rainbow"){
#     cols<-rainbow(input$ncols)
#     } 
#     else if (input$colormap=="heat")
#     {
#       cols<-heat.colors(input$ncols)
#     }
#     else if (input$colormap=="terrain")
#     {
#       cols<-terrain.colors(input$ncols)
#     }
#         
#     plot(deSub, col=cols)
#     #xlim=c(minLat, maxLat), ylim=c(minLon, maxLon)
#     
#     if (input$names)
#     {
#       numKr<-length(deSub)
#      
#       namesKr<-deSub$NAME_3
#       for(i in 1:numKr)
#       {
#         text(labPt[i,1],labPt[i,2],namesKr[i], cex=0.7 )
#       }
#     }
#     
#     if (input$showgrid)
#     {
#       grid(col="black")
#     }



    ###################### Ende Reactive ###########################
  })
})