library(ggplot2)
library(igraph)
library(plotly)

setwd("~/Dropbox (Ocular Genomics)/Segre_lab/Lab_members/Jiali_Wang/GTExsampleQC/Data")
sds<-readRDS(file = "sds.rds")

outliers <- read.delim("flagged_samples_not_FstatZscore.txt",sep="\t",header=T)
outliers <- as.character(outliers[,1])
annotation <- sds$zscoreBy
primaryID<-"sample_id"

data<-sds$df

ibd <- read.delim(file="GTEx_WGS_v9_979_QC_July2018.ibd.tsv",sep="\t",header=T)
