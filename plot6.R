# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes 
# over time in motor vehicle emissions?

library(data.table)
library(dplyr)
library(ggplot2)
library(RCurl)

## Define the input source and file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
targetURL <- "./exdata_data_NEI_data.zip"

## Define the output image file
output <- "./plot6.png"

## Download the file from the URL provided in the project brief
if (!file.exists(targetURL)) {
    setInternet2(TRUE)
    download.file(fileURL, destfile = targetURL)
    unzip(targetURL)
}

## Read the datasets
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

veh_related_scc <- filter(SCC, grepl("vehicle", tolower(SCC.Level.Two))) %>% 
    select(SCC, Data.Category, Short.Name, EI.Sector, SCC.Level.One, 
           SCC.Level.Two, SCC.Level.Three, SCC.Level.Four)

ttl_pm25_veh_by_year <- 
    filter(NEI, fips == "24510" | fips == "06037", 
           SCC %in% veh_related_scc$SCC) %>%
    group_by(year, fips, type) %>% summarize(total_pm25 = sum(Emissions))

ttl_pm25_veh_by_year$Year <- as.factor(as.integer(ttl_pm25_veh_by_year$year))
ttl_pm25_veh_by_year$type <- as.factor(ttl_pm25_veh_by_year$type)
# ttl_pm25_veh_by_year$fips <- as.factor(ttl_pm25_veh_by_year$fips)
ttl_pm25_veh_by_year$fips <- factor(ttl_pm25_veh_by_year$fips,
                                       levels=c("06037", "24510"),
                                       labels=c("Los Angeles County, California", 
                                                "Baltimore City, Maryland"))

png(filename = output, width=480, height=480, units="px", bg="transparent")

ggplot(data=ttl_pm25_veh_by_year, 
       aes(x=Year, y=total_pm25, group=type, color=type)) + 
    geom_line(size=1) +
    xlab("Year") + ylab ("PM2.5 (tons)") + 
    ggtitle("Total PM2.5 (tons) - By Year") +
    facet_grid(fips ~ .)

dev.off()

# Relative to LA, Baltimore have maintained lower vehicle emissions over 1999 to 2008,
# and during this period have a constant drop in emissions.  However, Los Angeles County,
# have seen high increases in ON-ROAD sources from 1999 until 2005, and dropping to
# a level just slightly higher than 1999 levels.  Whereas in NON-ROAD sources, there
# was a increase in 2002, but then have seen a constain drop in emissions since then to
# a level slightly above 1999 levels.  For POINT emissions, the level of emissions 
# have been constant and significantly lower than both ON-ROAD and NON-ROAD sources.
# In comparison between the two counties, Los Angeles would have the greatest changes
# over time in motor vehicle emissions - in both high increases and dramatic decreases.
# But the Los Angeles County level is comparitively much higher than those in Baltimore
# County.