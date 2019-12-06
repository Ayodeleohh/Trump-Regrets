# Trump Regrets
NLP project in R comparing the tweets of Donald Trump to those who regret voting for him. 

The following project will analyze the tweets from Donald Trump and the tweets RT'd by the Trump Regrets account. This account retweets tweets that include the words trump and regret, many tweets by his disavowed followers claiming they regretted voting for him and why. 

Pre-processing

Since we're converting the text contained in each tweet to numbers our computer can manipulate, we need to remove characters used in text that are unhelpful.

For this dataset I cleaned the tweets by removing punctuation, links, and whitespace after transforming all of the letters to lower case. 

In English, as well as in many languages, there are words that appear frequently, but hold little meaning. In natural language processing we call these stopwords. Words like "the", "and", "where", and "or" may appear hundreds of times in a text, but have little to no impact on the meaning. It's important to consider the context of your text before removing stopwords completely. Let's say we're investigating English plays and remove all instances of "the" from The Tempest. The implications of removing stopwords can't be overlooked. 

In the case of the cheeto in chief's tweets, stopwords arent likely to impact the outcome of my study. 

The second step in my data pre-processing is word stemming. This concantenates each word down to it's root. Judgement becomes judge. This process is made easier by using a Porter Stemmer in R. This rule-based algorithm handles new words well and operates faster than building a database of words. 

# Bag of Words

In this project I created a bag of words model which counts the number of times each word is used in the text. These counts then become indepentent variables. 

My first step was to create a Term Document Matrix to count how many times different words appeared in a document. 

This function creates a matrix in which the rows are the words in the tweets and the columns are the documents in a tweet. 

In my corpus of trump tweets we have 365 words that appear more than 20 times and in the corpus of the regretter tweets 169 words appear with the same frequency. 

# Topic Modeling

My project found 20 individual topics in both sets of tweets. While it's great for finding words that are commonly used together, it doesn't say much about WHY words are categorized in a single topic. 

However, it finds words commonly used together. Below are a few topics I found interesting from Donald Trump's tweets:

Topic 9

Nobodi, saw, israel, televis, hisotor

Topic 10

Minist, repres, prime, may, pocahonta

Topic 14

Hack, away, morningjo, ceo, unfair

Trump Regrets:

Topic 1

Islam, tv, zero, graham, angri

Topic 2

DNC, loss, dumb, control, isnt

Topic 17

Russian, part, cover, session, regard

 

Some of the most frequent words used in Donald Trump's tweets are:
thank, trump, great, hillari, clinton, peopl, crook, make, just, america. 

It's clear Trump has a major problem with Hillary Clinton. He mentions "hillari" 455 times in the selected tweets and america just 227 times. 

The guys who regret voting for Trump: 
vote, trump, regret, now, make, support, like, lie, promis, stop

We can extrapolate what we want here, but the topcis are clear, the people who regret voting for Donald Trump are REALLY unhappy about it. 

Below are the two wordclouds created to visualize the most frequently used words in Trump's Tweets, vs the Regret Tweets.

![trump twees wordcloud](https://user-images.githubusercontent.com/6904744/36347689-bcf58564-141a-11e8-8ee5-7bcb1b32be17.png)
![regret tweet](https://user-images.githubusercontent.com/6904744/36347698-139d4816-141b-11e8-9a5f-929b293d7e77.png)

Now I'll show the average sentiment of tweets between the two accounts. I found that despite Donald Trump's nature, overall his tweets seemed positive in sentiment. While not unexpected, the tweets from people who regret voting for him are negative on average. 

The two graphs below show the sentiment of Donald Trump's Tweets vs Trump Regret Tweets.
![trump sentiment](https://user-images.githubusercontent.com/6904744/36347707-6ad6eb1e-141b-11e8-8c15-03758e8071ff.png)
![regret sentiment](https://user-images.githubusercontent.com/6904744/36347709-77ee378a-141b-11e8-8087-03ca66a44c6e.png)

