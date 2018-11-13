############################# A Game of Sentiments ##########################

############################# Setup Your Key ###############################

#my keys
keyTable <- read.csv("~/Downloads/accessKeysOregon.csv", header = T)
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

#activate
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "us-west-2") 
############################################################################

library(aws.comprehend)
library(dplyr)
library(ggplot2)

# read a text file and check its sentiment

short_story <- readLines('short_story.txt') # read the file
length(short_story) # check how long it is
a <- detect_sentiment(short_story[1]) # get sentiment from the first line
a # it is a dataframe
a$Sentiment # overall sentiment
a$Negative # negativity score
a$Positive # positivity score

detect_sentiment(short_story[2]) # how about second?
detect_sentiment(short_story[3]) # and third?
# this is repeating. we can loop it

sentiment_vector = c() #start with empty vectors
positive_vector = c()
negative_vector = c()

for (i in 1:length(short_story)) {   # for each element in the story do the following
  if (short_story[i] > "") {         # but only if this condition is met
    df <- detect_sentiment(short_story[i])  # get the sentiment 
    sentiment_vector <- c(sentiment_vector, as.character(df$Sentiment)) #extract overall sentiment name and append the vector
    positive_vector <- c(positive_vector, df$Positive) # extract positivity score and append the vector
    negative_vector <- c(negative_vector, df$Negative) #extract negativity score and append the vector
  } 
}

# ...and plot the scores
data_frame(positive_vector, negative_vector, sentiment_vector) %>%
  ggplot(aes(positive_vector, negative_vector)) +
  geom_point(aes(size=5)) +
  ggtitle("positive vs negative sentiments") +
  xlab("positive sentiments") +
  ylab("negative sentiments")


# TO DO: Find a better way to make the dataframe:




################################# end of A Game of Sentiments ######################