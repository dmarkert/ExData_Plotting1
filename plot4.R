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

par(mfrow = c(2, 2),bg=NA,cex=.6)
with(p, {
    plot(DateTime, Global_active_power, 
         type="l", 
         ylab="Global Active Power", 
         xlab="")
    plot(DateTime, Voltage,
         type="l",
         ylab="Voltage",
         xlab="datetime")
    plot(DateTime, Sub_metering_1, type = "n",
                 ylab="Energy sub metering",
                 xlab="",bg=NULL)
    points(DateTime,Sub_metering_1, type="l", col="black")
    points(DateTime,Sub_metering_2, type="l", col="red")
    points(DateTime,Sub_metering_3, type="l", col="blue")
    legend("topright", bg=NULL, lwd=".5",bty="n",inset=.02, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(DateTime, Global_reactive_power, type="l", xlab="datetime")
    
    dev.copy(png, "plot4.png", width=480, height=480)
    dev.off()
})