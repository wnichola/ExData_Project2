# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot 
# answering this question.

library(data.table)
library(dplyr)

source("loaddata.R")

total_pm25_baltimore <- NEI %>% 
    filter(fips == "24510", year >= "1999" & year <= "2008") %>% 
    group_by(year) %>% summarize(total_pm25 = sum(Emissions))

total_pm25_baltimore$Year <- as.integer(total_pm25_baltimore$year)

plot(total_pm25_baltimore$Year, total_pm25_baltimore$total_pm25, 
     data=total_pm25_baltimore, xlab="Year", ylab="PM2.5 (tons)", 
     main="Total PM2.5 - Baltimore (tons) By Year", type="b", xaxt="n")
axis(1, at=seq(1999, 2008, by=3))

# Yes, but there was a jump in 2005