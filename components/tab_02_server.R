####---- Display DORSCON Level ----####
output$sg_dorscon <- renderText({
  
  return(as.character(g_sg_dorscon))
})


####---- Display Total Confirmed Cases Count ----####
output$sg_total_confirmed <- renderText({
  
  return(as.character(g_total_sg_confirmed))
})


####---- Display Total Recovered Cases ----####
output$sg_total_recovered <- renderText({
  
  return(as.character(g_total_sg_recovered))
})


####---- Display Total Deaths Cases ----####
output$sg_total_deaths <- renderText({
  
  return(as.character(g_total_sg_deaths))
})


####---- Display Total Deaths Cases ----####
output$sg_total_current <- renderText({
  
  return(as.character(g_total_sg_current))
})


####---- Create map for Infected Area ----####
output$map_infect_area <- renderPlotly({
  
  ip <- infect_area()
  
  fig <- ip %>% plot_mapbox(lat = ~ip_lat, lon = ~ip_lon,
                            size=~ (total_cases),
                            mode = 'scattermapbox', 
                            marker=list(sizeref=0.1, sizemode="area"),
                            color=I("red"),
                            text=~paste("Location: ",infected_place,"<br>","Total Confirmed Cases: ",total_cases,
                                          "<br>","Last infected date : ",last_infected_date,sep = "" ),
                            hoverinfo="text",alpha=0.7) %>%
    layout(height = 760,
      font = list(color='white'),
      plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
      mapbox = list(style = 'dark',zoom =11,
                    center = list(lon = 103.8198, lat = 1.3521)),
      legend = list(orientation = 'h',
                    font = list(size = 8)),
      margin = list(l = 25, r = 25,
                    b = 25, t = 25,
                    pad = 2))
  
  return(fig)
})
  

####---- Create map for which hospital are they staying ----####
output$map_infect_hospital <- renderPlotly({
  
  hp <- infect_hospital()
  
  fig <- hp %>% plot_mapbox(lat = ~Hospital_Latitude, lon = ~Hospital_Longitude,
                             size=~ (total_cases),
                             mode = 'scattermapbox', 
                             marker=list(sizeref=0.1, sizemode="area"),
                             color=I("yellow"),
                             text = ~paste("Location: ",hospital,"<br>","Total Confirmed Cases: ",total_cases,"<br>",sep = ""),
                             hoverinfo="text",alpha=0.7) %>%
    layout(height = 760,
      font = list(color='white'),
      plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
      mapbox = list(style = 'dark',zoom =11,
                    center = list(lon = 103.8198, lat = 1.3521)),
      legend = list(orientation = 'h',
                    font = list(size = 8)),
      margin = list(l = 25, r = 25,
                    b = 25, t = 25,
                    pad = 2))
  
  return(fig)
})


####---- Getting Lat Long ----####
plot_nearest_cluster <- eventReactive(input$cmd_postal_code, {req(input$postal_code)
  
  
  if (nDigits(input$postal_code) > 6) {
    showNotification(paste("Please enter 6 Digits postal code"), duration = NULL, type="message")
    return(NULL)
  }
  
  
  location_url <-paste0("https://api.mapbox.com/geocoding/v5/mapbox.places/",input$postal_code,
                        "%2C%20Singapore.json?access_token=",mapToken,"&cachebuster=1584954336485&autocomplete=true")
  
  get_lat_lon <- GET(location_url)
  
  lat_lon_info <- rawToChar(get_lat_lon$content)
  json_lat_lon <- fromJSON(lat_lon_info)
  
  lat_lon <- json_lat_lon$features$geometry[1,2]
  
  user_lat <-lat_lon[[1]][2]
  user_lon <-lat_lon[[1]][1]
  print(user_lon)
  print(user_lat)
  
  if (is.null(user_lon) || is.null(user_lat)) {
    showNotification(paste("Please enter correct postal code"), duration = NULL, type="message")
    return(NULL)
  }
  
  # return(c(user_lon, user_lat))
  
  ####---- Checking Nearest Cluster from Postel code
  distance <- NA
  for (i in 1:nrow(g_sg_ip_lat_lon)){
    distance[i] <- distm(c(user_lon, user_lat), c(g_sg_ip_lat_lon$ip_lon[i], g_sg_ip_lat_lon$ip_lat[i]), fun = distHaversine)
  }
  min_index<-which.min(distance)
  near_place <- g_sg_ip_lat_lon[min_index,]
  near_lat <- near_place$ip_lat
  near_lon <- near_place$ip_lon
  
  print(near_lon)
  print(near_lat)
  
  ####---- Checking road distance from Postal Code
  distance_url <- paste0('https://api.mapbox.com/directions/v5/mapbox/walking/',
                         user_lon, '%2C', user_lat,'%3B', near_lon,'%2C', near_lat,
                         '?alternatives=true&geometries=geojson&steps=true&access_token=',mapToken)
  #print(distance_url)
  
  get_prices <- GET(distance_url)
  raw_distant <- rawToChar(get_prices$content)
  json_distant <- fromJSON(raw_distant)
  
  minimum_distant <-json_distant$routes$distance
  
  km_distance <- minimum_distant/1000
  
  return(list(km_distance, near_place$infected_place, user_lat, user_lon, near_lat, near_lon))

})


