####---- Display China and Other compare plot ----####
countyWiseCount <- function(scaleType){
  
  countyWiseCount_df <- g_allCountry %>% 
    mutate(two_countries=if_else(Country=="China","China",
                                 if_else(Country=="United States","US",
                                         if_else(CountryCode %in% g_euCountry$Country_Code,"Europe","Others")))) %>%
    select(LastUpdate,two_countries,Confirmed) %>%
    group_by(LastUpdate,two_countries) %>% 
    dplyr::summarise(Confirmed = sum(Confirmed)) %>%
    pivot_wider(id_cols = LastUpdate,names_from = two_countries, values_from = Confirmed) %>%
    as.data.frame()%>%
    mutate(LastUpdate=as.Date(LastUpdate))
  
  if (scaleType == 'log') {
    countyWiseCount_df <- countyWiseCount_df %>% 
      mutate_at(c("China","Others","US","Europe"), function(x, na.rm = FALSE) log(x), na.rm = TRUE) 
  }

  
  return(countyWiseCount_df)
}


####---- Display China and Other fatility ratio ----####
chinaOtherFatility <- function() {
  
  china_other_fatility_df <- g_allCountry %>% 
    mutate(two_countries=if_else(Country=="China","China",
                                 if_else(Country=="United States","US",
                                         if_else(CountryCode %in% g_euCountry$Country_Code,"Europe","Others")))) %>%
    select(LastUpdate,two_countries,Confirmed,Deaths) %>%
    group_by(LastUpdate,two_countries) %>% 
    dplyr::summarise(Confirmed = sum(Confirmed), Deaths=sum(Deaths)) %>%
    dplyr::mutate(fatility_rate = Deaths/Confirmed) %>%
    pivot_wider(id_cols = LastUpdate,names_from = two_countries, values_from = fatility_rate) %>%
    as.data.frame()%>%
    mutate(LastUpdate=as.Date(LastUpdate))
  
  return(china_other_fatility_df)
  
}


####---- Daily new confirmed cases ----####
newConfirmedCase <- function() {
  
  newConfirmedCase_df <- g_allCountry %>% 
    mutate(two_countries=if_else(Country=="China","China",
                                 if_else(Country=="United States","US",
                                         if_else(CountryCode %in% g_euCountry$Country_Code,"Europe","Others")))) %>%
    select(LastUpdate,two_countries,NewConfirmed) %>%
    group_by(LastUpdate,two_countries) %>% 
    dplyr::summarise(NewConfirmed = sum(NewConfirmed)) %>%
    pivot_wider(id_cols = LastUpdate,names_from = two_countries, values_from = NewConfirmed) %>%
    as.data.frame()%>%
    mutate(LastUpdate=as.Date(LastUpdate))
  
  return(newConfirmedCase_df)
  
}


####---- Daily deaths  cases ----####
dailyDeathCase <- function() {
  
  dailyDeathCase_db <- g_allCountry %>% 
    mutate(two_countries=if_else(Country=="China","China",
                                 if_else(Country=="United States","US",
                                         if_else(CountryCode %in% g_euCountry$Country_Code,"Europe","Others")))) %>%
    select(LastUpdate,two_countries,NewDeaths) %>%
    group_by(LastUpdate,two_countries) %>% 
    dplyr::summarise(NewDeaths=sum(NewDeaths)) %>%
    pivot_wider(id_cols = LastUpdate,names_from = two_countries, values_from = NewDeaths) %>%
    as.data.frame()%>%
    mutate(LastUpdate=as.Date(LastUpdate))
  
  return(dailyDeathCase_db)
  
}
