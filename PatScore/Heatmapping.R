BC2012_07.16.2014.aggregate <- read.delim("~/GitHub/BInf_Code_Backup/PatScore/Results/BC2012_07.16.2014/BC2012_07.16.2014-aggregate.txt", header=FALSE, stringsAsFactors=FALSE)
View(BC2012_07.16.2014.aggregate)
BC2012 = BC2012_07.16.2014.aggregate
rm(BC2012_07.16.2014.aggregate)

row.names(BC2012) = BC2012$V1