get_map <- reactive({
  
  if(is.null(plot_nearest_cluster()))
    return(NULL)
    

  fig <- singapore_master %>%
    dplyr::select(case_id,infected_place,ip_lat,ip_lon) %>%
    dplyr::group_by(infected_place,ip_lat,ip_lon) %>%
    dplyr::summarise(total_cases= dplyr::n_distinct(as.character(case_id))) %>%
    plot_mapbox(mode = 'scattermapbox') %>%
    add_markers(y = ~ip_lat, x = ~ip_lon, size= ~ (total_cases),
                color=I("red"),
                name="Infected Places",
                marker=list(sizeref=0.1, sizemode="area"),
                text=~paste("Location: ",infected_place,"<br>","Total Confirmed Cases: ",total_cases,"<br>",sep = "" ),
                hoverinfo="text",alpha=0.7) %>%
    add_markers(y = ~plot_nearest_cluster()[3], x = ~plot_nearest_cluster()[4],
                name="Your Location",
                color=I("green"),
                marker=list(symbol="circle",size=30),
                text=~paste("Your location: ",input$postal_code),
                hoverinfo="text",alpha=0.7) %>%
    add_markers(y = plot_nearest_cluster()[5], x = plot_nearest_cluster()[6],
                name="Nearest Cluster",
                color=I("orange"),
                marker=list(symbol="circle",size=30),
                text=~paste("Nearest infected place: ", plot_nearest_cluster()[2]),
                hoverinfo="text",alpha=0.7) %>%
    layout(height = 760,
      font = list(color='white'),
      plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
      mapbox = list(style = 'dark',zoom =11,
                    center = list(lon = 103.8198, lat = 1.3521)),
      legend = list(orientation = 'h',
                    font = list(size = 8)),
      margin = list(l = 25, r = 25,
                    b = 25, t = 25,
                    pad = 2))
  
})

####---- Create map for which hospital are they staying ----####
output$map_nearest_cluster <- renderPlotly({
  
  if(is.null(get_map()))
     return(NULL)
     
  return(get_map())
})


####---- Display the distance between from your location to nearest Cluster ----####
output$distance <- renderText({
  
  if(is.null(plot_nearest_cluster()))
     return(NULL)
     
  paste0("The nearest cluster is ",plot_nearest_cluster()[2]," and it is ", plot_nearest_cluster()[1] ," kms far way from you")
})


observe({
  if (!is.numeric(input$postal_code)) {
    updateNumericInput(session, "postal_code")
  }
  
  if (!is.numeric(input$postal_code_cln)) {
    updateNumericInput(session, "postal_code")
  }
})


####---- Getting Clinic Lat Long ----####
plot_nearest_cln <- eventReactive(input$cmd_postal_code_cln, {req(input$postal_code_cln)
  
  
  if (nDigits(input$postal_code_cln) > 6) {
    showNotification(paste("Please enter 6 Digits postal code"), duration = NULL, type="message")
    return(NULL)
  }
  
  
  location_url <-paste0("https://api.mapbox.com/geocoding/v5/mapbox.places/",input$postal_code_cln,
                        "%2C%20Singapore.json?access_token=",mapToken,"&cachebuster=1584954336485&autocomplete=true")
  
  get_lat_lon <- GET(location_url)
  
  lat_lon_info <- rawToChar(get_lat_lon$content)
  json_lat_lon <- fromJSON(lat_lon_info)
  
  lat_lon <- json_lat_lon$features$geometry[1,2]
  
  user_lat <-lat_lon[[1]][2]
  user_lon <-lat_lon[[1]][1]
  print(user_lon)
  print(user_lat)
  
  if (is.null(user_lon) || is.null(user_lat)) {
    showNotification(paste("Please enter correct postal code"), duration = NULL, type="message")
    return(NULL)
  }
  
  # return(c(user_lon, user_lat))
  
  ####---- Checking Nearest Clinic from Postel code
  distance <- NA
  for (i in 1:nrow(clinic_lat_lon)){
    clinic_lat_lon$distance[i]<-distm(c(user_lon,user_lat), c(clinic_lat_lon$lon[i], clinic_lat_lon$lat[i]), fun = distHaversine)
  }
  near_by_clinc <- clinic_lat_lon %>% filter(distance<=1000)
  near_by_clinc$search_url<-paste0("https://www.google.com/maps/dir/?api=1&origin=",user_lat,"+",user_lon,"&destination=",near_by_clinc$lat,"+",near_by_clinc$lon,"&travelmode=driving") 
  
  return(list(near_by_clinc, user_lon, user_lat))
  
})


