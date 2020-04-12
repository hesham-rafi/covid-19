####---- Display Total Confirmed Cases Count ----####
output$id_total_confirmed <- renderText({
  
  return(as.character(g_total_id_confirmed))
})


####---- Display Total Recovered Cases ----####
output$id_total_recovered <- renderText({
  
  return(as.character(g_total_id_recovered))
})


####---- Display Total Deaths Cases ----####
output$id_total_deaths <- renderText({
  
  return(as.character(g_total_id_deaths))
})


####---- Display Total Deaths Cases ----####
output$id_total_current <- renderText({
  
  return(as.character(g_total_id_current))
})


####---- Display province wise information Table ----####
output$id_case_by_province <- renderDataTable({
  
  id_case_by_province <- g_id_case_by_province %>%
    filter(Case_Date == (Sys.Date()-1)) %>%
    select(Provinces, Cases, Recovered, Death)
  
  DT::datatable(id_case_by_province, rownames = NULL, options = list(scrollX = TRUE))
})


####---- Display map for infacted ----####
output$id_case_on_map <- renderPlotly({
  
  fig <- g_id_case_by_province %>%
    filter(Case_Date == Sys.Date()-1) %>%
    plot_mapbox(mode = 'scattermapbox') %>%
    add_markers(y = ~geometry.y, x = ~geometry.x, size= ~ (`Cases`),
                color=I("red"),
                marker=list(sizeref=0.1, sizemode="area"),
                text=~paste("Location: ",Provinces,"<br>","Total Confirmed Cases: ", Cases, sep = "" ),
                hoverinfo="text",alpha=0.7) %>%
    layout(height = 560,
      font = list(color='white'),
      plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
      mapbox = list(style = 'dark',zoom =4,
                    center = list(lon = 113.9213, lat = -0.7893)),
      legend = list(orientation = 'h',
                    font = list(size = 8)),
      margin = list(l = 25, r = 25,
                    b = 25, t = 25,
                    pad = 2)
    )

    fig
})


####---- Total Cases Plot ----####
output$id_total_cases_plot <- renderPlotly({
  
  fig <- plot_ly(g_id_overall_case, x = ~date, y = ~attributes.Jumlah_Kasus_Kumulatif, type = 'scatter', mode = 'lines', name = 'New Cases') %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')

  fig
})


####---- Total New Cases Plot ----####
output$id_total_new_cases_plot <- renderPlotly({
  
  fig <- plot_ly(g_id_overall_case, x = ~date, y = ~attributes.Jumlah_Kasus_Baru_per_Hari, type = 'scatter', mode = 'lines', name = 'New Cases', line=list(color='#6EB005')) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  fig
})

####---- Total deaths Cases Plot ----####
output$id_total_deaths_plot <- renderPlotly({
  
  fig <- plot_ly(g_id_overall_case, x = ~date, y = ~attributes.Jumlah_Pasien_Meninggal, type = 'scatter', mode = 'lines', name = 'New Cases', line=list(color='#EF5D43')) %>%
    layout(xaxis = list(title="", tickangle = -45, color = '#ffffff'),
           yaxis = list(title="", color = '#ffffff'), 
           plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  fig
})