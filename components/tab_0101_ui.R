div(
  # 1st row information
  fluidRow(
    column(
      3, 
      div(
        class = "card text-white bg-warning mb-3",
        div(
          class="card-body",
          h3(textOutput("total_confirmed")),
          hr(),
          p("Total Confirmed", class="card-text")
        ),
      ),
    ),
    column(
      3, 
      div(
        class = "card text-white bg-success mb-3",
        div(
          class="card-body",
          h3(textOutput("total_recovered")),
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
          h3(textOutput("total_deaths")),
          hr(),
          p("Total Deaths", class="card-text")
        ),
      ),
    ),
    column(
      3, 
      div(
        class = "card text-white bg-light mb-3",
        div(
          class="card-body",
          h3(textOutput("total_countries")),
          hr(),
          p("Total Countries", class="card-text"),
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
          p("The table below shows confirmed cases of COVID-19 around the world"),
          DT::dataTableOutput("case_by_country")
        ),
      ),
    ),
    column(
      9, 
      wellPanel(
        style="height:670px",
        p("The map represents the statistics based on the registered location (lat/long) information for the COVID-19 cases. 
          The RED circles on the map portrays the list of confirm cases, recovered cases, and deaths"),
        plotlyOutput("case_on_map"),
        h6("*Data source: BNO NEWS", style="margin-top: 180px; text-align: right;color: #BDCED6;"),
      ),
    ),
  ),  # End of 2nd row
  
  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)

