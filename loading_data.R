
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
# Preprocessing Data #
gc()

# loading data
# reducedEventsFile = paste0(globals$paths$dataFullPath, "/", globals$paths$reducedEventsFile)
nrow(globals$paths$eventsDataFilenames)

# Original Data Loading ---------------------------------------------------
# events = data.table()
# i <- 1
# for(eventsDataFilename in globals$paths$eventsDataFilenames[,2]){
#       print(paste0("#",i, "/", nrow(globals$paths$eventsDataFilenames), " ", eventsDataFilename))
#       events = rbind(events, fread(as.character(eventsDataFilename), 
#                      nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03))      
#       i= i + 1
#       if(i %% 50 == 0){
#             gc()
#       }
#  
#       
# }

# Temp Data Loading ---------------------------------------------------
i <- 1
for(eventsDataFilename in globals$paths$eventsDataFilenames[,2]){
      print(paste0("#",i, "/", nrow(globals$paths$eventsDataFilenames), " ", eventsDataFilename))
      tempEvents = fread(as.character(eventsDataFilename), 
            nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03)
#       if (i == 1){
            headers = dailyEventsColNamesV1_03
            setnames(tempEvents, headers)
#       }
            
      involvingEGYBase = filter(
            tempEvents, 
            grepl("EGY", tempEvents$Actor1Code, ignore.case = TRUE, fixed = TRUE) 
            | 
            grepl("EGY", tempEvents$Actor1Name, ignore.case = TRUE, fixed = TRUE)
            |
            grepl("EGY", tempEvents$Actor1CountryCode, ignore.case = TRUE, fixed = TRUE)
            |
            grepl("EGY", tempEvents$Actor2Code, ignore.case = TRUE, fixed = TRUE) 
            | 
            grepl("EGY", tempEvents$Actor2Name, ignore.case = TRUE, fixed = TRUE)
            |
            grepl("EGY", tempEvents$Actor2CountryCode, ignore.case = TRUE, fixed = TRUE)
            |
            grepl("EGY", tempEvents$ActionGeo_CountryCode, ignore.case = TRUE, fixed = TRUE)
      )
      if (i == 1){
            involvingEGY = involvingEGYBase
      }else{
            involvingEGY = rbindlist(list(involvingEGY, involvingEGYBase), use.names = TRUE)      
      }
                  
      if(i %% 100 == 0){
            gc()
            saveRDS(involvingEGY, file = "involving_egypt.rds")
      }
      i= i + 1
      
      
}

headers = dailyEventsColNamesV1_03
setnames(involvingEGY, headers)
gc()
saveRDS(involvingEGY, file = "involving_egypt.rds")

# events2 = data.table()
# events2 = rbind(events2, fread(as.character(globals$paths$eventsDataFilenames[1,2]), 
#                              nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03))
# events2 = rbind(events2, fread(as.character(globals$paths$eventsDataFilenames[2,2]), 
#                              nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03))
# events2 = rbind(events2, fread(as.character(globals$paths$eventsDataFilenames[3,2]), 
#                              nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03))
# events2 = rbind(events2, fread(as.character(globals$paths$eventsDataFilenames[4,2]), 
#                              nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03))
# events = fread(as.character(globals$paths$eventsDataFilenames[1,2]), 
#                nrows = -1, header = FALSE, colClasses = dailyEventsColClassesV1_03)



# needs faster column setting using data.table methods
# reducedEvents$Date <- ymd(reducedEvents$Date)

gc()

# verbalCooperation = filter(reducedEvents, QuadClass == 1)
# materialCooperation = filter(reducedEvents, QuadClass == 2)
# verbalConflict = filter(reducedEvents, QuadClass == 3)
# materialConflict = filter(reducedEvents, QuadClass == 4)
# rm(verbalCooperation, materialCooperation, verbalConflict, materialConflict)
gc()
# 
# involvingEGYBase = filter(
#       events, 
#       grepl("EGY", events$Actor1CountryCode, ignore.case = TRUE, fixed = TRUE) 
#       | 
#       grepl("EGY", events$Actor2CountryCode, ignore.case = TRUE, fixed = TRUE)
#       |
#       grepl("EGY", events$ActionGeo_CountryCode, ignore.case = TRUE, fixed = TRUE)
# )

# involvingEGYBase = filter(
#       events, 
#       grepl("EGY", events, ignore.case = TRUE, fixed = TRUE) )
# 
#       | 
#             grepl("EGY", events$Actor2CountryCode, ignore.case = TRUE, fixed = TRUE)
#       |
#             grepl("EGY", events$ActionGeo_CountryCode, ignore.case = TRUE, fixed = TRUE)
# )

# materialViolenceEGY = filter(involvingEGYBase, 
#                       QuadClass == 4,
#                       )

protestEGY = filter(involvingEGYBase,
                    EventCode %in% protestCAMEOCodes)

t = 
  protestEGY %>%
  group_by(Source, Target) %>%
  summarize(count = n())

# print(head(invovlingEGY))
# print(tail(invovlingEGY))

involvingEGY = protestEGY
gc()