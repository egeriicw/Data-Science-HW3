setwd("~/Dropbox/Fall_2012/Intro_to_Data_Science/Assignments/HW3/Data Science HW3/LaTeX")
library(lattice, xtable)
#getting the data from Yahoo Finance and making it into a time series object
IBM <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=1&c=2000&d=09&e=19&f=2012&g=d&ignore=.csv",stringsAsFactors=FALSE)
IBM$Date<-as.Date(IBM$Date)
IBM<-IBM[order(IBM$Date),]
library(zoo) 
dim(IBM)
ts.IBM <- zoo(IBM$Close, IBM$Date) 

#calculating and plotting log return and storing it into a data frame 
# this new df will be one record shorter because log returns is a change between two points - we have one less log return than days
log_return <- diff(log(IBM$Close))
IBM2 <- cbind(IBM[-1,], log_return) 
ts.IBM.return <- zoo(IBM2$log_return, IBM2$Date) 
plot(ts.IBM.return, main = "IBM log return since Jan 1, 2000", xlab="Date", ylab="Log return")
# calculating and plotting log volume changes:
IBM2$log_volume_change <-  diff(log(IBM$Volume))
ts.IBM.volume <- as.ts(IBM2$log_volume_change, IBM2$Date) 
plot(ts.IBM.volume, main = "IBM log Changes in Volume since Jan 1, 2000", xlab="Date", ylab="Log Volume",col="black")


#now fit regression to it with AR - this failed completely
model.ar.1 <- ar(log_return,aic=FALSE,2) # fit ar(4)
model.ar.2 <- ar(log_return)# fit ar(4)
summary(model.ar.1)
summary(model.ar.2)
model.ar.2$partialacf
plot(model1)
pred.ar2 <- predict(model1, newdata=IBM2$log_return[3:23])
model1
plot(pred.ar2)
n <- 

#not using ar, but doing just an lm:
# need to order the data correctly:
train <-IBM2$log_return[which(IBM2$Date<="2011-01-03")]
test <- IBM2$log_return[which(IBM2$Date>="2011-01-03")]
test_df <- subset(IBM2,(IBM2$Date>="2011-01-05"))
#test <- subset(IBM2,IBM2$Date>"2012-01-03")
# build a lagged training data set
lag <- data.frame(Response=train[3:length(train)], 
                    Predictor1 = train[2:(length(train)-1)], #lagged by 1 day
                    Predictor2 = train[1:(length(train)-2)]) #blagged by 2 days
mod2 <- lm(Response~Predictor1+Predictor2, data=lag)
xtable(summary(mod2))
test_lag <- data.frame(Predictor1 = test[2:(length(test)-1)], #lagged by 1 day
                        Predictor2 = test[1:(length(test)-2)]) #blagged by 2 days
allignment <- cbind(test_df,test_lag)
allignment$predicted <- predict(mod2, test_lag)

ts.actual <- zoo(allignment$log_return, allignment$Date)
ts.forecast <- zoo(allignment$predicted,allignment$Date)
ts.compare <- cbind(ts.actual,ts.forecast)
ts.test<- ts.compare[150:200]
plot(ts.test, plot.type="single", col= c("black", "red"),lty=1:1,pch=16,main="Model Performance in the Last 50 Trading Days", xlab="Date", ylab="log Return") + legend(x="bottom", legend=c("Actual log Return","Predicted log Return"), col=c("black","red"),  lty=1:1)
abline(h=0, v=0, col = "gray60",lty=2)
library(lattice)
ts.test<- ts.compare[150:200]
xyplot(ts.test, type = "o", lty=0:1, panel ="panel.superpose", screens=1, auto.key=TRUE, llines(y=0), lwd=2) 



test_returns(dates=allignment$Date,actual=allignment$log_return,predicted=allignment$predicted)

#test case to make sure that the model is fit right and all of the 
mod2$fitted.values[1:3]
act[1:3]
mod2$coefficients
-0.017391743 *(-0.0116064093) + (-0.0444074158)*(-0.004395611)+0.0001715389
