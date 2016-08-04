# Cleanup -----------------------------------------------------------------
rm(list = ls())
gc()

# Setup #
workingDir = "D:/0Formal Education/Data Incubator/Challenge/project_proposal"
setwd(workingDir)
source("helpers.R")
source("GDELT_events_columns_definition.R")

# Setup -------------------------------------------------------------------
packages = c("data.table", "dplyr", "doParallel", "lubridate", "ggplot2", "RgoogleMaps", 
             "ggmap", "mapproj")

globals = list(packages = packages)
rm(packages)
setup_packages(globals$packages)

cl = options(cores=12)
registerDoParallel(cl)
globals$parallel = list(cl=cl)
rm(cl)
involvingEGY = readRDS(file = "involving_egypt.rds")

# Paths and Urls ----------------------------------------------------------



# dataPath = "D:/0Formal Education/Data Incubator/Challenge/project_proposal/data"
relDataPath = "/data"
dataFullPath = paste0(workingDir, relDataPath)
baseEventsFilename = "20130630.export"
reducedEventsFile = "GDELT.MASTERREDUCEDV2.txt"
paths = list(workingDir= workingDir, relDataPath = relDataPath, dataFullPath = dataFullPath, 
             reducedEventsFile = reducedEventsFile)
globals$paths = paths
rm(paths, workingDir, relDataPath, dataFullPath, reducedEventsFile)

# strStartDate <- "2013-04-01"
# strStartDate <- "2014-01-26"
strStartDate <- "2014-03-20"

# strEndDate <- "2013-05-01"
# strEndDate <- "2014-01-22"
strEndDate <- "2015-04-16"
dates = list(strStartDate = strStartDate,strEndDate = strEndDate )
globals$dates = dates
rm(strEndDate, strEndDate, dates)


eventsDataFilenames <- createEventsDataFilenames(strStartDate = globals$dates$strStartDate, strEndDate = globals$dates$strEndDate, relDataPath = globals$paths$relDataPath, workingPath = globals$paths$workingDir )
globals$paths$eventsDataFilenames = eventsDataFilenames
rm(eventsDataFilenames)
gc()
# globals -----------------------------------------------------------------

protestCAMEOCodes = c("140", 
                      "141", "1411", "1412", "1413", "1414", 
                      "142", "1421", "1422", "1423", "1424", 
                      "143", "1431", "1432", "1433", "1434", 
                      "144", "1441", "1442", "1443", "1444", 
                      "145", "1451", "1452", "1453", "1454")



# Preprocessing Data ------------------------------------------------------

gc()
# loading data
# reducedEventsFile = paste0(globals$paths$dataFullPath, "/", globals$paths$reducedEventsFile)

protestsEGY = filter(involvingEGY,
                    EventCode %in% protestCAMEOCodes)

table(involvingEGY$EventCode)
# verbalCooperation = filter(reducedEvents, QuadClass == 1)
# materialCooperation = filter(reducedEvents, QuadClass == 2)
# verbalConflict = filter(reducedEvents, QuadClass == 3)
# materialConflict = filter(reducedEvents, QuadClass == 4)
# rm(verbalCooperation, materialCooperation, verbalConflict, materialConflict)


t = 
      protestsEGY %>%
      group_by(Source, Target) %>%
      summarize(count = n())





# use faster data.table
t = table(factor(involvingEGY$EventCode), )

plotData = t[which( t > quantile(x = plotData, probs = 0.25))]
names(plotData) = names(t)
class(plotData)
dfInvolvingEGY <- data.frame(plotData)
ggplot(dfInvolvingEGY, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity") + theme_bw() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))

# use faster data.table
dfInvolvingEgypt <- data.frame(table(year(involvingEGY$Day)))
ggplot(dfInvolvingEgypt, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity") + theme_bw() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))



gc()

dfInvolvingEgyptLatLong <-
      involvingEGY %>%
      group_by(ActionGeo_Lat, ActionGeo_Long) %>%
      summarise(count = n())

dfprotestsEGYLatLong <-
      protestsEGY %>%
      group_by(ActionGeo_Lat, ActionGeo_Long) %>%
      summarise(count = n() ) %>%
      mutate(freq = count / nrow(protestsEGY))


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
                              aes(x = as.numeric(ActionGeo_Long), y = as.numeric(ActionGeo_Lat), size = count), 
                              alpha = 0.70, pch = 21, colour = "red") + 
            scale_size(range = c(4, 10)) )


print(ggmap(map) + geom_point(data = dfprotestsEGYLatLong, 
                              aes(x = as.numeric(ActionGeo_Long), y = as.numeric(ActionGeo_Lat), size = freq), 
                              alpha = 0.70, pch = 22, colour = "red") + 
            scale_size(range = c(2, 10)) )