library(dplyr)
library(tidyr)

if(!file.exists("household_power_consumption.txt")) {
    file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(file_url, "household_power_consumption.zip")
    unzip("household_power_consumption.zip")
} else {
    print("already downloaded")
}
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

my_data <- tbl_df(read.table("household_power_consumption.txt",
                             sep=";",
                             header=T,
                             na.strings = c("?"),
                             colClasses=c("myDate","character","numeric",
                                          "numeric","numeric","numeric","numeric","numeric", "numeric")))
d <- subset(my_data, Date == "2007-02-01" | Date == "2007-02-02")

p <- mutate(d, DateTime=paste(Date, Time))
p$DateTime <- strptime(p$DateTime, "%Y-%m-%d %H:%M:%S")

par(bg=NA,cex=.9)
with(p, plot(DateTime, Sub_metering_1, type = "n",
             ylab="Energy sub metering",
             xlab=""))
with(p, points(DateTime,Sub_metering_1, type="l", col="black"))
with(p, points(DateTime,Sub_metering_2, type="l", col="red"))
with(p, points(DateTime,Sub_metering_3, type="l", col="blue"))
legend("topright", lwd=".5", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, "plot3.png", width=480, height=480)
dev.off()

