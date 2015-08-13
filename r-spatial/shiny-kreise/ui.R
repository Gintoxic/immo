library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Kreise im Bundesland"),
 
  sidebarLayout(
    sidebarPanel(
      
      ######################## Sidebar ######################
      
      selectInput("colormap", "Colormap:", 
                  choices = c(
                    "heat","terrain","rainbow")),      
      
      sliderInput("ncols",
                  "Anz. Farben",
                  min = 1,
                  max = 20,
                  value = 1),
      
      selectInput("bundesland", "Bundesland:", 
                  choices = c(
                    "Baden-W?rttemberg","Bayern","Berlin","Brandenburg","Bremen",
                    "Hamburg","Hessen","Mecklenburg-Vorpommern","Niedersachsen","Nordrhein-Westfalen",
                    "Rheinland-Pfalz","Saarland","Sachsen","Sachsen-Anhalt","Schleswig-Holstein",
                    "Th?ringen")),
      checkboxInput("names", "Namen anzeigen", FALSE),
      checkboxInput("showgrid", "Gitter anzeigen", FALSE)
      ######################## Ende Sidebar ######################
    ),
    

    mainPanel(
      ######################## Main Panel ######################
      plotOutput("distPlot")
      ######################## Ende Main Panel ######################
    )
  )
))