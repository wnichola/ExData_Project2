# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base 
# plotting system, make a plot showing the total PM2.5 emission from all sources for each of the 
# years 1999, 2002, 2005, and 2008.

library(data.table)
library(dplyr)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot1.png"

## Download the file from the URL provided in the project brief
if (!file.exists(targetURL)) {
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL)
}

## Read the datasets
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

total_pm25_year <- NEI %>% group_by(year) %>% 
    summarise(total_pm25 = sum(Emissions))
total_pm25_year$total_pm25_M <- total_pm25_year$total_pm25/1000000

total_pm25_year$Year <- as.integer(total_pm25_year$year)

png(filename = output, width=480, height=480, units="px", bg="transparent")

plot(total_pm25_year$year, total_pm25_year$total_pm25_M, 
     data=total_pm25_year, xlab="Year", 
     ylab="PM2.5 (million tons)", 
     main="Total PM2.5 (million tons) By Year", type="b", xaxt="n")
axis(1, at=seq(1999, 2008, by=3))

dev.off()

# Yes.