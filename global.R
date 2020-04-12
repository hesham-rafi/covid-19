####---- Initialize library ----####
library(shiny)
library(shinythemes)
library(shinyalert)
library(RSQLite)
library(DT)
library(plotly)
library(quantmod)
library(stringr)
library(readr)
library(dplyr)
library(tidyr)
library(shinyWidgets)
library(stringi)
library(rvest)
library(XML)
library(httr)
library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(readxl)
library(geosphere)
library(jsonlite)
library(htmlwidgets) 
library(rtweet)
library(tidytext)


source("components/setenv.R")


Sys.setenv('MAPBOX_TOKEN' = mapToken)


####---- connect to the sqlite database ----####
con <- dbConnect(RSQLite::SQLite(), dbname=databaseName)


# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)


####---- Initialize environment variables ----####
source("components/common_function.R")
source("components/wordcloud_tweets.R")
source("components/singapore_views.R")
source("components/global_views.R")

g_euCountry <- euCountry()
g_allCountry <- allCountry()
g_sg_ip_lat_lon <- singaporeIpLatLong()

g_case_by_country <- caseByCountry()
g_total_countries <- totalCountries()
g_total_confirmed <- totalConfirmed()
g_total_recovered <- totalRecovered()
g_total_deaths <- totalDeaths()
g_case_on_map <- caseOnMap()
g_list_confirmed <- listConfirmed()

g_total_sg_confirmed <- totalSGConfirmed()
g_total_sg_recovered <- totalSGRecovered()
g_total_sg_deaths <- totalSGDeaths()
g_total_sg_current <- totalSGCurrent()

clinic_lat_lon <- singaporePhpcLatLong() 

g_list_confirmed$date <- as.Date(g_list_confirmed$date)


####---- Reading NASDAQ Index ----####
getSymbols("NQ=F", src = "yahoo", from = as.Date("2020-01-01"), to = Sys.Date())
getSymbols("^GSPC", src = "yahoo", from = as.Date("2020-01-01"), to = Sys.Date())
getSymbols("GOOG", src = "yahoo", from = as.Date("2020-01-01"), to = Sys.Date())
getSymbols("AAPL", src = "yahoo", from = as.Date("2020-01-01"), to = Sys.Date())
getSymbols("^DJI", src = "yahoo", from = as.Date("2020-01-01"), to = Sys.Date())

NQF <- data.frame(date=index(`NQ=F`), coredata(`NQ=F`))
NQF_df <- NQF[, c("date", "NQ.F.High")]

GSPC1 <- data.frame(date=index(GSPC), coredata(GSPC))
GSPC_df <- GSPC1[, c("date", "GSPC.High")]

GOOG1 <- data.frame(date=index(GOOG), coredata(GOOG))
GOOG_df <- GOOG1[, c("date", "GOOG.High")]

AAPL1 <- data.frame(date=index(AAPL), coredata(AAPL))
AAPL_df <- AAPL1[, c("date", "AAPL.High")]

DJI1 <- data.frame(date=index(DJI), coredata(DJI))
DJI_df <- DJI1[, c("date", "DJI.High")]

XCH_Data <- merge(x = GSPC_df, y = NQF_df, by = "date", all.x = TRUE)
XCH_Data <- merge(x = XCH_Data, y = GOOG_df, by = "date", all.x = TRUE)
XCH_Data <- merge(x = XCH_Data, y = AAPL_df, by = "date", all.x = TRUE)
XCH_Data <- merge(x = XCH_Data, y = DJI_df, by = "date", all.x = TRUE)
XCH_Data <- merge(x = XCH_Data, y = g_list_confirmed, by = "date", all.x = TRUE)

