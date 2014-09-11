
vec<-c(1, "Wohnung-Miete",2,"Haus-Miete",3,"Wohnung-Kauf",4,"Haus-Kauf",5,"Grundstueck-Kauf",6, "Versteigerung")
#vec<-c(5,"Grundstueck-Kauf",6, "Versteigerung")
#vec<-c(2,"Haus-Miete",3,"Wohnung-Kauf",4,"Haus-Kauf",5,"Grundstueck-Kauf",6, "Versteigerung")
#vec<-c(7,"Buero-Praxis",8,"Wohnung-Kauf",9,"Haus-Kauf",10,"Grundstueck-Kauf",11, "Versteigerung")

qframe<-as.data.frame(matrix(vec, ncol = 2, byrow = T))
colnames(qframe)<-c("qtype","qstring")

dim(qframe)
