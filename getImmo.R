
library(XML)
library(rjson)


getImmo<-function (type="Wohnung-Miete",region="Rheinland-Pfalz/Koblenz", maxPages=20)
{
# 
#   type="Wohnung-Miete"
#   region="Rheinland-Pfalz/Koblenz"
#   maxEntries=10
  
  
  before<-"http://www.immobilienscout24.de/Suche/S-T"
  
  #after<-""
  #url<-"http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Rheinland-Pfalz/Koblenz?enteredFrom=one_step_search"
  #http://www.immobilienscout24.de/Suche/S-T/P-002/Wohnung-Miete/Rheinland-Pfalz/Koblenz?pagerReporting=true
  
  continue<-1
  counter<-1
  
  while (continue==1)
  {
  
   if (counter==1)
   {
     pagenum<-paste("P-",formatC(0, width = 4, format = "d", flag = "0"), sep="") 
   }else{
     pagenum<-paste("P-",formatC(counter, width = 4, format = "d", flag = "0"), sep="") 
   }
     
  
   
  myurl<-paste(before, pagenum,type, region, sep="/")
  print(myurl)

  
  doc<-htmlParse(myurl, encoding="UTF-8")

  ch<-as(doc, "character")
  jsonstart<-regexpr("model:",ch)[1]+7
  jsonend<-regexpr("travelTimeModel",ch)[1]-1
  
  chjson<-substr(ch, jsonstart,jsonend)
  fj<-fromJSON(chjson)
  
  
  attriblist<-c("id","cwid", "privateOffer" ,"title", "address", "district","city", "zip", "attributes")
  
  empty<-matrix(nrow=length(fj$results), ncol=length(attriblist))
  
  colnames(empty)<-attriblist
  
  frame<-as.data.frame(empty)
  

  for (i in 1:length(fj$results))
  {
    
    cur<-fj$results[[i]]
    
    for (j in 1:length(attriblist))
    {
      
      if (attriblist[j]!="attributes")
      {
        frame[i,attriblist[j]]<-cur[[attriblist[j]]]
      }else{
        frame[i,attriblist[j]]<-paste(cur[[attriblist[j]]], collapse=";")
      }
      
      
    }# for
    
  }# for
  
  #frame
#   importdate=strftime(Sys.Date(),format="%Y-%m-%d" )
#   for (i in 1:dim(frame)[1])
#   {
#     readWriteExpose(id=frame$id[i], importdate=importdate)
#     
#   }
#   
  
  
    if(counter==1)
    {
      frameAll<-frame
      frameLast<-frame
    }else{
        
      
      if(identical(frame,frameLast) | counter>maxPages)
      {
        continue=0
        
      }else{
      frameAll<-rbind(frameAll, frame)
      frameLast<-frame
      }#else
    }#else
  counter<-counter+1
}#while
  
return(frameAll)
}#function