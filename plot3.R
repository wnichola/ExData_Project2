# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in emissions 
# from 1999-2008 for Baltimore City? Which have seen increases in emissions from 
# 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

library(data.table)
library(dplyr)
library(ggplot2)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot3.png"

## Download the file from the URL provided in the project brief
if (!file.exists(targetURL)) {
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL)
}

## Read the datasets
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

total_pm25_baltimore <- NEI %>% 
    filter(fips == "24510", year >= "1999" & year <= "2008") %>% 
    group_by(year, type) %>% summarize(total_pm25 = sum(Emissions))

total_pm25_baltimore$Year <- as.factor(as.integer(total_pm25_baltimore$year))
total_pm25_baltimore$type <- as.factor(total_pm25_baltimore$type)

png(filename = output, width=480, height=480, units="px", bg="transparent")

ggplot(data=total_pm25_baltimore, 
       aes(x=Year, y=total_pm25, group=type, color=type)) + 
    geom_line(size=1) +
    xlab("Year") + ylab ("PM2.5 (tons)") + 
    ggtitle("Total PM2.5 (tons) - By Year (Baltimore)")

dev.off()

# All types of sources have seen decreases in emissions, except for POINT that have seen
# an increase from 1999 to 2005 before dropping to a level slightly higher than in 1999