setwd("~/Dropbox/Fall_2012/Intro_to_Data_Science/Assignments/HW3/Data Science HW3/LaTeX")
IBM <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=1&c=2000&d=09&e=19&f=2012&g=d&ignore=.csv",stringsAsFactors=FALSE)
IBM$Date<-as.Date(IBM$Date)
IBM<-IBM[order(IBM$Date),]
library(zoo) 
dim(IBM)
ts.IBM <- zoo(IBM$Close, IBM$Date) 

#calculating and plotting log return:
log_return <- diff(log(IBM$Close))
IBM2 <- cbind(IBM[-1,], log_return) 
#lose one data point because there is one less return than close
ts.IBM.return <- zoo(IBM2$log_return, IBM2$Date) 
plot(ts.IBM.return, main = "IBM log return since Jan 1, 2000", xlab="Date", ylab="Log return")

# calculating and plotting log volume changes:
IBM2$log_volume_change <-  diff(log(IBM$Volume))
ts.IBM.volume <- zoo(IBM2$log_volume_change, IBM2$Date) 
plot(ts.IBM.volume, main = "IBM log Changes in Volume since Jan 1, 2000", xlab="Date", ylab="Log Volume",col="blue")

#now fit regression to it
model1 <- ar(ts.IBM.return, FALSE, 2, se.fit = TRUE) # fit ar(4)
model1$ar
plot(model1)
predict(model1, newdata=IBM2$log_return)
model1



#not using ar, but doing just an lm:
# need to order the data correctly:

train <-IBM2$log_return[which(IBM2$Date<"2012-01-03")]
test <- IBM2$log_return[which(IBM2$Date>="2012-01-03")]
test_df <- subset(IBM2,(IBM2$Date>="2012-01-05"))
#test <- subset(IBM2,IBM2$Date>"2012-01-03")
# build a lagged training data set
lag <- data.frame(Response=train[3:length(train)], 
                    Predictor1 = train[2:(length(train)-1)], #lagged by 1 day
                    Predictor2 = train[1:(length(train)-2)]) #blagged by 2 days
mod2 <- lm(Response~Predictor1+Predictor2, data=lag)
summary(mod2)
test_lag <- data.frame(Predictor1 = test[2:(length(test)-1)], #lagged by 1 day
                        Predictor2 = test[1:(length(test)-2)]) #blagged by 2 days
allignment <- cbind(test_df,test_lag)
allignment$predicted <- predict(mod2, test_lag)

ts.actual <- zoo(allignment$log_return, allignment$dates)
ts.forecast <- zoo(allignment$predicted,allignment$dates)
ts.compare <- cbind(ts.actual,ts.forecast)
head(ts.compare)
plot(ts.compare)
#view the results compared to the actual for the first 30 days of trading
ts.test<- ts.compare[150:200]
plot(ts.test, plot.type="single", col= c("black", "grey"),lty=1:2) + legend(x="topleft", legend=c("Actual","Predicted"), col=c("black","grey"),  lty=1:2) 
#note that we should explain the long lengths of lines with no points that cross non-trading days

#Design an experiment to see if we can make money

## subsetting with numeric indexes
#prove that the model makes sense and we didn't sift any days....
mod2$fitted.values[1:3]
act[1:3]
mod2$coefficients
-0.017391743 *(-0.0116064093) + (-0.0444074158)*(-0.004395611)+0.0001715389

test_returns(dates=dates,actual=act,predicted=predicted)



dates=dates
actual=act
predicted=mod2$fitted.values

returns <- 0
earnings <- NULL
for (day in 3:length(predicted)){
    temp_return <- NULL
    if (predicted[day]*actual[day]>0){ #multiply together, if same sign, positive
        returns <- returns + abs(actual[day])
        temp_return <- abs(actual[day])
    }
    else{
        returns <- returns - abs(actual[day])
        temp_return <- abs(actual[day])*-1
    }
    earnings[day-3] <- temp_return
}
new.dates <- dates[3:length(dates)]
PL <- cumsum(earnings)
ts.PL <- zoo(PL,new.dates)
plot(ts.PL[1:(length(ts.PL)-1)])
return (returns)

ts.PL[3210:3218]

cumsum(earnings)
returns