####---- Create map for nearest clinc ----####
get_map_cln<- reactive({
  
  if(is.null(plot_nearest_cln()))
    return(NULL)
  
  fig <-  as.data.frame(plot_nearest_cln()[1]) %>%
    plot_mapbox(mode = 'scattermapbox') %>%
    add_markers(y = ~lat, x = ~lon,
                color=I("green"),
                name="Nearest Clinic",
                marker=list(symbol="circle",size=20),
                text=~paste("Name: ",clinic_name,"<br>","Location: ",clinic_address,"<br>","Contact Number: ",clinic_phone,"<br>",sep = "" ),
                customdata = ~search_url, 
                hoverinfo="text",
                alpha=0.7) %>%
    add_markers(y = plot_nearest_cln()[3], x = plot_nearest_cln()[2],
                name="Your Location",
                color=I("orange"),
                marker=list(symbol="circle",size=20),
                text=~paste("Your location: ",input$postal_code_cln),
                hoverinfo="text",alpha=0.7) %>%
    layout(height = 760,
      font = list(color='white'),
      plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
      mapbox = list(style = 'dark', zoom =11,
                    center = list(lon = 103.8198, lat = 1.3521)),
      legend = list(orientation = 'h',
                    font = list(size = 8)),
      margin = list(l = 25, r = 25,
                    b = 25, t = 25,
                    pad = 2))
  
  onRender(
    fig, 
    "
    function(el) {
      el.on('plotly_click', function(d) {
        var url = d.points[0].customdata;
        window.open(url);
      });
    } 
  ") 
  

})


####---- Create map for which clinic are they staying ----####
output$map_nearest_cln <- renderPlotly({
  
  if(is.null(get_map_cln()))
    return(NULL)
  
  return(get_map_cln())
})



####---- Graph for check age group and their recovery rate ----####
output$age_recovery_rate <- renderPlotly({
  
  age_distribution <- recovery_rate()
  
  fig1 <- plot_ly(age_distribution) %>%
    add_trace(x = ~age_group, y = ~(male_cases), 
              type = 'bar',name="Male",
              marker = list(color = '#1F77B4') ## change the colour code
              #hoverinfo = "text",
              #text = ~paste(Wind, ' mph'))
    )%>%
    add_trace(x = ~age_group,y = ~female_cases,name = 'Female') %>%
    add_trace(x = ~age_group, y = ~recovered_female, type = 'scatter', mode = 'lines',
              name = 'Recovered Female',
              line = list(color = '#FFCD42'),
              hoverinfo = "text",
              text = ~paste("Total Recovered female cases:",recovered_female)) %>%
    add_trace(x = ~age_group, y = ~recovered_male, type = 'scatter', mode = 'lines',
              name = 'Recovered Male',
              line = list(color = '#2CA02C'),
              hoverinfo = "text",
              text = ~paste("Total Recovered male cases:",recovered_male))%>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(plot_bgcolor='#303030', paper_bgcolor='#303030',
           xaxis = list(title = "", tickangle = -45, color = '#ffffff'),
           yaxis = list(title = "", color = '#ffffff', side = 'left', title = 'Number of people'),
           barmode ="stack")
  
  return(fig1)

})


####---- Graph for how long it takes for peopleto become symptomatic ----####
output$age_time_symptotic <- renderPlotly({
  
  symptomatic <- time_symptotic()
  
  fig1 <- symptomatic %>%
          plot_ly(x = ~age_group, y = ~symptoms_to_confirm, color = ~gender, type = "box") %>%
          layout(legend = list( font = list(color = "#ffffff"))) %>%
          layout(boxmode = "group",
                 xaxis = list(title="", tickangle = -45, color = '#ffffff'),
                 yaxis = list(title="", color = '#ffffff'),
                 plot_bgcolor='#303030', paper_bgcolor='#303030')
  
  return(fig1)
  
})


####---- Graph for distribution of total infected with respect to local and foreign transmission ----####
output$local_forg_trans_rate <- renderPlotly({
  
  transmission <- transmission_rate()
  
  fig <- transmission %>%
    plot_ly() %>% 
    add_trace(x = ~confirmed_date, y = ~(total_infected_local),
              type = 'bar',name="Local",
              marker = list(color = '#32E1B1') ## change the colour code
    )%>%
    add_trace(x = ~confirmed_date,y = ~total_imported, name = 'Imported',type = 'bar',marker = list(color = '#15607A')) %>%
    layout(legend = list( font = list(color = "#ffffff"))) %>%
    layout(plot_bgcolor='#303030', paper_bgcolor='#303030',
           xaxis = list(title = '', color = '#ffffff', tickangle = -45 ),
           yaxis = list(side = 'left', title = 'Number of people', color = '#ffffff'),
           barmode ="stack")
  
  return(fig)
  
})