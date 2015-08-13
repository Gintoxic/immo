ginhist2d<-
function (x, y = NULL,val, nbins = 200, same.scale = FALSE, na.rm = TRUE, 
          show = TRUE, col = c("black", heat.colors(12)), FUN = base::length, 
          func_choice = "sum",
          xlab, ylab, ...) 
{
  if (is.null(y)) {
    if (ncol(x) != 2) 
      stop("If y is ommitted, x must be a 2 column matirx")
    y <- x[, 2]
    x <- x[, 1]
  }
  if (length(nbins) == 1) 
    #nbins <- rep(nbins, 2)
    nbins <- c(nbins, round(nbins*1.375))
  nas <- is.na(x) | is.na(y)
  if (na.rm) {
    x <- x[!nas]
    y <- y[!nas]
  }
  else stop("missinig values not permitted if na.rm=FALSE")
  if (same.scale) {
    x.cuts <- seq(from = min(x, y), to = max(x, y), length = nbins[1] + 
                    1)
    y.cuts <- seq(from = min(x, y), to = max(x, y), length = nbins[2] + 
                    1)
  }
  else {
    x.cuts <- seq(from = min(x), to = max(x), length = nbins[1] + 
                    1)
    y.cuts <- seq(from = min(y), to = max(y), length = nbins[2] + 
                    1)
  }
  index.x <- cut(x, x.cuts, include.lowest = TRUE)
  index.y <- cut(y, y.cuts, include.lowest = TRUE)
  
  
  if (func_choice=="sum")
  {
  m <- tapply(val, list(index.x, index.y), FUN=sum)
  }else if (func_choice=="mean")
  {
  m <- tapply(val, list(index.x, index.y), FUN=mean)  
  }else {warning("unknown function")}
  
  if (identical(FUN, base::length)) 
    m[is.na(m)] <- 0
  if (missing(xlab)) 
    xlab <- deparse(substitute(xlab))
  if (missing(ylab)) 
    ylab <- deparse(substitute(ylab))
  if (show) 
    
    im.ret<-image(x.cuts, y.cuts, m, col = col, xlab = "", ylab = "", xaxt="n" ,yaxt="n" ,
          ...)
  
  
  
#   #labels
#   xx<-im.ret[[2]]
#   yy<-im.ret[[3]]
#   for (j in 1:length(yy))
#   {
#   for (i in 1:length(xx))
#   {
#     mm<-as.matrix(m)
#     print(c(i,j))
# #       if (mm[i,j]!=0){
# #       text(xx[i]+(xx[2]-xx[1])/2, yy [j], i, pos=3)
# #       }
#    }
#   }
  
# print(im.ret)
  midpoints <- function(x) (x[-1] + x[-length(x)])/2
  retval <- list()
  retval$counts <- m
  retval$x.breaks = x.cuts
  retval$y.breaks = y.cuts
  retval$x = midpoints(x.cuts)
  retval$y = midpoints(y.cuts)
  retval$nobs = length(x)
  retval$call <- match.call()
  class(retval) <- "hist2d"
  retval
  return(im.ret)
}