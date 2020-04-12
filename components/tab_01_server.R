####---- Twitter input parameters ----####
tweet1 <- reactiveValues(data = NULL)
tweet2 <- reactiveValues(data = NULL)
tweet3 <- reactiveValues(data = NULL)
tweet4 <- reactiveValues(data = NULL)
tweet5 <- reactiveValues(data = NULL)


####---- Reading Twitter ----####
observe({
  
  # Re-execute this reactive expression after 1000 milliseconds
  invalidateLater(30000, session)
  
  rstats_tweets <- search_tweets(q = "#covid19 filter:news", n = 5, lang = "en", include_rts = FALSE)
  tweet1$data <- as.character(rstats_tweets$text[1])
  tweet2$data <- as.character(rstats_tweets$text[2])
  tweet3$data <- as.character(rstats_tweets$text[3])
  tweet4$data <- as.character(rstats_tweets$text[4])
  tweet5$data <- as.character(rstats_tweets$text[5])
  
  # print(paste("", Sys.time(), tweet1$data))
  # print(paste("", Sys.time(), tweet2$data))
  # print(paste("", Sys.time(), tweet3$data))
  # print(paste("", Sys.time(), tweet4$data))
})


####---- Display Total Confirmed Cases Count ----####
output$total_confirmed <- renderText({
  
  hr <- as.numeric(format(Sys.time(), "%H"))
  if(hr >= 2)
    showNotification(paste("Last updated data at", format(Sys.Date(), "%d-%m-%Y"), "10:00 A.M"), duration = NULL, type="message")
  else
    showNotification(paste("Last updated data at", format(Sys.Date()-1, "%d-%m-%Y"), "10:00 A.M"), duration = NULL, type="message")
  
  
  return(as.character(formatC(g_total_confirmed,format="d", big.mark=",")))
})


####---- Display Total Recovered Cases ----####
output$total_recovered <- renderText({
  
  return(as.character(formatC(g_total_recovered,format="d", big.mark=",")))
})


####---- Display Total Deaths Cases ----####
output$total_deaths <- renderText({
  
  return(as.character(formatC(g_total_deaths,format="d", big.mark=",")))
})


####---- Display Total Infected Counties Count ----####
output$total_countries <- renderText({
  
  return(as.character(formatC(g_total_countries,format="d", big.mark=",")))
})


####---- Display Country wise information Table ----####
output$case_by_country <- renderDataTable({

  DT::datatable(g_case_by_country, rownames = NULL, options = list(scrollX = TRUE))
})


####---- Display Twitter 1 Data ----####
output$twitter1 <- renderText({
  
  HTML(str_replace_all(tweet1$data, tweet_pattern, ""))

})


####---- Display Twitter 2 Data ----####
output$twitter2 <- renderText({
  
  HTML(str_replace_all(tweet2$data, tweet_pattern, ""))
  
})


####---- Display Twitter 3 Data ----####
output$twitter3 <- renderText({
  
  HTML(str_replace_all(tweet3$data, tweet_pattern, ""))
  
})


####---- Display Twitter 4 Data ----####
output$twitter4 <- renderText({
  
  HTML(str_replace_all(tweet4$data, tweet_pattern, ""))
  
})


####---- Display Twitter 5 Data ----####
output$twitter5 <- renderText({
  
  HTML(str_replace_all(tweet5$data, tweet_pattern, ""))
  
})


####---- Display map for infacted ----####
output$case_on_map <- renderPlotly({
  
  fig <- g_case_on_map %>% plot_mapbox(lat = ~Latitude, lon = ~Longitude, size= ~Confirmed,
                             color=I("red"),
                             text=~paste("Country: ",Country,"<br>","Confirmed Cases: ",Confirmed,"<br>",
                                         "Deaths : ",Deaths,"<br>","Recovered Cases: ",Recovered,"<br>",sep = "" ),
                             mode = 'scattermapbox', hoverinfo='text',alpha =0.7)
  
  fig <- fig %>% layout(height = 560,
    font = list(color='white'),
    plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
    mapbox = list(style = 'dark'),
    legend = list(orientation = 'h', font = list(size = 8)),
    margin = list(l = 25, r = 25,
                  b = 25, t = 25,
                  pad = 4))
})


