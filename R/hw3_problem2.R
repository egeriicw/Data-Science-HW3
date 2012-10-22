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

ret <-IBM2$log_return
# build a lagged data set
lag <- data.frame(Response=ret[3:length(ret)], 
                    Predictor1 = ret[2:(length(ret)-1)], #lagged by 1 day
                    Predictor2 = ret[1:(length(ret)-2)]) #blagged by 2 days
mod1 <- lm(Response~Predictor1+Predictor2, data=lag)
summary(mod1)
class(mod2$fitted.values)
class(IBM2$date[3:dim(IBM2)[1]])
class(IBM2$log_return[3:dim(IBM2)[1]])
act <- IBM2$log_return[3:dim(IBM2)[1]]
dates <- IBM2$Date[3:dim(IBM2)[1]]
ts.actual <- zoo(act, dates)
ts.forecast <- zoo(IBM2$log_return,dates)
ts.compare <- cbind(ts.actual,ts.forecast)
class(ts.compare)
head(ts.compare)
plot(ts.compare)
#view the results compared to the actual for the first 30 days of trading
ts.test<- ts.compare[1000:1050]
plot(ts.test, plot.type="single", col= c("black", "grey"),lty=1:2) + legend(x="topleft", legend=c("Actual","Predicted"), col=c("black","grey"),  lty=1:2) 

#note that we should explain the long lengths of lines with no points that cross non-trading days

#Design an experiment to see if we can make money

## subsetting with numeric indexes
#prove that the model makes sense and we didn't sift any days....
mod2$fitted.values[1:3]
act[1:3]
mod2$coefficients
-0.017391743 *(-0.0116064093) + (-0.0444074158)*(-0.004395611)+0.0001715389

test_returns(dates=dates,actual=act,predicted=mod2$fitted.values)



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
