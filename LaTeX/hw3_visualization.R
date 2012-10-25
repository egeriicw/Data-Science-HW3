crime <- read.csv("http://datasets.flowingdata.com/crimeRatesByState2005.tsv", header=TRUE, sep="\t")
#Flowing Data Tutorial Distruction
radius <- sqrt( oc$size/ pi)
symbols(oc$M_w_earnings, oc$W_w_earnings, circles=radius, inches=0.35, fg="white", bg="red", xlab="Men's Weekly Earnings in $", ylab="Women's Weekly Earnings", main="Income Disparity by Occupation and Gender")
text(oc$M_w_earnings, oc$W_w_earnings, oc$Occupational.Group, cex=0.5)


#Can't use xy, ehhhh?
radius <- sqrt( oc$size/ pi)
xysymbols(oc$M_w_earnings, oc$W_w_earnings, circles=radius, inches=0.35, fg="white", bg="red", xlab="Men's Weekly Earnings in $", ylab="Women's Weekly Earnings", main="Income Disparity by Occupation and Gender")
text(oc$M_w_earnings, oc$W_w_earnings, oc$Occupational.Group, cex=0.5)





library(ggplot2)
library(directlabels)
library(stringr)
??trim
oc$Occupational.Group<-trim(as.character(oc$Occupational.Group))
#my data set:
oc <- read.csv("~/Dropbox/Fall_2012/Intro_to_Data_Science/Assignments/HW3/Data Science HW3/Vizualization/oc.csv")
oc$percent_women <- oc$W_employment/(oc$M_employment+oc$W_employment)
oc$size <- oc$W_employment+oc$M_employment
p <- ggplot(oc, aes(M_w_earnings, W_w_earnings, label = as.character(Occupational.Group)))
p + geom_point(aes(size = size, colour=percent_women)) + scale_size_continuous(range=c(3,40)) + #scale_area()+
    #geom_point(aes(colour = oc$percent_women)) + 
    coord_equal() +
    scale_colour_gradient(high = "red", low="blue")+
    ylim(700, 1700) +
    xlim(700, 1700) +
    geom_abline(slope=1) +
    labs(title = "Income Disparity by Occupation and Gender") +
    ylab("Women's Weekly Earnings in $") +
    xlab("Men's Weekly Earnings in $") +
    geom_text(aes(label=Occupational.Group), size=4)

        
library(xtable)
oc_2 <- oc[1:6]
xtable(oc)