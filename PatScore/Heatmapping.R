Su2C <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/su2c_08.06.2014/su2cHMtest.txt", header=FALSE, stringsAsFactors=FALSE)
View(Su2C)

row.names(Su2C) = Su2C$V1
Su2Chm = Su2C[,2:25] 

namevec <- paste(rep("Su2C",24),1:24)
colnames(Su2Chm)=namevec

Su2Chm = data.matrix(Su2Chm)
heatmap(Su2Chm)