div(
  # 1st row information
  fluidRow(
    column(
      9, 
      wellPanel(
        pickerInput(
          inputId = "xchIndex",
          label = "Select Exchange Index:",
          multiple = TRUE,
          choices = c("Nasdaq"="NQ.F.High","S&P 500"="GSPC.High","Alphabet Inc"="GOOG.High","Apple Inc"="AAPL.High","Dow Jones Industrial Average"="DJI.High"),
          selected = c("Nasdaq"="NQ.F.High")
        ),
        plotlyOutput("exchange_index"),
        h6("The stock index started to decline almost 3 weeks after the global outbreak of COVID-19."),
        h6("*Data source: BNO NEWS and Our World in Data", style="text-align: right;color: #BDCED6;")
      ),
    ),
    
    # 2nd column for twitter display
    column(
      3, 
      wellPanel(
        tags$div(
          HTML(
            '
            <lable>#COVID19 Tweet Trend
              <i class="fab fa-twitter-square"></i>
            </lable>
            <br/>
            '
          )
        ),
        div(
          class="alert alert-dismissible alert-warning",
          p(htmlOutput("twitter1"))
        ),
        div(
          class="alert alert-dismissible alert-warning",
          p(htmlOutput("twitter2"))
        ),
        div(
          class="alert alert-dismissible alert-warning",
          p(htmlOutput("twitter3"))
        ),
        div(
          class="alert alert-dismissible alert-warning",
          p(htmlOutput("twitter4"))
        ),
      ),
    ),  # End of 2nd column
  ),
  
  fluidRow(
    column(
      6,
      wellPanel(
        pickerInput(
          inputId = "Confirm_case_log",
          label = "China, Europe, US and Others Confirmed Cases",
          choices = c("Normal Scale" = "normal", "Log Scale" = "log"),
          selected = c("Normal Scale" = "normal")
        ),
        
        plotlyOutput("china_other", height = "355px"),
        h6("Initially, the outbreak was in china and around mid of march Europe became the epicentre of the outbreak."),
        h6("*Data source: BNO NEWS and Our World in Data", style="text-align: right;color: #BDCED6;")
      ),
    ),
    column(
      6,
      wellPanel(
        p("China, Europe, US and Othesr Fatility Rate"),
        plotlyOutput("china_other_fatility"),
        h6("The graph shows the fatality ratio (total deaths/ total confirmed cases in a country). China's rate saturated close to 4%. Europe has the highest case fatality ratio (6%) and still increasing."),
        h6("*Data source: BNO NEWS and Our World in Data", style="text-align: right;color: #BDCED6;")
      )
    ),
  ),
  
  fluidRow(
    column(
      6,
      wellPanel(
        p("Number of Daily Confirmed Cases"),
        plotlyOutput("new_confirmedc_case"),
        h6("The peak in China on Feb 13 2020 was due to the change of how the cases were defined. Similar to fatality ratio, the new cases continue to rise in the rest of the world."),
        h6("*Data source: BNO NEWS and Our World in Data", style="text-align: right;color: #BDCED6;")
      ),
    ),
    column(
      6,
      wellPanel(
        p("Number of Daily Death Cases"),
        plotlyOutput("daily_death_case"),
        h6("China had an average of 150 deaths in a day during the peak. Europe has more deaths in a single day mainly due to deaths in Italy and Spain."),
        h6("*Data source: BNO NEWS and Our World in Data", style="text-align: right;color: #BDCED6;")
      )
    ),
  ),
  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)
