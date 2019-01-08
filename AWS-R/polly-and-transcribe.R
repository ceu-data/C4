
# CSV IN SUCH FORMAT - accessKeys.csv:
#
#Access key ID,Secret access key
#AKIAJG7EQH5CRU6NM,7yf7I8mz6WtQ4hYRJrhelVvNI4+JUZA/DWzZ1G


keyTable <- read.csv("accessKeys.csv", header = T)
AWS_ACCESS_KEY_ID <- as.character(keyTable$Access.key.ID)
AWS_SECRET_ACCESS_KEY <- as.character(keyTable$Secret.access.key)

#activate
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = "us-west-2") 

#> install.packages("TuneR")

### AWS POLLY ===========================================
#> install.packages("aws.polly", repos = c(getOption("repos"), "http://cloudyr.github.io/drat"))

library("aws.polly")
library("tuneR")

# list available voices
list_voices()

vec <- synthesize("Hello world!", voice = "Joanna")
# On a mac, set the player with the following line: "https://stackoverflow.com/questions/23310005/permission-denied-when-playing-wav-file"
# setWavPlayer('/usr/bin/afplay')
play(vec)

### AWS TRANSCRIBE =====================================

# install latest stable version
#> install.packages("aws.transcribe", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))

library("aws.transcribe")
t1 <- start_transcription("example-4", "https://s3.amazonaws.com/randhunt-transcribe-demo-us-east-1/out.mp3")
transcript <- get_transcription("example-4")
cat(strwrap(transcript$Transcriptions[1L], 60), sep = "\n")

