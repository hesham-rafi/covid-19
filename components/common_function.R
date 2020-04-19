####---- Counting no of digits ----####
nDigits <- function(x) nchar( trunc( abs(x) ) )


####---- Read EU_Country Table ----####
euCountry <- function() {
  sql = "SELECT * from eu_country"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Read singapore_ip_lat_long Table ----####
singaporeIpLatLong <- function() {
  sql = "SELECT * from singapore_ip_lat_long"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Read singapore_phpc_lat_long Table ----####
singaporePhpcLatLong <- function() {
  sql = "SELECT * from singapore_phpc_lat_long"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Read case_by_country Table ----####
allCountry <- function() {
  sql = "SELECT * from case_by_country"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Country wise information Table ----####
caseByCountry <- function() {
  # sql = "SELECT Country, Confirmed, Deaths, Recovered from case_by_country where LastUpdate = date('now','-1 day') order by Confirmed desc"
  sql = "SELECT Country, Confirmed, Deaths, Recovered FROM ( 
          SELECT CountryCode, Country, Confirmed, Deaths, Recovered, LastUpdate, ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY LastUpdate DESC ) RowNum FROM case_by_country 
          ) WHERE RowNum = 1 ORDER BY Confirmed desc;"

    res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Confirmed Cases Count ----####
totalConfirmed <- function() {
  # sql = "SELECT sum(Confirmed) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
  sql = "SELECT sum(Confirmed) FROM ( 
          SELECT CountryCode, Confirmed, LastUpdate, ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY LastUpdate DESC ) RowNum FROM case_by_country 
          ) WHERE RowNum = 1;"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Total Recovered Cases Count ----####
totalRecovered <- function() {
  # sql = "SELECT sum(Recovered) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
  sql = "SELECT sum(Recovered) FROM ( 
          SELECT CountryCode, Recovered, LastUpdate, ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY LastUpdate DESC ) RowNum FROM case_by_country 
          ) WHERE RowNum = 1;"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Total Deaths Cases Count ----####
totalDeaths <- function() {
  # sql = "SELECT sum(Deaths) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
  sql = "SELECT sum(Deaths) FROM ( 
          SELECT CountryCode, Deaths, LastUpdate, ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY LastUpdate DESC ) RowNum FROM case_by_country 
          ) WHERE RowNum = 1;"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Infected Counties Count ----####
totalCountries <- function() {
  sql = "SELECT count(distinct Country) FROM CASE_BY_COUNTRY"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Infected map ----####
caseOnMap <- function() {
  sql = "SELECT C.Country, C.Confirmed, C.Deaths, C.Recovered, L.Latitude, L.Longitude  from case_by_country C INNER JOIN country_lat_lon L 
          ON C.CountryCode = L.CountryCode where C.LastUpdate = date('now','-1 day');"
  
  sql = "SELECT C.Country, C.Confirmed, C.Deaths, C.Recovered, L.Latitude, L.Longitude  from (SELECT * FROM ( 
          SELECT *, ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY LastUpdate DESC ) RowNum FROM case_by_country ) WHERE RowNum = 1) C 
          INNER JOIN country_lat_lon L ON C.CountryCode = L.CountryCode;
  "
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- List of confirmed cases ----####
listConfirmed <- function() {
  sql = "select LastUpdate as date, sum(Confirmed) as Confirmed from case_by_country group by LastUpdate;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Singapore Cases Table ----####
# sgCases <- function() {
#   sql = "select * from singapore_case;"
#   res <- dbSendQuery(con, sql)
#   db <- dbFetch(res)
#   return(db)
# }


####---- Singapore MASTER Table ----####
sgMaster <- function() {
  sql = "select * from singapore_master;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Singapore Cluster Table ----####
sgCluster <- function() {
  sql = "select * from Singapore_Cluster;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}

####---- Singapore Infected Cases Lat Long ----####
sgInfectedLatLong <- function() {
  sql = "select trim(infected_place) as infected_place, ip_lat, ip_lon from singapore_ip_lat_long;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Singapore hospital Cases Lat Long ----####
sgHospitalLatLong <- function() {
  sql = "select * from singapore_hp_lat_long;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Confirmed Cases Count ----####
totalSGConfirmed <- function() {
  # sql = "SELECT Confirmed FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Confirmed FROM case_by_country where CountryCode='SG' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='SG');"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Total Recovered Cases Count ----####
totalSGRecovered <- function() {
  # sql = "SELECT count(distinct `Case`) FROM singapore_case where Status=='Recovered';"
  # sql = "SELECT Recovered FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Recovered FROM case_by_country where CountryCode='SG' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='SG');"

  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Total Deaths Cases Count ----####
totalSGDeaths <- function() {
  # sql = "SELECT Deaths FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Deaths FROM case_by_country where CountryCode='SG' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='SG');"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Current New Cases Count ----####
totalSGCurrent <- function() {
  # sql = "SELECT NewConfirmed FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT NewConfirmed FROM case_by_country where CountryCode='SG' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='SG');"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total ID Confirmed Cases Count ----####
totalIDConfirmed <- function() {
  # sql = "SELECT Confirmed FROM case_by_country where CountryCode='ID' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Confirmed FROM case_by_country where CountryCode='ID' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='ID');"

  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total ID Total Recovered Cases Count ----####
totalIDRecovered <- function() {
  # sql = "SELECT Recovered FROM case_by_country where CountryCode='ID' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Recovered FROM case_by_country where CountryCode='ID' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='ID');"

  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total ID Total Deaths Cases Count ----####
totalIDDeaths <- function() {
  # sql = "SELECT Deaths FROM case_by_country where CountryCode='ID' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT Deaths FROM case_by_country where CountryCode='ID' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='ID');"

  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total ID Current New Cases Count ----####
totalIDCurrent <- function() {
  # sql = "SELECT NewConfirmed FROM case_by_country where CountryCode='ID' and LastUpdate=date('now', '-1 days');"
  sql = "SELECT NewConfirmed FROM case_by_country where CountryCode='ID' and LastUpdate in (select max(LastUpdate) from case_by_country where CountryCode='ID');"

  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Read indonesia_master Table ----####
indonesiaMaster <- function() {
  sql = "SELECT * from indonesia_master"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Read indonesia_provinces Table ----####
indonesiaProvinces <- function() {
  # sql = "SELECT * from indonesia_provinces"
  sql = "SELECT * FROM ( SELECT *, ROW_NUMBER() OVER (PARTITION BY provinces ORDER BY last_updated DESC) RowNum FROM indonesia_provinces) WHERE RowNum = 1 ORDER By cases DESC;"
  
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}

