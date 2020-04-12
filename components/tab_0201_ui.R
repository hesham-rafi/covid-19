div(
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        width = 4, 
        
        div(
          class = "card text-white bg-warning mb-3",
          div(
            class="card-body",
            h3(textOutput("sg_dorscon")),
            hr(),
            p("DORSCON Level", class="card-text")
          ),
        ),

        div(
          class = "card text-white bg-info mb-3",
          div(
            class="card-body",
            h3(textOutput("sg_total_confirmed")),
            hr(),
            p("Total Confirmed", class="card-text")
          ),
        ),

        div(
          class = "card text-white bg-light mb-3",
          div(
            class="card-body",
            h3(textOutput("sg_total_current")),
            hr(),
            p("New Cases", class="card-text"),
          ),
        ),
        
        div(
          class = "card text-white bg-success mb-3",
          div(
            class="card-body",
            h3(textOutput("sg_total_recovered")),
            hr(),
            p("Total Recovered", class="card-text")
          ),
        ),
        
        div(
          class = "card text-white bg-danger mb-3",
          div(
            class="card-body",
            h3(textOutput("sg_total_deaths")),
            hr(),
            p("Total Death", class="card-text")
          ),
        ),
        
        
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Infected Area",
                             wellPanel(
                               style="height:850px",
                               p("Shows the full picture of COVID-19 case clusters in Singapore."),
                               plotlyOutput("map_infect_area"),
                               h6("*Data source: MOH, Singapore", style="margin-top: 370px; text-align: right;color: #BDCED6;")
                             )
                    ),
                    tabPanel("Hospital",
                             wellPanel(
                               style="height:850px",
                               p("Shows the full picture of COVID-19 cases admitted in Singapore hospitals."),
                               plotlyOutput("map_infect_hospital"),
                               h6("*Data source: MOH, Singapore", style="margin-top: 370px; text-align: right;color: #BDCED6;")
                             )
                    ),
                    tabPanel("Nearest Cluster",
                             wellPanel(
                               style="height:990px",
                               h4("User can search for the nearest COVID-19 cluster, to check how close they are to one, and then take any necessary precautions."),
                               fluidRow(
                                 column(
                                   3,
                                   numericInput("postal_code", label = "Enter Postal Code:", value = NA, min = 0, max = NA, step = NA)
                                 ),
                                 
                                 column(
                                   2,
                                   actionButton("cmd_postal_code", "Get Nearest Cluster", style="margin-top: 25px;")
                                 ),
                               ),
                               
                               fluidRow(
                                 textOutput("distance"),
                                 br(),
                                 plotlyOutput("map_nearest_cluster")
                               ),
                               h6("*Data source: MOH, Singapore", style="margin-top: 370px; text-align: right;color: #BDCED6;")
                             )
                    ),
                    tabPanel("Nearest Clinic",
                             wellPanel(
                               style="height:950px",
                               h4("Users can get the information about the nearest PHPC activated clinic and also search for directions in google."),
                               fluidRow(
                                 column(
                                   3,
                                   numericInput("postal_code_cln", label = "Enter Postal Code:", value = NA, min = 0, max = NA, step = NA)
                                 ),
                                 
                                 column(
                                   2,
                                   actionButton("cmd_postal_code_cln", "Get Nearest Clinic", style="margin-top: 25px;")
                                 ),
                               ),
                               
                               fluidRow(
                                 plotlyOutput("map_nearest_cln")
                               ),
                               h6("*Data source: www.flugowhere.gov.sg", style="margin-top: 370px; text-align: right;color: #BDCED6;")
                             )
                    )
        )
      )
    )
  ),
  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)
