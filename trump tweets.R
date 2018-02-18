if(!require(Rstem)) install_url("http://cran.r-project.org/src/contrib/Archive/Rstem/Rstem_0.4-1.tar.gz")
if(!require(Rsentiment)) install_url("https://cran.r-project.org/bin/macosx/el-capitan/contrib/3.4/RSentiment_2.2.1.tgz")

install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("readr")
install.packages("tidytext")
install.packages("stringr")
install.packages("tidyr")
install.packages("scales")
install.packages("purrr")
install.packages("broom")
install.packages("tm")
install.packages("SnowballC")
install.packages("wordcloud")
install.packages("syuzhet")
install.packages("textreg")
install.packages("SentimentAnalysis")
install.packages("quanteda")
install.packages("ngram")
install.packages("topicmodels")
install.packages("syuzhet")
install.packages("plotly")
install.packages("Rstem")
install.packages("sentiment")
install.packages("plotly")
library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)
library(tidytext)
library(stringr)
library(tidyr)
library(scales)
library(purrr)
library(broom)
library(tm)
library(SnowballC)
library(wordcloud)
library(syuzhet)
library(textreg)
library(SentimentAnalysis)
library(quanteda)
library(ngram)
library(topicmodels)
library(rpart)
library(syuzhet)
library(plotly)
library(RColorBrewer)
library(Rstem)
library(sentiment)
library(plotly)
library(dplyr)

#SETWD
setwd("/Applications/Documents/Tutorials/bkey-trump-regrets-tweets")

#Read Tweet CSVs into R
trump_tweets <- read.csv2("original/realDonaldTrump_tweets.csv")
trump_regrets <- read.csv2("original/trump_regrets_tweets.csv")
View(trump_tweets)
View(trump_regrets)

trump_tweets[1:3] <- list(NULL)
trump_tweets[2:8] <- list(NULL)
trump_regrets[1:3] <- list(NULL)
trump_regrets[2:8] <- list(NULL)

trump_corpus <- Corpus(VectorSource(trump_tweets$tweet_text))
regret_corpus  <- Corpus(VectorSource(trump_regrets$tweet_text))
inspect(trump_corpus)
inspect(regret_corpus)

#CLEAN DOCS

#ToSpace 
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})

#TrumpTweets
trump_corpus <- tm_map(trump_corpus, toSpace, ":")
trump_corpus <- tm_map(trump_corpus, removePunctuation)
trump_corpus <- tm_map(trump_corpus, removeWords, "RT")
trump_corpus <- tm_map(trump_corpus,content_transformer(tolower))
trump_corpus <- tm_map(trump_corpus, removeNumbers)
trump_corpus <- tm_map(trump_corpus, removeWords, stopwords("english"))
trump_corpus <- tm_map(trump_corpus, removeWords, "https")
trump_corpus <- tm_map(trump_corpus, removeWords, "amp")
trump_corpus <- tm_map(trump_corpus, removeWords, "realdonaldtrump")
trump_corpus <- tm_map(trump_corpus, stripWhitespace)
inspect(trump_corpus)

#TrumpRegrets
regret_corpus <- tm_map(regret_corpus, toSpace, ":")
regret_corpus <- tm_map(regret_corpus, removePunctuation)
regret_corpus <- tm_map(regret_corpus, removeWords, "RT")
regret_corpus <- tm_map(regret_corpus,content_transformer(tolower))
regret_corpus <- tm_map(regret_corpus, removeNumbers)
regret_corpus <- tm_map(regret_corpus, removeWords, stopwords("english"))
regret_corpus <- tm_map(regret_corpus, removeWords, "https")
regret_corpus <- tm_map(regret_corpus, removeWords, "amp")
regret_corpus <- tm_map(regret_corpus, removeWords, "realdonaldtrump")
regret_corpus <- tm_map(regret_corpus, stripWhitespace)
inspect(regret_corpus)


#STEM DOCS
trump_corpus <- tm_map(trump_corpus, stemDocument)
regret_corpus <- tm_map(regret_corpus, stemDocument)
inspect(trump_corpus)
inspect(regret_corpus)


#Most Frequent Words Used
Trump_dtm <- TermDocumentMatrix(trump_corpus)
Regret_dtm <- TermDocumentMatrix(regret_corpus)

Tm <- as.matrix(Trump_dtm)
Rm <- as.matrix(Regret_dtm)

Tv <- sort(rowSums(Tm),decreasing=TRUE)
Rv <- sort(rowSums(Rm),decreasing=TRUE)

Td <- data.frame(word = names(Tv),freq=Tv)
Rd <- data.frame(word = names(Rv),freq=Rv)

head(Td, 10)
head(Rd, 10)

#Shows words in order of popularity, that appear in the text at least 20 times
freq_T_20 <- findFreqTerms(Trump_dtm, lowfreq = 20)
freq_R_20 <- findFreqTerms(Regret_dtm, lowfreq = 20)

#Create Doc-Freq Matrix
trump_c <- corpus_subset(corpus(trump_corpus$content, docvars = trump_corpus$dmeta))
Tdfm <- dfm(trump_c)
regret_c <- corpus_subset(corpus(regret_corpus$content, docvars = regret_corpus$dmeta))
Rdfm <- dfm(regret_c)

trump_topic <- dfm_trim(Tdfm, min_count = 4, max_docfreq = 20, verbose = TRUE)
regret_topic <- dfm_trim(Rdfm, min_count = 4, max_docfreq = 20, verbose = TRUE)

#View 20 Topics used by Trump and Regretters
if (require(topicmodels)) {
  TrumpLDAfit20 <- LDA(convert(trump_topic, to = "topicmodels"), k = 20)
  get_terms(TrumpLDAfit20, 5)
}

if (require(topicmodels)) {
  RegretLDAfit20 <- LDA(convert(trump_topic, to = "topicmodels"), k = 20)
  get_terms(RegretLDAfit20, 5)
}


#Top Features
topfeatures(Tdfm, 20)
topfeatures(Rdfm, 20)

#Wordclouds
textplot_wordcloud(Tdfm, min.freq = 6, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

textplot_wordcloud(Rdfm, min.freq = 6, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))


#Trump Sentiment
Trump_sent <- analyzeSentiment(trump_corpus)
Trump_sent$SentimentQDAP
head(convertToDirection(Trump_sent$SentimentQDAP))
inspect(head(trump_corpus))
avg_tsent <- mean(Trump_sent$SentimentQDAP)
tsent <- convertToDirection(avg_tsent)
print(tsent)
plotSentiment(Trump_sent, x = NULL, cumsum = FALSE, xlab = "",
              ylab = "Sentiment")

#Regret Sentiment
Regret_sent <- analyzeSentiment(regret_corpus)
Regret_sent$SentimentQDAP
head(convertToDirection(Regret_sent$SentimentQDAP))
inspect(head(regret_corpus))
avg_rsent <- mean(Regret_sent$SentimentQDAP)
rsent <- convertToDirection(avg_rsent)
print(rsent)
plotSentiment(Trump_sent, x = NULL, cumsum = FALSE, xlab = "",
              ylab = "Sentiment")
