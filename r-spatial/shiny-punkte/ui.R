library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Kreise im Bundesland"),
 
  sidebarLayout(
    sidebarPanel(
      
      ######################## Sidebar ######################
      sliderInput("xrange", "X-Koordinaten:",
                  min = 60, max = 150, value = c(50,150)),
      
      sliderInput("yrange", "Y-Koordinaten:",
                  min = 470, max = 560, value = c(470,560))
      
#       selectInput("colormap", "Colormap:", 
#                   choices = c(
#                     "heat","terrain","rainbow")),      
#       
#       sliderInput("ncols",
#                   "Anz. Farben",
#                   min = 1,
#                   max = 20,
#                   value = 1),
#       
#       selectInput("bundesland", "Bundesland:", 
#                   choices = c(
#                     "Baden-W?rttemberg","Bayern","Berlin","Brandenburg","Bremen",
#                     "Hamburg","Hessen","Mecklenburg-Vorpommern","Niedersachsen","Nordrhein-Westfalen",
#                     "Rheinland-Pfalz","Saarland","Sachsen","Sachsen-Anhalt","Schleswig-Holstein",
#                     "Th?ringen")),
#       checkboxInput("names", "Namen anzeigen", FALSE),
#       checkboxInput("showgrid", "Gitter anzeigen", FALSE)
      ######################## Ende Sidebar ######################
    ),
    

    mainPanel(
      ######################## Main Panel ######################
      plotOutput("distPlot", height = 700, width = 400)
      ######################## Ende Main Panel ######################
    )
  )
))