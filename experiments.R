
rm(list = ls())

# Functions Definition #
downloadData = function (dataURL, dataZipPath, dataZipFilename) {
  
  zipFile = paste0(dataZipPath, "/", dataZipFilename)
  #   zipFile
  print(dataURL)
  #   flog.info(zipFile)
  if(file.exists(zipFile)) {
    message("File is already downloaded")
  } else {
    #download.file(url = dataURL, destfile = zipFile, method="wget")
    download.file(url = dataURL, destfile = zipFile, method="curl")    
  }
  
  
  unzip(zipfile = zipFile, overwrite = FALSE, exdir = dataZipPath )
  #   con <- unz(temp, "a1.dat")
  #   data <- matrix(scan(con),ncol=4,byrow=TRUE)
  #   unlink(temp)
}

setup_packages = function(packages){
  inst_pkgs = load_pkgs =  packages  
  inst_pkgs = inst_pkgs[!(inst_pkgs %in% installed.packages()[,"Package"])]
  if(length(inst_pkgs)) install.packages(inst_pkgs)
  # Dynamically load packages
  pkgs_loaded = lapply(load_pkgs, require, character.only=T)
}

deg2rad = function(deg) {
  return(deg * (pi/180))
}

# Haversine formula
getDistanceFromLatLonInMiles = function(lat1,lon1,lat2,lon2) {
  r = 6371 # Radius of the earth in km
  dLat = deg2rad(lat2-lat1) 
  dLon = deg2rad(lon2-lon1) 
  a = 
    sin(dLat/2) * sin(dLat/2) +
    cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * 
    sin(dLon/2) * sin(dLon/2) 
  c = 2 * atan2(sqrt(a), sqrt(1-a)); 
  d = r * c * 0.621371192 # Distance in miles
  
  return (d);
}

readLines2=function(fname) {
  s = file.info( fname )$size 
  buf = readChar( fname, s, useBytes=T)
  strsplit( buf,"\r\n",fixed=T,useBytes=T)[[1]]
}

# Setup #
gc()
packages = c("data.table", "dplyr", "doParallel", "lubridate", "ggplot2", "RgoogleMaps", 
             "ggmap", "mapproj")
globals = list(packages = packages)
rm(packages)
setup_packages(globals$packages)

cl = options(cores=12)
registerDoParallel(cl)
globals$parallel = list(cl=cl)
rm(cl)

# Paths and Urls #
workingDir = "D:/0Formal Education/Data Incubator/Challenge/project_proposal"
setwd(workingDir)

# dataPath = "D:/0Formal Education/Data Incubator/Challenge/project_proposal/data"
dataPath = "/data"
dataFullPath = paste0(workingDir, dataPath)
reducedEventsFile = "GDELT.MASTERREDUCEDV2.txt"



paths = list(workingDir= workingDir, dataPath = dataPath, dataFullPath = dataFullPath, 
             reducedEventsFile = reducedEventsFile)
globals$paths = paths
rm(paths, workingDir, dataPath, dataFullPath, 
   reducedEventsFile)
# globals #
protestCAMEOCodes = c("140", 
                      "141", "1411", "1412", "1413", "1414", 
                      "142", "1421", "1422", "1423", "1424", 
                      "143", "1431", "1432", "1433", "1434", 
                      "144", "1441", "1442", "1443", "1444", 
                      "145", "1451", "1452", "1453", "1454")
# Preprocessing Data #
gc()

# loading data
reducedEventsFile = paste0(globals$paths$dataFullPath, "/", globals$paths$reducedEventsFile)
reducedEvents = fread(reducedEventsFile, nrows = -1, header = TRUE)
headers = strsplit(readLines(reducedEventsFile, n =1) ,"\t",fixed=T,useBytes=T)[[1]]
setnames(reducedEvents, headers)

# needs faster column setting using data.table methods
reducedEvents$Date <- ymd(reducedEvents$Date)
# lines = strsplit(readLines(reducedEventsFile, n =4) ,"\t",fixed=T,useBytes=T)
gc()
# verbalCooperation = filter(reducedEvents, QuadClass == 1)
# materialCooperation = filter(reducedEvents, QuadClass == 2)
# verbalConflict = filter(reducedEvents, QuadClass == 3)
# materialConflict = filter(reducedEvents, QuadClass == 4)
# rm(verbalCooperation, materialCooperation, verbalConflict, materialConflict)
gc()

