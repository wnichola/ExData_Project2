# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base 
# plotting system, make a plot showing the total PM2.5 emission from all sources for each of the 
# years 1999, 2002, 2005, and 2008.

library(data.table)
library(dplyr)

source("loaddata.R")

total_pm25_year <- NEI %>% group_by(year) %>% 
    summarise(total_pm25 = sum(Emissions))
total_pm25_year$total_pm25_M <- total_pm25_year$total_pm25/1000000

total_pm25_year$Year <- as.integer(total_pm25_year$year)

plot(total_pm25_by_year$year, total_pm25_by_year$total_pm25_M, 
     data=total_pm25_by_year, xlab="Year", 
     ylab="PM2.5 (million tons)", 
     main="Total PM2.5 (million tons) By Year", type="b", xaxt="n")
axis(1, at=seq(1999, 2008, by=3))

# Yes.