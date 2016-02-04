library(plotKML)
library(dplyr)
library(geosphere)
library(lubridate)

dir <- "C:\\Users\\Varun\\Desktop\\Varun\\Runkeeper\\GPX_Varun"
setwd(dir)

gpsFiles <- list.files(pattern="*.gpx")
fileList <- lapply(gpsFiles, readfile)
fileList <- mapply(cbind, fileList, GPX.File = gpsFiles, SIMPLIFY = FALSE)
gpsData <- do.call("rbind",fileList)

gpsData$time <- ymd_hms(gpsData$time)
gpsData$ele <- as.numeric(gpsData$ele)

readfile <- function(x)
  { 
    gpxData <- readGPX(x)
    gpxData$tracks[[1]][[1]]
}


