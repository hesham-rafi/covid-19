div(
  # 1st row information
  fluidRow(
    column(
      3, 
      div(
        class = "card text-white bg-info mb-3",
        div(
          class="card-body",
          h3(textOutput("id_total_confirmed")),
          hr(),
          p("Total Confirmed", class="card-text")
        ),
      ),
    ),
    column(
      3, 
      div(
        class = "card text-white bg-light mb-3",
        div(
          class="card-body",
          h3(textOutput("id_total_current")),
          hr(),
          p("New Cases", class="card-text"),
        ),
      ),
    ),
    column(
      3, 
      div(
        class = "card text-white bg-success mb-3",
        div(
          class="card-body",
          h3(textOutput("id_total_recovered")),
          hr(),
          p("Total Recovered", class="card-text")
        ),
      ),
    ),
    column(
      3, 
      div(
        class = "card text-white bg-danger mb-3",
        div(
          class="card-body",
          h3(textOutput("id_total_deaths")),
          hr(),
          p("Total Deaths", class="card-text")
        ),
      ),
    ),
  ),  # End of 1st row
  
  # 2nd row information
  fluidRow(
    column(
      3, 
      div(
        wellPanel(
          class="card text-black bg-light",
          p("The table shows the statistics of each provinces in Indonesia"),
          DT::dataTableOutput("id_case_by_province"),
        ),
      ),
    ),
    column(
      9, 
      wellPanel(
        style="height:670px",
        p("The map represents the statistics based on the registered location (lat/long) information for the COVID-19 cases. 
          The RED circles on the map portrays the list of confirm cases, recovered cases, and deaths"),
        plotlyOutput("id_case_on_map"),
        h6("*Data source: https://bnpb-inacovid19.hub.arcgis.com/datasets", style="margin-top: 180px; text-align: right;color: #BDCED6;"),
      ),
    ),
  ),  # End of 2nd row
  
  # 3rd row information
  fluidRow(
    column(
      4, 
      div(
        wellPanel(
          p("Confirmed cases In Indonesia"),
          plotlyOutput("id_total_cases_plot"),
          h6("The graph represents the total confirmed cases in Indonesia."),
          h6("*Data source: https://bnpb-inacovid19.hub.arcgis.com/datasets", style="text-align: right;color: #BDCED6;")
        ),
      ),
    ),
    column(
      4, 
      div(
        wellPanel(
          p("Number of daily confirmed cases In Indonesia"),
          plotlyOutput("id_total_new_cases_plot"),
          h6("The graph represents the daily confirmed cases in Indonesia."),
          h6("*Data source: https://bnpb-inacovid19.hub.arcgis.com/datasets", style="text-align: right;color: #BDCED6;")
        ),
      ),
    ),
    column(
      4, 
      div(
        wellPanel(
          p("Number of deaths In Indonesia"),
          plotlyOutput("id_total_deaths_plot"),
          h6("The graph represents the total deaths in Indonesia."),
          h6("*Data source: https://bnpb-inacovid19.hub.arcgis.com/datasets", style="text-align: right;color: #BDCED6;")
        ),
      ),
    ),
  ),  # End of 3rd row

  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)

