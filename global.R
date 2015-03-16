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
sdata = data.frame(format(sDates),single[c("Tag.Name","Full.Name","Station","ChipNum","Status","Num.cells.clean","Num.cells.quality.sequencing","Mean.capturing.level.OC","Capturing.Level.Standard.Deviation","Mean.Dwell.time","Quality.Run")])
names(sdata) = c("Date","Tag","TagName","Station","Chip","Status","Clean","Seq","Mean.OC","sigma.OC","Mean.DT","Quality.Run")

#Aggregation for each Tag
aggtags_mean = aggregate(sdata[c("Mean.OC")],list(Tag=sdata$Tag,TagName=sdata$TagName),mean,na.rm=T)
aggtags_median = aggregate(sdata[c("Mean.OC")],list(Tag=sdata$Tag,TagName=sdata$TagName),median,na.rm=T)
# another way
t2ids = sdata$Tag=="T-00002"
sdata$Tag[t2ids] # has many zeros (not quality runs)
mean(sdata$Mean.OC[t2ids]) # =0.1215
median(sdata$Mean.OC[t2ids]) # is more like 0.194
summary(sdata$Mean.OC[t2ids]) #    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.::0.0000  0.0000  0.1940  0.1215  0.2060  0.4580 
boxplot(sdata[,c("Mean.OC")][ids])
qids = single$Quality.Run == "Yes"
boxplot(sdata[,c("Mean.OC")][t2ids][qids]) # incorrect because has zeros and NAs - same as qt2 below
qt2oc  = sdata[,c("Mean.OC")][t2ids][qids]
median(na.omit(qt2oc[qt2oc>0])) # 0.206
mean(na.omit(qt2oc[qt2oc>0])) # 0.227
boxplot(na.omit(qt2oc[qt2oc>0])) # this looks correct
qt2dt  = sdata[,c("Mean.DT")][t2ids][qids]
median(na.omit(qt2dt[qt2dt>0])) # 0.206
mean(na.omit(qt2dt[qt2dt>0])) # 0.227
boxplot(na.omit(qt2dt[qt2dt>0])) # this looks correct

moc = aggtags_mean$Mean.OC
omoc = moc[order(-moc),drop=TRUE]
#barplot(t(as.matrix(omoc)))
# summaries by tag
tagsumm = by(sdata,sdata["Tag"],summary)
#tagsumm[gtags[1]] # produces summary but 




gtags = single[!duplicated(single$Tag.Name),c("Tag.Name")]
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

tdf=data.frame(single$Tag.Name,single$Mean.capturing.level.OC)

