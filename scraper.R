################################## begin Web Scrap ######################################

#>install.packages('rvest')


#Have your SelectorGadget on Google Chrome: https://selectorgadget.com/

#Loading the rvest package
library('rvest')

#Specifying the url for desired website to be scrapped
url <- 'https://fivethirtyeight.com/features/the-16-races-still-too-close-to-call/'

#Reading the HTML code from the website
webpage <- read_html(url)

#Using CSS selectors to scrap the text related to the news article
#text_data_html <- html_nodes(webpage,'<<PUT THE CSS SELECTION HERE>>')
text_data_html <- html_nodes(webpage,'.__reader_view_article_wrap_8724363608561669__ , p:nth-child(7) , #framediv4+ p , p:nth-child(3)')

#Converting to text
text_data <- html_text(text_data_html)

#Let's have a look at the text we got
head(text_data)

#There are still strange characters in our text like "\n\t\tAll newsletters\n\t".

#Data-Preprocessing: removing unwanted garbage
text_data <- gsub("[\r\n\t]", "", text_data)

text_data
################################## end of Web Scrap ######################################



