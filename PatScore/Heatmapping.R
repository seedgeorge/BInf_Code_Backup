filter2 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp1/filter2", header=FALSE)

row.names(filter2) = filter2$V1
df = filter2[,2:57] 

namevec <- paste(rep("Su2C",24),1:24)
colnames(df)=namevec

df = data.matrix(df)
heatmap(df)