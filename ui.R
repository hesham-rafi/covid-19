#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


####---- Define UI for application that draws a histogram ----####
shinyUI(
  fluidPage( 
    theme = shinytheme("darkly"),
    
    # Load css file and javaScript file
    shiny::singleton(
      shiny::tags$head(
        tags$link(rel = "stylesheet", href = "appStyle.css"),
      )
    ),
    
    # h2(prjNameFull),
    navbarPage(id = "tags",
      title = div(p("COVID-19")),
               
      # Welcome Menu
      tabPanel(
        title <- tabWelcome,
        icon = icon("list-alt"),
        source('components/welcome_ui.R', local=TRUE)$value
      ),
      
      # Global Information
      tabPanel(
        title <- tab01,
        tabsetPanel(type = "tabs",
                    tabPanel(Tab01_1,
                             source('components/tab_0101_ui.R', local=TRUE)$value
                    ),
                    tabPanel(Tab01_2,
                             source('components/tab_0102_ui.R', local=TRUE)$value
                    ),
                    tabPanel(Tab01_3,
                             source('components/tab_0103_ui.R', local=TRUE)$value
                    )
        ),
      ),
      
      # Runing the model
      tabPanel(
        title <- tab02,
        tabsetPanel(type = "tabs",
                    tabPanel(Tab01_1,
                             source('components/tab_0201_ui.R', local=TRUE)$value
                    ),
                    tabPanel(Tab01_2,
                             source('components/tab_0202_ui.R', local=TRUE)$value
                    )
        ),
      ),
      
      collapsible = TRUE,
      windowTitle = prjNameShort
    )   # END of navbarPage
  )
)
