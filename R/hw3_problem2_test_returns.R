test_returns <-function(dates, actual, predicted){
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
    plot(ts.PL[1:(length(ts.PL)-1)], main="Cumulative P&L", xlab="Time", ylab= "Cumulative Sum of daily log Returns")
    return (returns)
# zoo object with earnings to see where the model works best... if it gets worse over time
}
