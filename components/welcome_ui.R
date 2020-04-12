fluidPage(
  div(class="jumbotron welcome_panel",
      h3("Background on 'Yet Another COVID-19 Dashboard'", class="display-3"),
      br(),
      p("COVID-19 (Coronavirus) is an infectious disease caused by a newly discovered coronavirus and has now been classified by WHO as a pandemic."),
      br(),
      p("The purpose of this 'Yet Another COVID-19 Dashboard' is to aggregate existing research, bring together the relevant data, and allow users to make sense of the published data on the coronavirus outbreak."),
      br(),
      p("We do not intend to make any predictions using the data, as this is best left to epidemiologists, Public Health, and virology experts. This is simply an effort to present some useful visualizations based on various data sources in a single dashboard. We also acknowledge all the other researchers around the world who have created similar dashboards, and hence the name 'Yet Another COVID Dashboard'."),
      br(),
      p("This interactive dashboard shows the spread of the COVID-19 virus around the world and in particular in Singapore since late January. Singapore had its 1st COVID-19 case on 23rd Jan 2020. Singapore is one of the countries which managed to slow down the spread among people. WHO praised Singapore for the steps taken in containing the outbreak of the virus."),
      br(),
      p("Further, Using this dashboard we aim to provide a visual representation for the following questions:"),
      tags$ul(
        tags$li("How are the major financial indicators behaving during this pandemic??"),
        tags$li("Global tracker of the COVID-19 fatalities, recovery rates, and infection rates."),
        tags$li("Basic text analytics on what the twitter world saying about COVID-19?"),
        tags$li("Is the COVID-19 near me (Singapore)?"),
        tags$ul(
          tags$li("A search functionality to check the distance between you and the nearest cluster (for Singapore)")
        ),
        tags$li("Where does one go if they are sick (Singapore)?"),
        tags$ul(
          tags$li("A search and mapping functionality to the nearest PHPC clinic (for Singapore)")
        ),
        tags$li("We plan to expand the dashboard to the rest of Asia (India, Japan, Korea, and other major countries in Southeast Asia)")
      ),
      br(),
      p("As we are doing it outside our full-time job, we are trying our best to keep the dashboard updated once a day. Feel free to drop us a line if you find this useful: covid19sg.dashboard@gmail.com"),
      br(),
      p("Stay healthy and safe!"),
      br(),
      br(),
      
      fluidRow(
        column(
          2,
        ),
        
        column(
          3,
          div(style = "text-align: center;",
              tags$button(id = "cmd_global", style = "color: white; width: 100%;", type = "button", class = "btn action-button btn-primary btn-lg", "Global")
          ),
        ),
        
        column(
          2,
        ),
        
        column(
          3,
          div(style = "text-align: center;",
              tags$button(id = "cmd_sing", style = "color: white; width: 100%;", type = "button", class = "btn action-button btn-primary btn-lg", "Singapore")
          ),
        ),
      ),
      br(),
      h6(strDisclaimer),
  ),
  
  # br(),
  # br(),
  # hr(),
  # h6(strFooter, style = "text-align: center;")
  
) # END of Welcome fluidpage
