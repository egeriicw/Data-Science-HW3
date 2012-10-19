IBM <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=1&c=2000&d=09&e=19&f=2012&g=d&ignore=.csv")
library(zoo) 
dim(IBM)
ts.IBM <- zoo(IBM$Close, IBM$Date) 
plot(ts.IBM)

#calculating and plotting return:
log_return <- diff(log(IBM$Close))
IBM <- cbind(IBM[-1,], log_return)
ts.IBM.return <- zoo(IBM$log_return, IBM$Date) 
plot(ts.IBM.return, main = "IBM log return since Jan 1 2000", xlab="Date", ylab="Log return")

plot.ts
