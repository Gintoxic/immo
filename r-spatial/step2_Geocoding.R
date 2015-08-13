library(RCurl)    # Umgang mit Curl
library(rjson)    # Umgang mit Json

par.useProxy=T


## Nominatim-API URL (OpenStreetMap) 
base_url<-"http://nominatim.openstreetmap.org/search?q=<TO_REPLACE>&format=json&polygon=0&addressdetails=1"

## Googlemaps API URL: Ausgabenverarbeitung muﬂ angepaﬂt werden
base_url<-"http://maps.googleapis.com/maps/api/geocode/json?address=<TO_REPLACE>&sensor=false"


curAdNoblank<-"Viktoriastrasse,Koblenz"
requrl<-gsub("<TO_REPLACE>", curAdNoblank, base_url)



if(par.useProxy){
  curlHandle <- getCurlHandle()
  curlSetOpt(.opts = list(proxy = '10.1.5.3:3128'), curl = curlHandle)
  r <- try(getURL(requrl,curl = curlHandle))
}else{
  r <- try(getURL(requrl))
}

r

s<-fromJSON(r)
str(s)
us<-unlist(s[1])

str(us)
us$