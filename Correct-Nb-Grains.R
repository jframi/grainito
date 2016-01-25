library(data.table)
#A changer
setwd("/path/to/images/")
grains<-read.table("grainito.out",header=T,sep="\t")
pdf("graphiques.pdf")

#Examen des outliers de taille
boxplot(Area~File, data=grains, pch=21,cex=0.3,names=c(1:length(unique(grains$File))),bg="black",ylim=c(0,4000))
#pb sur la serie 301 a 350 : grains mal étalés

#correction des grains agglomerés
#stats type boxplot pour chaque image sur l'Integrated density
grains.intd.bxp<-lapply(split(grains, grains$File), function(a) boxplot.stats(a$RawIntDen))

GR<-data.table(grains)
GR[,ID:=1:nrow(GR)]
setkey(GR,File)
files<-unique(grains$File)
nfile<-length(files)
grains.out.ids<-NULL
for (i in files){
  
  grains.file.i<-GR[i]
  outs.i<-grains.intd.bxp[[i]]$out
  #on enleve pour chaque fichier les grains identifiés comme outliers
  grains.out.ids<-c(grains.out.ids,grains.file.i[match(outs.i,grains.file.i$RawIntDen),ID])
  print(i)
}
setkey(GR,ID)
GR.noout<-GR[-grains.out.ids,]

#Examen des outliers de taille sur fichier nettoyé
boxplot(Area~File, data=GR.noout, pch=21,cex=0.3,names=c(1:length(unique(grains$File))),bg="black",ylim=c(0,4000))
#ouf ca va mieux

#correction du nombre de grains:
#Nombre de grains initial:
nbgrain.init<-as.vector(by(grains,grains$File,nrow))
#Nombre de grains corrigé:
#Pour chaque grain outlier l'Intden est divisé par l'Intden moyenne des grains standards pour determiner le nombre de grain que chacun des outliers représente
nbgrain.corr<-sapply(1:nfile,function(a) grains.intd.bxp[[a]]$n+sum(round(grains.intd.bxp[[a]]$out/mean(grains.intd.bxp[[a]]$conf),0)))
plot(nbgrain.init,nbgrain.corr)
lines(c(200,500),c(200,500))
write.table(data.frame(File=names(grains.intd.bxp),NBGR=unlist(lapply(grains.intd.bxp,function(a) a$n)),NBGR.corr=nbgrain.corr),file="NewNBGR.txt",quote=F,row.names=F)

dev.off()