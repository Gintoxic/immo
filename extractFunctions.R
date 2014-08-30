

# returns string w/o leading whitespace
trim.leading <- function (x) sub("^\\s+", "", x)

# returns string w/o trailing whitespace
trim.trailing <- function (x) sub("\\s+$", "", x)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)



immoExtractNodeDdRegular<-function(doc, nodeName)
{
  
  ddClass<-"//dd[@class='<NODE>']"
  req<-gsub("<NODE>",nodeName,ddClass)
  ns<-getNodeSet(doc,req)
  val<-trim(sapply(ns,function(x) xmlValue(x)))[1]
  
  return(val)
  
}

immoExtractNodeDdSpecialNumbers<-function(doc, nodeName)
{
  ddClass<-"//dd[@class='<NODE>']"
  req<-gsub("<NODE>",nodeName,ddClass)
  ns<-getNodeSet(doc,req)
  val<-trim(sapply(ns,function(x) xmlValue(x)))[1]
  
  
  spval<-str_extract(val, "[0-9]+[,][0-9]+[,][0-9]+[.][0-9]+")
  if (is.na(spval))
  {
    spval<-str_extract(val, "[0-9]+[,][0-9]+[.][0-9]+")
    if (is.na(spval))
    {
      spval<-str_extract(val, "[0-9]+[.][0-9]+")
      
    }
  }
  return(spval)
  
}


immoExtractNodeDdSpecialCheck<-function(doc, nodeName)
{
  ddClass<-"//dd[@class='<NODE>']"
  req<-gsub("<NODE>",nodeName,ddClass)
  ns<-getNodeSet(doc,req)
  #val<-sapply(ns,function(x) xmlValue(x))
  
  if (length(ns)==0) {return (0L)}
  else {return(1L)}
  
  
}


immoExtractNodeP<-function(doc, nodeName)
{
  ddClass<-"//p[@class='<NODE>']"
  req<-gsub("<NODE>",nodeName,ddClass)
  ns<-getNodeSet(doc,req)
  val<-sapply(ns,function(x) xmlValue(x))
  return(val)
  #
  # if (length(ns)==0) {return (0L)}
  # else {return(1L)}
  #
  
}