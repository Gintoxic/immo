library(shiny)
library(sp)
library(rgeos)    # Polygonberechnungen
#options(warn=-1)

load('DEU_adm1.RData')
load('immodat.RData')

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    ###################### Reactive ###########################
 plot(gadm, xlim=input$xrange/10, ylim=input$yrange/10)
 points(immodat$lon, immodat$lat, pch=20)

  t=1
  tr<-c(immodat$lon[t], immodat$lat[t])

  for (i in 1:2909)
  {
    lo<-c(immodat$lon[t],immodat$lon[i])
    la<-c(immodat$lat[t],immodat$lat[i])
    
    lines(lo,la, col="blue3")
  
  }

    ###################### Ende Reactive ###########################
})

output$histPlot <- renderPlot({
 
  plot(1, mar=c(0,0,0,0))
  })


})