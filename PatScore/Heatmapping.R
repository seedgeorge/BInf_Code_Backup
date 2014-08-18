#import data
filter1 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter1.txt", header=FALSE)

#first rename imported data as df (data frame)
# df = data set name
df = filter1

#set the data frame first column to being row names
row.names(df) = df$V1
#remove the duplicate column
df2 = df[,2:101] 

#read in the list of headers
headers <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/headers.txt", header=FALSE, stringsAsFactors=FALSE)

#assign headers to dataframe
colnames(df2) = headers

#convert from data frame to numerical matrix
df3 = data.matrix(df2)

#basic heatmap
heatmap(df3) 

#stuff for heatmap 2
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

my_palette <- colorRampPalette(c("blue", "yellow"))(n = 299)

heatmap.2(df3,
          key = FALSE,
          lhei=c(0.2,.5),
          margins=c(10,15),
          
          dendrogram="column",
          scale = "row",
          col=my_palette)

