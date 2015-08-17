library(shiny)
library(sp)
library(rgeos)    # Polygonberechnungen
#options(warn=-1)
setwd("E:/Work/immo/r-spatial/shiny-hist")

load('DEU_adm1.RData')
load('immodat.RData')

# y=immodat$lat
# x=immodat$lon
# str(immodat)
#immodat$preis_pqm<-immodat$preis/immodat$qm
#save(file="immodat.Rdata", list="immodat")

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    
    ###################### Reactive ###########################
    #mycol<-colorRampPalette(c("#ffffff", "#003193"))(50)
    
    mycol<-c("#ffffff", colorRampPalette(c("#A6B7D9", "#003193"))(input$ncols))
    
    
    valchoice<-immodat[,input$val]

    ginhist2d( y=immodat$lat, x=immodat$lon,val=valchoice, nbins = input$nbins,col=mycol, func_choice="mean")
    
                    
    a<-gadm@polygons[[1]]
    
    if (input$grenz){
    for (i in 1:16)
    {
      poly<-gadm@polygons[[i]]@Polygons
     
      
      for (j in 1:length(poly))
      {
        lines(poly[[j]])
      }
    }
    }
    
    

    ###################### Ende Reactive ###########################
  })
})