## set hey for mapbox 
# Sys.setenv('MAPBOX_TOKEN' = 'pk.eyJ1IjoiYmFsYWNvdW1hcmFuZSIsImEiOiJjazJza3Z5a3oxMTl5M2Jxb2d1dmNvdnZnIn0.wZ8GiQlvIVh8PN1xU9_cIw')


####---- Read base data, lat &long for infected places, roamed places and admitted places in Singapore ----####
# hospital_lat_long <- sgHospitalLatLong()
# ip_lat_long <- sgInfectedLatLong()
# upcode_table <- sgCases()
# sing_data <- read_csv("data/sing_data.csv")
singapore_master <- sgMaster()

## merge
# df2 <- upcode_table %>% 
#   merge(sing_data %>% select("case","hospital","infected_place","news_date","visit"),by.x ="Case" ,by.y="case",all.x = TRUE) %>%
#   merge(hospital_lat_long,by.x="hospital",by.y="Hospital",all.x = TRUE) %>%
#   merge(ip_lat_long,by.x="infected_place",by.y="infected_place",all.x = TRUE) %>%
#   mutate(ip_lat= ifelse(InfectionSource=="Imported case",NA,ip_lat),
#          ip_lon= ifelse(InfectionSource=="Imported case",NA,ip_lon)) %>%
#   na_if("-")


###############################################################################

# ## read base data, lat &long for infected places, roamed places and admitted places in Singapore
# hospital_lat_long <- read_csv("daily_data/singapore_hp_lat_long.csv")
# ip_lat_long1 <- read_csv("daily_data/singapore_ip_lat_lon.csv")
# sing_data <- read_csv("data/sing_data.csv")
# 
# ## get data from upcode academy
# #Specifying the url for desired website to be scraped
# url <- 'https://co.vid19.sg/cases/search'
# upcode_table_path <- '//*[@id="casesTable"]'
# 
# 
# ### create function to read table into dataframe 
# 
# upcode_table <- url %>%
#   xml2::read_html() %>%
#   rvest::html_nodes(xpath=upcode_table_path) %>%
#   rvest::html_table(fill=T) %>%
#   .[[1]] %>%
#   as.data.frame()%>%
#   dplyr::select(-c("Symptomatic At","Confirmed At","Recovered At","Displayed Symptoms?"))
# #library(maps)
# 
# ## merge
# df2 <- upcode_table1 %>% 
#   merge(sing_data %>% select("case","hospital","infected_place","news_date","visit"),by.x ="Case" ,by.y="case",all.x = TRUE) %>%
#   merge(hospital_lat_long,by.x="hospital",by.y="Hospital",all.x = TRUE) %>%
#   merge(ip_lat_long,by.x="infected_place",by.y="infected_place",all.x = TRUE) %>%
#   mutate(ip_lat= ifelse(`InfectionSource`=="Imported case",NA,ip_lat),
#          ip_lon= ifelse(`InfectionSource`=="Imported case",NA,ip_lon)) %>%
#   na_if("-")

###############################################################################

####---- Create map for Infected Area ----####
infect_area <- function(){
  
  ip <- singapore_master %>%
    dplyr::select(case_id,infected_place,ip_lat,ip_lon, confirmed_date) %>%
    dplyr::group_by(infected_place,ip_lat,ip_lon) %>%
    dplyr::summarise(total_cases= dplyr::n_distinct(as.character(case_id)),
                     last_infected_date= max(confirmed_date) )
  
  return(ip)
}


####---- Create map for which hospital are they staying ----####
infect_hospital <- function(){
  
  hp <- singapore_master %>%
    dplyr::select(case_id,hospital,Hospital_Latitude, Hospital_Longitude) %>%
    dplyr::group_by(hospital,Hospital_Latitude,Hospital_Longitude) %>%
    dplyr::summarise(total_cases= dplyr::n_distinct(as.character(case_id)))
  
  return(hp)
}


