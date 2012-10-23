#Code for the get glue problem
install.packages("stringr")
install.packages("parallel")

"knitr" and "foreach"
#code from the HW
#install.packages("RJSONIO")
library("RJSONIO")
library(plyr)
file.path <- "http://getglue-data.s3.amazonaws.com/getglue_sample.tar.gz"
con <- gzcon(url(file.path)) #opens up a connection that allows you to decompress and read from file
# first trying it with 10 lines:
n.lines.to.read <- 10
lines <- readLines(con, n.lines.to.read) # SYKE! JUST 9 LINES!
#you need to take out the name of the json file because r just treats it as a string and it messes up rjsonio
theRead <- lapply(lines[-1],fromJSON) #iterates through 1 element at a time through the list
str(theRead) # we have a list of lists
theData <-ldply(theRead, as.data.frame) # this turns the results of the operations on list as a dataframe
theData





temp2 <-fromJSON(temp)
dat <- unlist(temp2)
dat
as.data.frame(re[[1]])
resList1<-lapply(res1$results, as.data.frame)
ldply(resList1)
test<- unlist(temp)

result <- 
for(i in 0:length(temp))
{
    result[[i+1]]<-ldply(temp[[i+1]], as.data.frame)
}
sapply