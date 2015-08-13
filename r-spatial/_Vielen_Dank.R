plot(1, type="n", axes=F, xlab="", ylab="", xlim=c(0-1,3))


for (i in 1:2000)
{
xc=runif(1,min=-2, max=4)
yc=runif(1,min=0.6, max=1.4)
si<-runif(1,min=0.5, max=3)
#colorvec<-rainbow(20)
colorvec<-rainbow(20)#[1:20]

co<-colorvec[round(runif(1,min=1, max=20))]
text(x=xc, y=yc, cex=si, col=co, labels="Vielen Dank")
}




  xc=1
  yc=1
  si<-7
  colorvec<-rainbow(20)
  #colorvec<-terrain.colors(40)[1:20]
  
  co<-colorvec[round(runif(1,min=1, max=20))]
  text(x=xc, y=yc, cex=si, col="black", labels="Vielen Dank", font=2)