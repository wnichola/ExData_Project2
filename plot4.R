# Across the United States, how have emissions from coal combustion-related sources changed from  
# 1999-2008?

library(data.table)
library(dplyr)
library(ggplot2)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot4.png"

## Download the file from the URL provided in the project brief
if (!file.exists(targetURL)) {
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL)
}

## Read the datasets
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

coal_comb_related_scc <- filter(SCC, grepl("coal", tolower(SCC.Level.Three))) %>% 
    select(SCC)
ttl_pm25_coal_comb_by_year <- filter(NEI, SCC %in% coal_comb_related_scc$SCC) %>%
    group_by(year, type) %>% summarize(total_pm25 = sum(Emissions))

ttl_pm25_coal_comb_by_year$Year <- as.factor(as.integer(ttl_pm25_coal_comb_by_year$year))
ttl_pm25_coal_comb_by_year$type <- as.factor(ttl_pm25_coal_comb_by_year$type)

# To display total pm25 emissions by million of tons
ttl_pm25_coal_comb_by_year$total_pm25 <- ttl_pm25_coal_comb_by_year$total_pm25/1000000

png(filename = output, width=480, height=480, units="px", bg="transparent")

ggplot(data=ttl_pm25_coal_comb_by_year, 
       aes(x=Year, y=total_pm25, group=type, color=type)) + 
    geom_line(size=1) +
    xlab("Year") + ylab ("PM2.5 (million tons)") + 
    ggtitle("Total PM2.5 (tons) - By Year")

dev.off()

# POINT source has seen decreases in emissions from 1999 to 2008. However, NONPOINT
# sources have seen increases in 2002, and remains at the same level for 2005, before
# dropping in 2008 to a level just below 1999. 