involvingEGYBase = filter(reducedEvents, 
            grepl("EGY", reducedEvents$Source, ignore.case = TRUE, fixed = TRUE) 
            | 
            grepl("EGY", reducedEvents$Target, ignore.case = TRUE, fixed = TRUE)
            )

# materialViolenceEGY = filter(involvingEGYBase, 
#                       QuadClass == 4,
#                       )

protestEGY = filter(involvingEGYBase,
                    CAMEOCode %in% protestCAMEOCodes)

t = 
  protestEGY %>%
  group_by(Source, Target) %>%
  summarize(count = n())

# print(head(invovlingEGY))
# print(tail(invovlingEGY))

involvingEGY = protestEGY
gc()

# use faster data.table
dfReducedEvents <- data.frame(table(year(reducedEvents$Date)))
ggplot(dfReducedEvents, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity") + theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# use faster data.table
dfInvolvingEgypt <- data.frame(table(year(involvingEGY$Date)))
ggplot(dfInvolvingEgypt, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity") + theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



gc()

dfInvolvingEgyptLatLong <-
  involvingEGY %>%
  group_by(ActionGeoLat, ActionGeoLong) %>%
  summarise(count = n())

dfInvolvingEgyptLatLong <-
  protestEGY %>%
  group_by(ActionGeoLat, ActionGeoLong) %>%
  summarise(count = n())

mapRangeLat = c(min(dfInvolvingEgyptLatLong$ActionGeoLat, na.rm = TRUE), 
                max(dfInvolvingEgyptLatLong$ActionGeoLat, na.rm = TRUE))
mapRangeLong = c(min(dfInvolvingEgyptLatLong$ActionGeoLong, na.rm = TRUE), 
                 max(dfInvolvingEgyptLatLong$ActionGeoLong, na.rm = TRUE))
mapCenter = c(lat = mean(dfInvolvingEgyptLatLong$ActionGeoLat, na.rm = TRUE), 
              lon = mean(dfInvolvingEgyptLatLong$ActionGeoLong, na.rm = TRUE))
mapCenter2 = c(lon = mean(dfInvolvingEgyptLatLong$ActionGeoLong, na.rm = TRUE), 
               lat = mean(dfInvolvingEgyptLatLong$ActionGeoLat, na.rm = TRUE))
mapZoom = min(MaxZoom(latrange = range(mapRangeLat), lonrange = range(mapRangeLong), size = c(640, 640)))

map <- get_map()
ggmap(map)
# And download a map file!
# bbox = c(left = mapRangeLong[1], bottom = mapRangeLat[1], 
#          right = mapRangeLong[2], top = mapRangeLat[2]),
osm <- get_openstreetmap(urlonly = TRUE)
ggmap(osm)

map <- get_map(location = mapCenter2, zoom = mapZoom+2, scale = 2, 
               
               maptype = "terrain", source = "osm")

print(ggmap(map) + geom_point(data = dfInvolvingEgyptLatLong, aes(x = ActionGeoLong, y = ActionGeoLat, 
                                             size = count), alpha = 0.3))



# test
# Egypt
lat <- c(22.000000, 31.674179)
lon <- c(24.698099, 36.894680)

# Greater Cairo
lat <- c(27.659269, 30.228649)
lon <- c(27.214060, 31.466619)

center = c(lat = mean(lat), lon = mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))

# And download a map file!
map <- get_map(location = c(lon = mean(lon), lat = mean(lat)), zoom = zoom, maptype = "terrain", 
               source = "google", scale = 4)
print(ggmap(map) + geom_point(data = dfInvolvingEgyptLatLong, 
                              aes(x = ActionGeoLong, y = ActionGeoLat, size = count), 
                              alpha = 0.70, pch = 21, colour = "red") + 
                              scale_size(range = c(4, 10)) )