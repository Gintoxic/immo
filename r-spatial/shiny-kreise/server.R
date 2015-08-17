library(shiny)
library(sp)
library(rgeos)    # Polygonberechnungen
#options(warn=-1)

load('DEU_adm3.RData')

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    ###################### Reactive ###########################
 #plot(gadm)
    deSubInd<-which(gadm$NAME_1 == input$bundesland)
    deSub<-gadm[deSubInd,]
 plot(deSub)
#     
     labPt <- getSpPPolygonsLabptSlots(deSub) 
#     
# #     minLat<-min(labPt[,1])
# #     maxLat<-max(labPt[,1])
# #     minLon<-min(labPt[,2])
# #     maxLon<-max(labPt[,2])
#      

    if (input$names)
    {
      numKr<-length(deSub)
     
      namesKr<-deSub$NAME_3
      for(i in 1:numKr)
      {
        text(labPt[i,1],labPt[i,2],namesKr[i], cex=0.7 )
      }
    }
    
    if (input$showgrid)
    {
      grid(col="black")
    }

    title(input$bundesland)

    ###################### Ende Reactive ###########################
  })
})