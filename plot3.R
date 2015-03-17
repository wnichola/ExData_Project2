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

total_pm25_baltimore$Year <- as.factor(as.integer(total_pm25_baltimore$year))
total_pm25_baltimore$type <- as.factor(total_pm25_baltimore$type)

ggplot(data=total_pm25_baltimore, 
       aes(x=Year, y=total_pm25, group=type, color=type)) + 
    geom_line(size=1) +
    xlab("Year") + ylab ("PM2.5 (tons)") + 
    ggtitle("Total PM2.5 (tons) - By Year (Baltimore)")

# All types of sources have seen decreases in emissions, except for POINT that have seen
# an increase from 1999 to 2005 before dropping to a level slightly higher than in 1999