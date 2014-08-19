#import data
filter1 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter1.txt", header=FALSE)

#first rename imported data as df (data frame)
# df = data set name
df = filter2

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

#stuff for heatmap 2 - install the dependencies IF we need them
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

# setup for Ward clustering dendrograms 
row_distance = dist(df3, method = "manhattan")
row_cluster = hclust(row_distance, method = "ward.D2")
col_distance = dist(t(df3), method = "manhattan")
col_cluster = hclust(col_distance, method = "ward.D2")

#setup for colour palette
my_palette <- colorRampPalette(c("blue", "yellow"))(n = 299)

#heatmap.2(df3,
 #         key = FALSE,
  #        lhei=c(0.2,.5),
   #       margins=c(8,5),
    #      labRow = "",
     #     dendrogram="column",
      #    scale = "row",
       #   col=my_palette)

#the following makes a good size heatmap suitable for use without row labels - for high-tier analysis
heatmap.2(df3, 
          key = FALSE,
          lhei=c(0.2,.5),
          margins=c(20,10),
          labRow = "",
          Rowv = as.dendrogram(row_cluster),
          Colv = as.dendrogram(col_cluster),
          dendrogram="column",
          scale = "row",
          col=my_palette)

# prints out the graph workspace
dev.copy(png,'plot3.png',    
    width = 60*300,       
    height = 30*300,
    res = 500,           
    pointsize = 5)     
dev.off()   # closes image output