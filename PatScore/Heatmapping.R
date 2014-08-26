#import data sets 
#
filter1 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter1.txt", header=FALSE)
filter2 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter2.txt", header=FALSE)
filter3 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter3 - DNA_repair.txt", header=FALSE) #DNA repair Tier-2 only
filter4 <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/filter4 - Cell_cycle_tier3.txt", header=FALSE) #Cell cycle tier-3 only
su2c.bc2012_titles_finished_temp <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/su2c-bc2012_titles_finished_temp.txt", header=FALSE)
unfiltered = su2c.bc2012_titles_finished_temp


# first rename chosen data as df (data frame)
# df = data set name
df = filter3

#set the data frame first column to being row names
row.names(df) = df$V1
#remove the now-duplicate column
df2 = df[,2:101] 

#read in the list of headers
headers <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC-Su2c Comp2/headers.txt", header=FALSE, stringsAsFactors=FALSE)

#assign headers to dataframe
colnames(df2) = headers

#convert from data frame to numerical matrix
df3 = data.matrix(df2)

#can use the standard heatmap function, but heatmap.2 produces more customisable images

#stuff for heatmap 2 - tells R to install the dependencies IF we need them
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

# setup for Ward clustering dendrograms - prepares distance and cluster vectors
row_distance = dist(df3, method = "manhattan")
row_cluster = hclust(row_distance, method = "ward.D2")
col_distance = dist(t(df3), method = "manhattan")
col_cluster = hclust(col_distance, method = "ward.D2")

#setup for colour palette 
my_palette <- colorRampPalette(c("blue", "yellow"))(n = 299)

#the following makes a good size heatmap suitable for use without row labels - for high-tier analysis
heatmap.2(df3, 
          key = FALSE, #removes the colour key
          #lhei=c(0.2,.5), #optional control of cell height
          margins=c(10,20), #make sure margins are of suitable size
          #labRow = "", #optional to remove the row labels
          Rowv = as.dendrogram(row_cluster),
          Colv = as.dendrogram(col_cluster),
          dendrogram="column",
          scale = "row", 
          ColSideColors = c(rep("orangered",50),rep(rep("skyblue",50))), #this colours the first 50 orange and second 50 blue, matching Su2C and BC2012 layout
          col=my_palette)

# prints out the graph workspace into default R output directory
dev.copy(png,'plot10.png',    
    width = 60*300,       
    height = 30*300,
    res = 500)           
    #pointsize = 15)     
dev.off()   # closes image output