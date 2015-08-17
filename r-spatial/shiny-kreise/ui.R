library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Kreise im Bundesland"),
 
  sidebarLayout(
    sidebarPanel(
      
      ######################## Sidebar ######################
      
    
      selectInput("bundesland", "Bundesland:", 
                  choices = c(
                    "Bayern","Berlin","Brandenburg","Bremen",
                    "Hamburg","Hessen","Mecklenburg-Vorpommern","Niedersachsen","Nordrhein-Westfalen",
                    "Rheinland-Pfalz","Saarland","Sachsen","Sachsen-Anhalt","Schleswig-Holstein",
                    "Th?ringen")),
      checkboxInput("names", "Namen anzeigen", FALSE),
      checkboxInput("showgrid", "Gitter anzeigen", FALSE)
      ######################## Ende Sidebar ######################
    ),
    

    mainPanel(
      ######################## Main Panel ######################

      plotOutput("distPlot", height = 700, width = 500)
      ######################## Ende Main Panel ######################
    )
  )
))