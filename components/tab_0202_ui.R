div(
  # 1st row information
  fluidRow(
    column(
      6, 
      wellPanel(
        p("Age and Gender analysis"),
        plotlyOutput("age_recovery_rate"),
        h6("The visual displays the age and gender breakdown among the infected and recovered cases in Singapore."),
        h6("*Data source: MOH, Singapore", style="text-align: right;color: #BDCED6;")
      )
    ),  # End of 1st column
    
    # 2nd column for twitter display
    column(
      6, 
      wellPanel(
        p("How long it takes for peopleto become symptomatic"),
        plotlyOutput("age_time_symptotic"),
        h6("People might be anxious whether they have COVID-19 or not. There are quite a few records above 14 days but most people report symptoms around 14 days."),
        h6("*Data source: MOH, Singapore", style="text-align: right;color: #BDCED6;")
      ),
    ),  # End of 2nd column
  ),
  
  fluidRow(
    # 3rd column for twitter display
    column(
      12, 
      wellPanel(
        p("Distribution of total infected with respect to local and foreign transmission"),
        plotlyOutput("local_forg_trans_rate"),
        h6("The graph differentiates between local and imported cases in the daily reports. Earlier, there are few local cases reported but when other countries started to lock down the number of imported cases started to increase."),
        h6("*Data source: MOH, Singapore", style="text-align: right;color: #BDCED6;")
      ),
    ),  # End of 3rd column
  ),
  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)