####---- Graph for check age group and their recovery rate ----####
recovery_rate <- function(){
  
  age_distribution <- singapore_master %>%
    dplyr::select(age,gender,Status) %>%
    mutate(
      age_group=dplyr::case_when(
        age %in% seq(1,10) ~ "1_to_10_years_old",
        age %in% seq(11,20) ~ "10_to_20_years_old",
        age %in% seq(21,30) ~ "20_to_30_years_old",
        age %in% seq(31,40) ~ "30_to_40_years_old",
        age %in% seq(41,50) ~ "40_to_50_years_old",
        age %in% seq(51,60) ~ "50_to_60_years_old",
        age %in% seq(61,75) ~ "60_to_75_years_old",
        TRUE ~ "More_than_75_years_old" ),
      recovered = ifelse(Status=="Recovered",1,0),
      male = ifelse(gender=="male",1,0),
      female = ifelse(gender=="female",1,0),
      recovered_female=ifelse(gender=="female"&recovered==1,1,0),
      recovered_male=ifelse(gender=="male"&recovered==1,1,0)) %>%
    group_by(age_group) %>%
    summarise(total_cases=n(),
              recovered_female=sum(recovered_female),
              recovered_male=sum(recovered_male),
              male_cases=sum(male),
              female_cases=sum(female))
  
    return(age_distribution)
    
}


####---- Graph for how long it takes for peopleto become symptomatic ----####
time_symptotic <- function(){
  
  symptomatic <- singapore_master  %>%
    dplyr::select(age,gender,symptom_to_confirm) %>%
    mutate(
      age_group=dplyr::case_when(
        age %in% seq(1,10) ~ "1_to_10_years_old",
        age %in% seq(11,20) ~ "10_to_20_years_old",
        age %in% seq(21,30) ~ "20_to_30_years_old",
        age %in% seq(31,40) ~ "30_to_40_years_old",
        age %in% seq(41,50) ~ "40_to_50_years_old",
        age %in% seq(51,60) ~ "50_to_60_years_old",
        age %in% seq(61,75) ~ "60_to_75_years_old",
        TRUE ~ "More_than_75_years_old"
      ),
      symptoms_to_confirm=as.numeric(symptom_to_confirm)
      ) %>%
    na_if("0")
  
  # symptomatic <- singapore_master  %>%
  #   dplyr::select(age,gender,symptom_to_confirm) %>%
  #   mutate(
  #     age_group=dplyr::case_when(
  #       age %in% seq(1,10) ~ "1_to_10_years_old",
  #       age %in% seq(11,20) ~ "10_to_20_years_old",
  #       age %in% seq(21,30) ~ "20_to_30_years_old",
  #       age %in% seq(31,40) ~ "30_to_40_years_old",
  #       age %in% seq(41,50) ~ "40_to_50_years_old",
  #       age %in% seq(51,60) ~ "50_to_60_years_old",
  #       age %in% seq(61,75) ~ "60_to_75_years_old",
  #       TRUE ~ "More_than_75_years_old"
  #     ),
  #     symptoms_to_confirm=as.numeric(symptom_to_confirm))
  # 
  return(symptomatic)
}
  

####---- Graph for distribution of total infected with respect to local and foreign transmission ----####
transmission_rate <- function() {
  
  transmission <- singapore_master %>% dplyr::select(confirmed_date,imported) %>%
    mutate(total_infected_local=ifelse(imported== "local",1,0),
           total_imported=ifelse(imported=="imported",1,0))%>%
    group_by(confirmed_date) %>% 
    dplyr::summarise(total_infected_local = sum(total_infected_local,na.rm = T),
                     total_imported = sum(total_imported,na.rm = T))%>%
    mutate(confirmed_date=as.Date(confirmed_date))
  
  # transmission <- singapore_master %>%
  #   dplyr::select(confirmed_date,imported) %>%
  #   mutate(total_infected_local=ifelse(imported== "local",1,0),
  #          total_imported=ifelse(imported=="imported",1,0))%>%
  #   group_by(confirmed_date) %>% 
  #   dplyr::summarise(total_infected_local = sum(total_infected_local),
  #                    total_imported = sum(total_imported)) %>%
  #   mutate(confirmed_date=format(as.Date(confirmed_date),format="%m-%d"))
  
  return(transmission)
}


