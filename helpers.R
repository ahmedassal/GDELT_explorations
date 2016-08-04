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

createEventsDataFilenames <- function (strStartDate, strEndDate, relDataPath, workingPath) {
  startDate <- ymd(strStartDate)
  endDate <- ymd(strEndDate)
  daysRange = endDate - startDate
  interestingDates =  seq.Date(as.Date(startDate), as.Date(endDate), "days")
  eventsFilenames = paste0(gsub(pattern = "-", replacement = "", x = interestingDates), ".export.csv")
  return(data.frame(eventsFilenames = eventsFilenames, 
            eventsRelPaths = paste0(workingPath, relDataPath, "/", eventsFilenames)))
}