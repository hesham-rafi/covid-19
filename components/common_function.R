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
  sql = "SELECT Country, Confirmed, Deaths, Recovered from case_by_country where LastUpdate = date('now','-1 day') order by Confirmed desc"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Confirmed Cases Count ----####
totalConfirmed <- function() {
  sql = "SELECT sum(Confirmed) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Total Recovered Cases Count ----####
totalRecovered <- function() {
  sql = "SELECT sum(Recovered) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total Total Deaths Cases Count ----####
totalDeaths <- function() {
  sql = "SELECT sum(Deaths) FROM CASE_BY_COUNTRY where LastUpdate = date('now','-1 day')"
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
sgCases <- function() {
  sql = "select * from singapore_case;"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Singapore MASTER Table ----####
sgMaster <- function() {
  sql = "select * from singapore_master;"
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
  sql = "SELECT count(distinct `Case`) FROM singapore_case;"
  sql = "SELECT Confirmed FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Total Recovered Cases Count ----####
totalSGRecovered <- function() {
  sql = "SELECT count(distinct `Case`) FROM singapore_case where Status=='Recovered';"
  sql = "SELECT Recovered FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Total Deaths Cases Count ----####
totalSGDeaths <- function() {
  sql = "SELECT count(distinct `Case`) FROM singapore_case where Status=='Deaths';"
  sql = "SELECT Deaths FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}


####---- Total SG Current New Cases Count ----####
totalSGCurrent <- function() {
  sql = "SELECT count(distinct `Case`) FROM singapore_case where ConfirmDate==date('now', '-1 days');"
  sql = "SELECT NewConfirmed FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');"
  res <- dbSendQuery(con, sql)
  db <- dbFetch(res)
  return(db)
}
