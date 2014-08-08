filter2 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp1/filter2", header=FALSE)

row.names(filter1) = filter1$V1
df = filter1[,2:57] 

su2c<- paste(rep("Su2C",24),1:24)
bc2012 <- paste(rep("BC2012",32),1:32)
namevec <- c(su2c,bc2012)

colnames(df)=namevec


df = data.matrix(df)
heatmap(df)

#Some stuff to make heatmap.2 more functional
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
