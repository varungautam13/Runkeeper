dir <- "C:\\Users\\gautamv001\\Desktop\\Varun -R\\Runkeeper\\GPX_Varun"
setwd(dir)

## Read all the .gpx files to fetch lat, lon, elevation & time
gpsFiles <- list.files(pattern="*.gpx")
fileList <- lapply(gpsFiles, readfile)

## Adding file name to the respective gps data for identification
## Converting list of all gps data to data frame
fileList <- mapply(cbind, fileList, GPX.File = gpsFiles, SIMPLIFY = FALSE)
gpsData <- do.call("rbind",fileList)

## Transforming variable to their correct types
gpsData <- gpsData %>% 
    transform(time = ymd_hms(time),
              ele = as.numeric(ele), 
              GPX.File = as.character(GPX.File))


## creating new columns
## point_distance (distance between each lat and lon)
## Point_time (time between each lat and lon covered)
gpsData <- gpsData %>% 
    rowwise() %>%
    mutate (point_distance = distHaversine (c(prevlat, prevlon),c(lat,lon)),
           point_time = time.x-time.y)
           
           ----------------------------------
           
  

a <- gpsData1 %>% filter(GPX.File=="2015-11-29-0711.gpx")
a$cum_sum[6657]

lat_lon <- gpsData %>% select(prevlon=lon, prevlat=lat)
lat_lon <- lat_lon[-nrow(gpsData),]
first_data <- lat_lon[1,]
lat_lon <- rbind(first_data,lat_lon)
gpsData <- cbind(gpsData,lat_lon)

start_time <- gpsData %>% group_by(GPX.File) %>% slice(1) %>%
    select(GPX.File,time)
gpsData <- inner_join(gpsData,start_time, by="GPX.File")
gpsData<- gpsData[1:5,]

gpsData1 <- gpsData %>% 
    group_by(GPX.File) %>%
    mutate(cum_sum = cumsum(point_distance))

gpsData1 <- gpsData %>% 
    group_by(GPX.File) %>% 
    select(prevlon=lon, prevlat=lat) %>% 
    slice(-n()) 

start_latlon <- gpsData %>% group_by(GPX.File) %>% slice(1) %>%
    select(GPX.File,lon,lat,time.x)
    

------------------------------------------------
library(plotKML)
library(dplyr)
library(geosphere)
library(lubridate)

readfile <- function(x)
{ 
    gpxData <- readGPX(x)
    gpxData$tracks[[1]][[1]]
}




