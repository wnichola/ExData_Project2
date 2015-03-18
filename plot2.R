# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot 
# answering this question.

library(data.table)
library(dplyr)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot2.png"

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
    group_by(year) %>% summarize(total_pm25 = sum(Emissions))

total_pm25_baltimore$Year <- as.integer(total_pm25_baltimore$year)

png(filename = output, width=480, height=480, units="px", bg="transparent")

plot(total_pm25_baltimore$Year, total_pm25_baltimore$total_pm25, 
     data=total_pm25_baltimore, xlab="Year", ylab="PM2.5 (tons)", col="red",
     main="Total PM2.5 - Baltimore (tons) By Year", type="b", xaxt="n")
axis(1, at=seq(1999, 2008, by=3))

dev.off()

# Yes, but there was a jump in 2005