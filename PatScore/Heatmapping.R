#requires data from scripting output
row.names(BC.su2c) = BC.su2c$V1
df2 = BC.su2c[,2:57] #select desired columns
colnames(df2) = df2[1,]
df2 = df2[2:1552,]

df3 = data.matrix(df2)
heatmap(df3) #basic heatmap

#stuff for heatmap 2
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
rc <- rainbow(nrow(df3), start=0, end=.3)
cc <- rainbow(ncol(df3), start=0, end=.3)
hv <- heatmap.2(df3, col=cm.colors(255), scale="column", 
      RowSideColors=rc, ColSideColors=cc, margin=c(5, 10), 
      xlab="Tumour Samples", ylab= "Pathway", 
      main="Test", 
      tracecol="green", density="density")