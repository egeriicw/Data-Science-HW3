#Code for the get glue problem

#code from the HW
#install.packages("RJSONIO")
library("RJSONIO")
file.path <- "http://getglue-data.s3.amazonaws.com/getglue_sample.tar.gz"
con <- gzcon(url(file.path))
# first trying it with 10 lines:
n.lines.to.read <- 10
temp <- readLines(con, n.lines.to.read)[2:length(temp)] # SYKE! JUST 9 LINES!
#you need to take out the name of the json file because r just treats it as a string and it messes up rjsonio
gmgfromJSON(temp)
n.lines.to.read <- 1000
tmp <- readLines(con, n.lines.to.read)
head(tmp)
close(con)


res  <- fromJSON(temp[2:length(temp)]) # tokenize
dat <- unlist(res$results) # convert the dates to a vector

head(temp[2:])

temp[3]