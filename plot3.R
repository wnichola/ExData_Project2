# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in emissions 
# from 1999-2008 for Baltimore City? Which have seen increases in emissions from 
# 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

library(data.table)
library(dplyr)
library(ggplot2)

source("loaddata.R")

output <- ""

total_pm25_baltimore <- NEI %>% 
    filter(fips == "24510", year >= "1999" & year <= "2008") %>% 
    group_by(year, type) %>% summarize(total_pm25 = sum(Emissions))

total_pm25_baltimore$Year <- as.integer(total_pm25_baltimore$year)
total_pm25_baltimore$type <- as.factor(total_pm25_baltimore$type)
rge <- range(total_pm25_baltimore$total_pm25)

qplot(total_pm25_baltimore$Year, total_pm25_baltimore$total_pm25, 
     data=total_pm25_baltimore, 
     facets = total_pm25_baltimore$type,
     xlab="Year", ylab="PM2.5 (tons)", 
     ylim=rge,
     main="Total PM2.5 - Baltimore (tons) By Year", 
     type="l", col="black")


# Yes, but there was a jump in 2005