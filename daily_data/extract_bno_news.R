library(rvest)
library(xml2)
library(tidyr)
library(dplyr)
library(purrr)
library(rtweet)

#Specifying the url for desired website to be scraped
url <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vR30F8lYP3jG7YOq8es0PBpJIE5yvRVZffOyaqC0GgMBN6yt0Q-NI8pxS7hd1F9dYXnowSC6zpZmW9D/pubhtml?gid=0&amp;single=false&amp;widget=true&amp;headers=false'
url <- "https://news.google.com/covid19/map?hl=en-SG&gl=SG&ceid=SG:en"

### create function to read table into dataframe 

## set column names
names<-c("Country","Cases","New_cases","Deaths","New_deaths","percent_deaths","Serious","Recovered")

table_path = '//*[@id="0"]/div/table'
table_path = '//*[@class="sOh CrmLxe"]/table'


table <- url %>%
  xml2::read_html() %>%
  rvest::html_nodes(xpath=table_path) %>%
  rvest::html_table(fill=T) %>%
  .[[1]] %>%
  `colnames<-` (1:17)%>%  ## random column name
  dplyr::select(2:9) %>% ## drop unwanted column
  dplyr::slice(7:n()) %>%
  purrr::set_names(., nm = names) %>%
  dplyr::select(-c("percent_deaths","Serious")) %>%
  dplyr::slice(-1) %>%
  dplyr::filter(!(Country==""))%>%
  dplyr::filter(!(Country=="Queue")) %>%
  mutate_all(~(gsub(",","",.))) %>%
  mutate(Last_update = Sys.time())


save_as_csv(table, "daily_data/2020-05-12.csv")


