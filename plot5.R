# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

library(data.table)
library(dplyr)
library(ggplot2)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot5.png"

## Download the file from the URL provided in the project brief
if (!file.exists(targetURL)) {
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL)
}

## Read the datasets
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

## Retrieve the SCC for Mobile and Vehicles
# I interpreted the question based on motor vehicles implies all vehicles, 
# regardless of light or heavyg duty, but excludes all non-road equipment, aircraft
# marine vessels, locomotives (train?), and other. Thus all the SCC with 
# EI.Sector having the words Mobile and Vehicles would be relevant

veh_related_scc <- filter(SCC, grepl("mobile.*vehicle", tolower(EI.Sector))) %>% 
    select(SCC)

ttl_pm25_veh_by_year_baltimore <- filter(NEI, fips == "24510", SCC %in% veh_related_scc$SCC) %>%
    group_by(year, type) %>% summarize(total_pm25 = sum(Emissions))

ttl_pm25_veh_by_year_baltimore$Year <- as.factor(as.integer(ttl_pm25_veh_by_year_baltimore$year))
ttl_pm25_veh_by_year_baltimore$type <- as.factor(ttl_pm25_veh_by_year_baltimore$type)

png(filename = output, width=480, height=480, units="px", bg="transparent")

ggplot(data=ttl_pm25_veh_by_year_baltimore, 
       aes(x=Year, y=total_pm25, group=type, color=type)) + 
    geom_line(size=1) +
    xlab("Year") + ylab ("PM2.5 (tons)") + 
    ggtitle("Total PM2.5 (tons) - By Year (Baltimore)")

dev.off()

# ON-ROAD source have seen decreases in emissions, with the most
# drastic drop in 2002 and continues to drop in 2008