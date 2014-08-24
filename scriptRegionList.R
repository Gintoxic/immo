load("../immoData/DEU_adm1.Rdata")

regionList<-names(table(gadm$NAME_1))

regionList[16]<-"Thueringen"
regionList[1]<-"Baden-Wuerttemberg"

#regionList<-"Nordrhein-Westfalen"

#regionList<-regionList[2:16]
#regionList<-"Baden-Wuerttemberg"
#regionList<-"Thueringen"
#region<-"Thueringen"
