sessionInfo() # this will list down the libraries you have in your environment

################################ Setup Your Keys ################################

#my keys
keyTable <- read.csv("~/Downloads/accessKeysOregon.csv", header = T)
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

#activate
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "us-west-2") 

########################### S3 Interraction with R #############################

library(aws.s3)
# i can have a look at my bucket list on s3
bucketlist()

#Get a website content
library(Rcrawler)
my_url <- "https://www.nytimes.com/"
my_content <- ContentScraper(my_url, astext = T, XpathPatterns = c("."))

#Make a unique s3 bucket name
my_name <- "cagdas-"  # type in your name here
bucket_name <- paste(c(my_name, sample(c(0:9, letters), size = 10, replace = TRUE)), collapse = "")
print(bucket_name)

#Now we can create the bucket on s3
put_bucket(bucket_name)

#bucket location
get_location(bucket_name)

#Create a text file using the website content:
write.csv(my_content[[1]], "my_content.txt")

#Send the text file to AWS S3 bucket
put_object("my_content.txt", bucket = bucket_name)

#We have data on The Cloud! Check on your browser. Now let's get it back on our computer:
save_object("my_content.txt", bucket = bucket_name, file = "my_content_s3.txt")

# lets delete this object
delete_object("my_content.txt", bucket = bucket_name)

# We're finished with this bucket, so let's delete it.
delete_bucket(bucket_name) #currently the delete_bucket function does not work