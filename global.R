setwd("~/Projects/R/TAG")
library(RMySQL)
library(DBI)

options(stringsAsFactors=F)
# single = read.csv("Single Level Experiments.csv",as.is=T)
single = read.csv("SingleLevel.csv",as.is=T)
allcolnames = names(single)
sDates = as.Date(as.character(single$Date),"%y%m%d")
HemoDates = as.Date(as.character(single$Hemo.Complex.Prep),"%y%m%d")
date_list = structure(sDates,Class="Date")
earliest = min(date_list,na.rm=TRUE)
latest   = max(date_list,na.rm=TRUE)
sdata = data.frame(format(sDates),single[c("Tag.Name","Station","ChipNum","Status","Num.cells.clean","Num.cells.quality.sequencing")])
names(sdata) = c("Date","Tag","Station","Chip","Status","Clean","Seq")
names.width = 20
format(sdata, width = names.width, justify = "centre")
tags = single[!duplicated(single$Tag.Name),c("Tag.Name")]
machines = sort(single[!duplicated(toupper(single$Station)),c("Station")])
status = single[!duplicated(single$Status),c("Status")]
lohi = strsplit(single$CellsActive,"-")
lo=NULL
hi=NULL
for (i in 1:length(lohi)) {
  lo[i] = as.numeric(lohi[[i]][1])
  hi[i] = as.numeric(lohi[[i]][2])
}
numActive = hi-lo

cy = read.csv("Cy Experiments.csv",as.is=T)
cDates = as.Date(as.character(cy$Date),"%y%m%d")
cdata = data.frame(format(cDates),cy[c("Tag.Name","Station","ChipNum","Status")])

dc = read.csv("DC Competition Experiments.csv", as.is=T)
dDates = as.Date(as.character(dc$Date),"%y%m%d")
ddata = data.frame(format(dDates),dc[c("Tag.Names","Station","ChipNum","Status")])

# gsum=summary(adata$group)
# Chips = gsum[order(-gsum),drop = FALSE]