####---- Display Exchange Index plot ----####
output$exchange_index <- renderPlotly({
  
  ay <- list(
    tickfont = list(color = "white"),
    overlaying = "y",
    side = "right"
  )
  
  idx = 0
  for(col in input$xchIndex){
    idx = idx + 1
    print(col)
    
    if(col == "NQ.F.High")
      lname = "Nasdaq"
    else if(col == "GSPC.High")
      lname = "S&P 500"
    else if(col == "GOOG.High")
      lname = "Alphabet Inc"
    else if(col == "AAPL.High")
      lname = "Apple Inc"
    else if(col == "DJI.High")
      lname = "Dow Jones"
    
    if (idx == 1)
      fig <- plot_ly(XCH_Data, x = ~date, y = as.formula(paste0("~`", col, "`")), name = lname, type = 'scatter', mode = 'lines')
    if(idx > 1)
      fig <- fig %>% add_trace(y =as.formula(paste0("~`", col, "`")), name = lname, type = 'scatter', mode = 'lines') 
  }
  
  print("Y2")
  fig <- fig %>% add_trace(y= ~Confirmed, name = "Confirmed Case", yaxis = "y2", type = 'scatter', mode = 'lines')
  fig <- fig %>% layout(legend = list( font = list(color = "#ffffff"))) %>%
                 layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
                        yaxis = list(title="", color = '#ffffff'),
                        yaxis2 = ay, plot_bgcolor='#303030', paper_bgcolor='#303030')    

  fig

})


####---- Display China and Other compare plot ----####
output$china_other <- renderPlotly({
  
  countyWiseCount_df <- countyWiseCount(input$Confirm_case_log)
  
  fig <- plot_ly(countyWiseCount_df, x = ~LastUpdate, y = ~China, type = 'scatter', mode = 'lines', name = 'China', color = '#9119b8' , line=list(color='#6EB005')) %>% 
    add_trace(y = ~Others, name = 'Others', line = list(color = '#FFEF00')) %>%
    add_trace(y = ~US, name = 'US', line = list(color = '#EF5D43')) %>%
    add_trace(y = ~Europe, name = 'Europe', line = list(color = '#971A5A')) %>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  fig
})


####---- Display China and Other fatility ratio ----####
output$china_other_fatility <- renderPlotly({
  
  china_other_fatility_df <- chinaOtherFatility()
  
  fig <- plot_ly(china_other_fatility_df, x = ~LastUpdate, y = ~China, type = 'scatter', mode = 'lines', name = 'China') %>% 
    add_trace(y = ~Others, name = 'Others', line = list(color = '#FFEF00')) %>%
    add_trace(y = ~US, name = 'US', line = list(color = '#EF5D43')) %>%
    add_trace(y = ~Europe, name = 'Europe', line = list(color = '#971A5A')) %>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')

  fig
})


####---- Daily new_confirmed cases ----####
output$new_confirmedc_case <- renderPlotly({
  
  newConfirmedCase_df <- newConfirmedCase()
  
  fig <- plot_ly(newConfirmedCase_df, x = ~LastUpdate, y = ~China, type = 'scatter', mode = 'lines', name = 'China', color = '#9119b8' , line=list(color='#6EB005')) %>% 
    add_trace(y = ~Others, name = 'Others', line = list(color = '#FFEF00')) %>%
    add_trace(y = ~US, name = 'US', line = list(color = '#EF5D43')) %>%
    add_trace(y = ~Europe, name = 'Europe', line = list(color = '#971A5A')) %>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  fig
})


####---- Daily new death cases ----####
output$daily_death_case <- renderPlotly({
  
  dailyDeathCase_df <- dailyDeathCase()
  
  fig <- plot_ly(dailyDeathCase_df, x = ~LastUpdate, y = ~China, type = 'scatter', mode = 'lines', name = 'China') %>% 
    add_trace(y = ~Others, name = 'Others', line = list(color = '#FFEF00')) %>%
    add_trace(y = ~US, name = 'US', line = list(color = '#EF5D43')) %>%
    add_trace(y = ~Europe, name = 'Europe', line = list(color = '#971A5A')) %>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  fig
})


####----- Display Word Cloud ----####
output$word_freq <- renderPlot({
  
  withProgress(message = 'Plotting Word Cloud...', {
    for(i in 1:N){
      
      # Long Running Task
      Sys.sleep(1)
      
      # Update progress
      incProgress(1/N)
    }
    
    twitter_word_freq <- get_wordcloud()
    word_cloud <- comparison.cloud(twitter_word_freq[, (ncol(twitter_word_freq)-7):ncol(twitter_word_freq)],
                                   scale=c(6,1), random.order=FALSE, max.words=500)
    
    return(word_cloud)  
  })
})

