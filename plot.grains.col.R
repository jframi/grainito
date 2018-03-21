require(plotrix)
require(colorspace)

plot.grains.cols<-function(x,img,plot=c("rect","pie","grains")){
if (missing(x) & !missing(img)){
res<-list()
  for (i in img){
    mains<-read.table(paste(i,".main.txt",sep=""),skip=1,header=F)
    colnames(mains)<-c("Grain","Area","Mean","X","Y","Perim.","BX","BY","Width","Height","Major","Minor","Angle","Circ.","Feret","IntDen","Median","Skew","Kurt","%Area","RawIntDen","Slice","FeretX","FeretY","FeretAngle","MinFeret","AR","Round","Solidity")
    red<-read.table(paste(i,".red.txt",sep=""),skip=1,header=F)
    green<-read.table(paste(i,".green.txt",sep=""),skip=1,header=F)
    blue<-read.table(paste(i,".blue.txt",sep=""),skip=1,header=F)
    #browser()
    cols<-rgb(red[,2],green[,2],blue[,2],maxColorValue=255)
    colhsv<-rgb2hsv(red[,2],green[,2],blue[,2],maxColorValue=255)
    collab<-t(coords(as(RGB(red[,2]/255,green[,2]/255,blue[,2]/255),"LAB")))
    meanlab<-apply(collab,1,mean)
    meanrgb<-apply(col2rgb(cols),1,mean)
    #cols<-cols[order(colhsv[1,])]
    res[[i]]<-list(Main=mains,col=cols,rgb=col2rgb(cols),hsv=colhsv,lab=collab,meanrgb=meanrgb,meanlab=meanlab)
  }
}else{
  if (!missing(x)){
    res<-x
}
}
if (plot=="pie"){
  resc<-lapply(res,function(a) a$col)
  reschsv<-lapply(res,function(a) a$hsv)
  resrgb<-lapply(resc,function(a) col2rgb(a)/255)

  reslab<-lapply(resrgb, function(a) as(RGB(a[1,],a[2,],a[3,]),"LAB"))
  #sortvec<-lapply(reslab,function(a) order(coords(a)[,1]))
  #sort by HSP Color Model
  sortvec <-lapply(resrgb, function(a) order(apply(a,2,function(a) sqrt(0.299 * a[1]^2+ 0.587 * a[2]^2 + 0.114 * a[3]^2))))

  resc<-lapply(seq_along(resc),function(a) resc[[a]][sortvec[[a]]])
  lapply(seq_along(resc),function(a) plot.palette(resc[[a]],1,length(resc[[a]]),border=NA,labels=NA,main=names(reschsv)[a]))
} else {
  if (plot=="rect"){
    resc<-lapply(res,function(a) a$col)
    reschsv<-lapply(res,function(a) a$hsv)
    #browser()
    #sortvec<-lapply(reschsv,function(b) order(apply(b,2,function(a) a[3]*5 + a[2]*2 + a[1])))
    #sortvec<-lapply(reschsv,function(b) order(b[1,]))
    #sortvec<-lapply(resc,function(a) order(sapply(a,function(b) rgb2yuv(col2rgb(b))[1])))

    resrgb<-lapply(resc,function(a) col2rgb(a)/255)

    reslab<-lapply(resrgb, function(a) as(RGB(a[1,],a[2,],a[3,]),"LAB"))
    reshls<-lapply(resrgb, function(a) as(RGB(a[1,],a[2,],a[3,]),"HLS"))
    #Sort by Hue
    #sortvec<-lapply(reshls,function(a) order(coords(a)[,1]))
    #sort by relative luminance: https://en.wikipedia.org/wiki/Relative_luminance
    #sortvec <-lapply(resrgb, function(a) order(apply(a,2,function(a) 0.2126 * a[1] + 0.7152 * a[2] + 0.0722 * a[3])))
    #sort by HSP Color Model
    sortvec <-lapply(resrgb, function(a) order(apply(a,2,function(a) sqrt(0.299 * a[1]^2+ 0.587 * a[2]^2 + 0.114 * a[3]^2))))

    resc<-lapply(seq_along(resc),function(a) resc[[a]][sortvec[[a]]])
    names(resc)<-names(res)
    old.xpd <- par("xpd")
    old.xaxt <- par("xaxt")
    old.yaxt <- par("yaxt")
    old.las <- par("las")
    old.mai <- par("mai")
    old.bty <- par("bty")
    on.exit(par(xpd=old.xpd,xaxt=old.xaxt,yaxt=old.yaxt,las=old.las,mai=old.mai,bty=old.bty))
    par(xpd=NA,xaxt="n",las=1,mai=c(0,0,1,0),yaxt="n",bty="n")
    plot(0,0,type="n",ylim=c(0,length(resc)+1),xlim=c(0,20+max(unlist(lapply(resc,length)))))

    lapply(seq_along(resc), function(i) rect(xleft=10+(1:length(resc[[i]])),xright=10+(1:(length(resc[[i]])))+1,ybottom=i,ytop=i+1,col=resc[[i]],border=NA))
    lapply(seq_along(resc), function(i) rect(xleft=1,xright=10,ybottom=i,ytop=i+1,col=rgb(apply(col2rgb(resc[[i]]),1,mean)[1],apply(col2rgb(resc[[i]]),1,mean)[2],apply(col2rgb(resc[[i]]),1,mean)[3],maxColorValue=255),border=NA))
    text(x=5,y=c(1:length(resc))+.5,labels=gsub("\\.jpg$","",names(resc)),srt=0,cex=0.8, col=unlist(lapply(lapply(resrgb, function(a) 1-apply(a,1,mean)),function(a) rgb(a[1],a[2],a[3]))))

  } else{
    if (plot=="grains"){
      lapply(seq_along(res),function(a){
        plot(0,0,type="n", asp=1, axes=F, frame.plot=T, xlab=NA,ylab=NA, xlim=c(0,max(res[[a]]$Main$X)),main=names(res)[a],ylim=c(max(res[[a]]$Main$Y),0))
        symbols(x=res[[a]]$Main$X,y=res[[a]]$Main$Y,circles=0*res[[a]]$Main$Minor/2,bg=res[[a]]$col,inches=F,asp=1, add=T)
        draw.ellipse(x=res[[a]]$Main$X,y=res[[a]]$Main$Y,a=res[[a]]$Main$Major/2,b=res[[a]]$Main$Minor/2,angle=-res[[a]]$Main$Angle, col=res[[a]]$col)
        #plot(x=res[[a]]$Main$X,y=res[[a]]$Main$Y,type="n",ylim=c(max(res[[a]]$Main$Y),0),xlab=NA,ylab=NA,main=names(res)[a])
        #draw.ellipse(x=res[[a]]$Main$X,y=res[[a]]$Main$Y,a=res[[a]]$Main$Major/2,b=res[[a]]$Main$Minor/2,angle=res[[a]]$Main$Angle,col=res[[a]]$col)
        }
        )
    }

  }
}

if (missing(x) & !missing(img)){
  return(res)
}
}


rgb2yuv<-function(rgb){
  coeffs<-matrix(c(0.299,-0.14713,0.615,0.587,-0.28886,-0.51499,0.114,0.436,-0.10001),nrow=3)
  return(as.numeric(coeffs%*%rgb))
}

sort.lab<-function(d,w){
  N<-(nrow(d)-1)
  m<-w
  res<-rownames(d)[m]
  for (i in c(1:N)){
    n<-which.min(d[,m][-m])
    if (n>m) n<-n+1
    res<-c(res,rownames(d)[n])
    d<-d[-m,-m]
    if (n>m) m<-n-1 else m<-n

  }
  return(as.numeric(res))
}

plot.palette <-  function(pal=palette(),min,max,...) {
    pie(rep(1, max+1-min), col = pal[min:max], radius = 0.9 ,cex=0.6,...)}

