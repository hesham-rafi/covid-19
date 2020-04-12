## this script is to scrape tweets 
## shared to Hesham on 2019-07-09

library(RCurl)
library(httr)
library(twitteR)
library(ROAuth)
library(dplyr)
library(lubridate)
library(tm)
library(wordcloud)




############## below are the codes working using my own computer and my own home network ####################

get_data <- function(tweetDate, numTweet_eachDay){
  # this function fetches tweet data for each day
  # the input for desired day should be: 'yyyy-mm-dd'
  
  tw = twitteR::searchTwitter('#covid19 exclude:retweets', "#covid19 filter:news",
                              n=numTweet_eachDay, since=tweetDate, 
                              until=toString(as.Date(tweetDate)+1),
                              retryOnRateLimit = 1e3, lang="en")
  
  if (length(tw)!=0){
    d = twitteR::twListToDF(tw)
    
    d <- d %>%
      # mutate(LastDate = as.Date(as.character(as.POSIXct(created)))) %>%
      mutate(LastHour = format(as.POSIXct(created, format="%Y-%m-%d %H:%M:%S"), format="%H") )
    return(d)
  }
  else {
    return(NULL)
  }
}

get_tweets <- function(input_date, numTweet_eachDay){
  
  # setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
  setup_twitter_oauth(key, secret, access_token, access_secret)
  
  tweetDF = get_data(input_date, numTweet_eachDay)
  for (i in 1:6){
    temp_tweetDF = get_data(toString(as.Date(input_date)-i), numTweet_eachDay)
    tweetDF = rbind(tweetDF, temp_tweetDF)
  }
  return (tweetDF)
}


get_wordcloud <- function(){
  
  # specify date here. and get data for the past 7 days n tweets per day
  todayDate = Sys.Date()
  todayFile = paste0("data//",todayDate,"_tweet.RData")
  
  if (file.exists(todayFile))
    load(todayFile)
  else
  {
    df = get_tweets(as.character(todayDate), 1500)
    save(df, file = todayFile)
  }

  
  
  
  one_day_tweets <- df%>%
    group_by(Date = floor_date(as.POSIXct(as.character(created)), "1 day")) %>%
    summarise(daily_tweets = paste(text, collapse = "|"))
  
  corpus_daily_tweets <- VCorpus(VectorSource(one_day_tweets$daily_tweets))
  day_of_tweets <- one_day_tweets$Date
  
  removeTwitterHandles <- function(x) gsub("@\\S+", "", x, ignore.case=T)
  remove_tweetURL <- function(x) gsub('http\\S+', "", x, ignore.case=T)
  remove_dots <- function(x) gsub('…', '', x)
  remove_punct <- function(x) gsub('[[:punct:]]', '', x, ignore.case=T)
  removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*\\s", "", x, ignore.case=T)
  remove_edu0 <- function(x) gsub("\\s*<U\\+\\w+>|-", "", x, ignore.case=T)
  remove_tweetPics <- function(x) gsub("pic.twitter\\S+", "", x, ignore.case=T)
  remove_shortwords <- function(x) gsub('\\b\\w{1,2}\\s','',x, ignore.case=T)
  remove_onlyletters <- function(x) gsub('\\b[0-9]+\\s', '', x, ignore.case=T)
  
  
  # add stopwords
  stopwords_own <- c(stopwords("en"), "have", "been", "her", "he","she","can", "how", "about", "many", "one", "over",
                     "were", "its", "you", "from", "your", "our", "still", "please", "who", "ago", "now", "just", "today",
                     "than", "amp", "has", "will", "'", "virus", 'Corona', "Corona19", "COVID-19",
                     "coronavirus", "covid19", "aka", 'via', 'covid', 'sex', 'fuck', 'suck', 'virgin', 'lust', 'ass', 'abuse')
  
  t_corpus <- tm::tm_map(corpus_daily_tweets,content_transformer(removeTwitterHandles))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_edu0))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(tolower))
  t_corpus <- tm::tm_map(t_corpus, PlainTextDocument)
  
  # cursewords file loaded locally
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_tweetURL))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_dots))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(removeURL))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_tweetPics))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_punct))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_shortwords))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(remove_onlyletters))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(function(x) gsub("corona\\S*", '', x, ignore.case=T)))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(function(x) gsub("covid\\S*", '', x, ignore.case=T)))
  t_corpus <- tm::tm_map(t_corpus, content_transformer(function(x) iconv(x, 'utf-8', 'ascii', sub='')))
  
  t_corpus <- tm::tm_map(t_corpus, removePunctuation)
  t_corpus <- tm::tm_map(t_corpus, removeWords, stopwords_own)
  
  daily_twitterTdm <- tm::TermDocumentMatrix(t_corpus, control = list(wordLengths = c(3,Inf)))
  
  ## conver to matrix
  matrix_daily_tdm <- daily_twitterTdm %>%
    as.matrix()
  
  ## rename the document name using the date

  temp2 <- matrix_daily_tdm
  colnames(temp2) <- as.character(day_of_tweets)
  temp2 <- as.data.frame(temp2)
  s <- as.data.frame(rowSums(temp2))
  sub_s <- subset(s, `rowSums(temp2)`> 1)
  select_index = row.names(sub_s)
  temp <- temp2[select_index, ]
  
  renamed_doc_tweets <- temp
  
  
  return(renamed_doc_tweets)
  
}
