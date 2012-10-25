require(rjson)
require(plyr)
#######This part is Jared's code [I had code, it worked, and then for some reason it stopped working]
# the location of the data
dataPath <- "http://getglue-data.s3.amazonaws.com/getglue_sample.tar.gz"
# build a connection that can decompress the file
theCon <- gzcon(url(dataPath))
# read 10 lines of the data
n.rows <- 10
theLines <- readLines(theCon, n=n.rows)
# check its structure
str(theLines)
# notice the first element is different than the rest
theLines[1]
# use fromJSON on each element of the vector, except the first
theRead <- lapply(theLines[-1], fromJSON)
# turn it all into a data.frame
theData <- ldply(theRead, as.data.frame)
# see how we did
View(theData)

# Now do it with 5000 lines of data
n.rows <- 10001 #one more because this is not a real row
theLines <- readLines(theCon, n=n.rows)
theRead <- lapply(theLines[-1], fromJSON)
# turn it all into a data.frame
data <- ldply(theRead, as.data.frame)
# save disk image so that if we crash we don't need to download everything again 
save.image("~/Dropbox/Fall_2012/Intro_to_Data_Science/Intro_to_Data_Science_HW/R/get_glue_10k_records.RData")


# different actuons
unique(data$action)
#number of users
unique(data$userId)
#to calculate favorite movie - just get # of likes
data$action <- as.character(data$action) 
likes.data <- subset(data,data$action=="Liked") #get only likes
likes.movie.data <- subset(likes.data, likes.data$modelName=="movies")#get only movies
likes.tv.data <- subset(likes.data, likes.data$modelName=="tv_shows")#get only movies
colnames(likes.movie.data)
top<-summary(likes.movie.data$title)
#useful comments
useful.data <-subset(data,data$useful=="1")
useful.data$userId
#correlation between number of movie likes and number of tv shows
# will need the aggregate function here

#prepare data
library(reshape)
test <- cbind(data$userId)
movie.likes<-as.data.frame(table(likes.movie.data$userId))
tv.likes<-as.data.frame(table(likes.tv.data$userId))
both <- merge(movie.likes,tv.likes, by="row.names")[,c(2,3,5)]
colnames(both) <- c("userId", "movie", "tv")

#do more users rank movies or tv shows? (minimum of 1)
length(both$tv[which(both$tv>0)])
length(both$movie[which(both$movie>0)])
length(both$tv[which(both$tv>0 & both$movie==0)])
length(both$movie[which(both$movie>0 & both$tv==0)])

# correlation between number of tv likes and movie likes for users with more than one like for each
both <- subset(both, both$movie>1 & both$tv>1 & both$movie<50 & both$tv<50)
    #plot(log(both$movie)~log(both$tv))
mod1<-lm(both$tv~both$movie)
plot(jitter(both$tv)~jitter(both$movie), xlab="Movies rated or commented on", ylab="TV shows rated or commented on", main="Movies and TV shows rated") + abline(mod1)
plot(both$tv~both$movie, xlab="Movies rated", ylab="TVs rated", main="Movies and TV shows rated") + abline(mod1)

#more positive comments or negative comments? (this is making assumptions that are discussed in the writeup)
comments.data <- subset(data,data$action=="Comment") #get only likes
likes.data[which(lapply(likes.data$userID, function(x) comments.data$userId))]
likes.data[which(match(likes.data$userID=="rollyp"))]
lapply(likes.data$userID,function(x) match(x, comments.data$userID))
#huge struggle couldn't do this, but should be able to... I'll come to office hrs.