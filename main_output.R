#######################################################################
### This document produces the final output (clusters and figures)  ###
#######################################################################

######### setup #########
library(TraMineR)
library(cluster)
library(WeightedCluster)
library(plyr)
library(Hmisc)
library(SDMTools)
library(weights)
library(aod)
library(sp)
library(mlogit)
library(RColorBrewer)


## SET WORKING DIRECTORY TO SOURCE FILE ##


######### define weighted sequences #########

# read employment seq with maternity leave
emp.data <- read.csv("../data/monthly_df.csv", header=TRUE)
head(emp.data)

names(emp.data)[1:10]
ncol(emp.data)
dim(emp.data)

# replace 0 with NA - first 3 columns are "caseid_1979" "start_y"     "start_m"
emp.data[, 4:231][emp.data[, 4:231]==0] <- NA

# read weights (2 kinds)
all.wt <- read.table('../data/customweight_nlsy79_all.txt')
all.wt <- rename(all.wt, c("V1"="caseid_1979", "V2"="all.wt"))

any.wt <- read.table('../data/customweight_nlsy79_any or all.txt')
any.wt <- rename(any.wt, c("V1"="caseid_1979", "V2"="any.wt"))

# merge weights into emp.data
emp.data <- merge(emp.data, all.wt, by='caseid_1979')
emp.data <- merge(emp.data, any.wt, by='caseid_1979')
head(emp.data)

# define employment status labels and codes

### coding scheme ###
# 0 - missing
# 1 - full-time employment - hours >= 35
# 2 - part-time 1 - hours [20, 35)
# 3 - part-time 2 - hours < 20
# 4 - working with missing hours
# 5 - unemployed
# 6 - OOLF
# 7 - nonworking, but DK whether OOLF or unemployed
# 8 - within-job gaps

emp.labels <- c("Full-time employed", 
                "Part-time employed",
                "Marginally employed",
                "Employed with missing hours",
                "Unemployed",
                "Out of labor force",
                "Nonworking (unemployed or OOLF)", 
                "Within-job gaps")

emp.scode <- seq(1, 8)


# make employed statuses different shades of blue, nonemployed statuses orange
brewer.pal(n = 8, name = "OrRd")
brewer.pal(n = 8, name = "Blues")
colors <- c("#DEEBF7", "#9ECAE1", "#4292C6", "#084594", "#EF6548", "#FDBB84", "#990000", "#FDD49E") 
 


# create TraMineR sequence object, use any.weight for analysis
# seq starts from 16th column because we included one year prebirth
emp.seq <- seqdef(emp.data[, 16:231], weights=emp.data$any.wt, states = emp.scode, 
                  labels = emp.labels, right=NA, cpal=colors)



######### create state distribution plot #########

# state distribution plot by default
seqdplot(emp.seq, withlegend=F, border=NA, title=NULL, axes=FALSE, 
         with.missing=T, xlab="Year since birth", ylab="Frequency (weighted)")
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1)


######### create a nicer state distribution plot                           #########
######### add one-year pre-birth into state distribution plot              #########
######### show rare statuses at the top and common statuses at the bottom  #########

ncol(emp.data) # 233
emp.seq.nicer <- emp.data[, 4:231] # last two columns are newly added weights


# re-assign values in order to plot least common status at top and 
# most common status at bottom
# i.e. smallest status number is at the bottom

# 0 - missing
# 1 - full-time employment - hours >= 35 
# 2 - part-time 1 - hours [20, 35) 
# 3 - part-time 2 - hours < 20 
# 4 - working with missing hours
# 5 - unemployed -> 7 NEW
# 6 - OOLF -> 6 NEW
# 7 - nonworking, but DK whether OOLF or unemployed  -> 8 NEW
# 8 - within-job gaps -> 5 NEW

# move maternity (8) in front of unemployed, then switch OOLF and unemployed 
emp.seq.nicer[emp.seq.nicer==5] <- 105
emp.seq.nicer[emp.seq.nicer==6] <- 106
emp.seq.nicer[emp.seq.nicer==7] <- 107
emp.seq.nicer[emp.seq.nicer==8] <- 108

emp.seq.nicer[emp.seq.nicer==105] <- 7
emp.seq.nicer[emp.seq.nicer==106] <- 6
emp.seq.nicer[emp.seq.nicer==107] <- 8
emp.seq.nicer[emp.seq.nicer==108] <- 5


nicer.labels <- c("Full-time employed", 
                    "Part-time employed, 20-35 weekly hours",
                    "Marginally employed, <20 weekly hours",
                    "Employed with missing hours",
                    "Within-job gaps",
                    "Out of labor force (OOLF)",
                    "Unemployed",
                    "Nonworking (unemployed or OOLF)")
nicer.scode <- seq(1, 8)

nicer.colors <- c("#DEEBF7", "#9ECAE1", "#4292C6", "#084594", 
                  "#FDD49E", "#FDBB84", "#EF6548", "#990000") 
emp.seq.color <- seqdef(emp.seq.nicer, weights=emp.data$any.wt, states=nicer.scode, labels=nicer.labels, 
                        right=NA, cpal=nicer.colors)

# output legend
pdf("../plots/legend.pdf")
seqlegend(emp.seq.color, fontsize = 1.3, box.col="white", 
          cpal=c(nicer.colors, 'grey'), ltext=c(nicer.labels, 'Missing'), with.missing=F)
dev.off()

pdf("../plots/legend_horizontal.pdf", width=15)
seqlegend(emp.seq.color, fontsize = 1.3, box.col="white", ncol=2, 
          cpal=c(nicer.colors, 'grey'), ltext=c(nicer.labels, 'Missing'), with.missing=F)
dev.off()


# Figure 1, new distribution plot
#jpeg('../plots/state_distribution.jpeg', width = 800, height = 640, pointsize = 16, quality=800)
pdf('../plots/state_distribution.pdf', width = 50, height = 32, pointsize=50)
par(mar=c(5, 6, 2, 2), mgp = c(4, 1, 0))
seqdplot(emp.seq.color, withlegend = F, border = NA, title=NULL, axes=FALSE,
         with.missing=T, font.lab=2, xlab="Years Since Birth", 
         ylab="Proportion (weighted)", weighted=T, yaxis=FALSE, cex.lab=1.5)
axis(1, at=seq(0, 228, 12), labels=-1:18, cex.axis=1.5)
axis(2, at=seq(0, 1, 0.2), labels=format(seq(0, 1, 0.2), nsmall=2), cex.axis=1.5, las=2)
dev.off()



######### statistics about the state distribution plot #########

#% mothers on within-job gaps immediately followig birth
weighted.mean(emp.seq[,1]==8, emp.data$any.wt)

#% mothers on within-job gaps one year after birth 
weighted.mean(emp.seq[,12]==8, emp.data$any.wt)

#% mothers on within-job gaps 2-5 years after birth
weighted.mean(emp.seq[,25]==8, emp.data$any.wt) #year 2
weighted.mean(emp.seq[,37]==8, emp.data$any.wt) #year 3
weighted.mean(emp.seq[,49]==8, emp.data$any.wt) #year 4
weighted.mean(emp.seq[,61]==8, emp.data$any.wt) #year 5

#% mothers FT one year pre-birth
emp.seq.nicer[is.na(emp.seq.nicer)] <- '*'
weighted.mean(emp.seq.nicer[,1]==1, emp.data$any.wt)

#% mothers FT immediately following birth 
weighted.mean(emp.seq.nicer[,12]==1, emp.data$any.wt)
weighted.mean(emp.seq.nicer[,13]==1, emp.data$any.wt)
weighted.mean(emp.seq[,1]==1, emp.data$any.wt)

#% mothers FT after one year
weighted.mean(emp.seq[,12]==1, emp.data$any.wt) #year 1

for (m in 120:180) {
  print(m/12)
  print(paste(" ", weighted.mean(emp.seq[,m]==1, emp.data$any.wt)))
}
weighted.mean(emp.seq[,144]==1, emp.data$any.wt) # 12 year
weighted.mean(emp.seq[,155]==1, emp.data$any.wt) # 12 year
weighted.mean(emp.seq[,156]==1, emp.data$any.wt) # 13 year
weighted.mean(emp.seq[,157]==1, emp.data$any.wt)

#% mothers FT by children's 18th birthday
weighted.mean(emp.seq[,216]==1, emp.data$any.wt)

#% mothers PT or marginal emp
weighted.mean(emp.seq.nicer[,1] %in% c(2,3), emp.data$any.wt) #1 year before birth
weighted.mean(emp.seq[,1]%in% c(2,3), emp.data$any.wt) #at birth
weighted.mean(emp.seq[,12]%in% c(2,3), emp.data$any.wt) #year 1
weighted.mean(emp.seq[,215]%in% c(2,3), emp.data$any.wt) #year 18

# % unemployed
weighted.mean(emp.seq[,13]==5, emp.data$any.wt) #year 1
weighted.mean(emp.seq[,216]==5, emp.data$any.wt) #year 18

# % missing
weighted.mean(is.na(emp.data$month1), emp.data$any.wt)
weighted.mean(is.na(emp.data$month12), emp.data$any.wt)
weighted.mean(emp.seq[,25]=='*', emp.data$any.wt) # 2nd birthday
weighted.mean(emp.seq[,49]=='*', emp.data$any.wt) # 4th birthday




######### optimal matching #########

# Custom substitution cost matrix

# make an empty matrix (with 0 in each entry)
ccost <- seqsubm(emp.seq, method = "CONSTANT", cval = 0, miss.cost=2.5, with.missing=TRUE)

# between FT and PT1
ccost[1,2] <- 1
ccost[2,1] <- 1
# between FT and PT2
ccost[1,3] <- 2
ccost[3,1] <- 2
# between FT and working, no hours
ccost[1,4] <- 1
ccost[4,1] <- 1
# between FT and unemployed
ccost[1,5] <- 4
ccost[5,1] <- 4
# between FT and OOLF
ccost[1,6] <- 4.5
ccost[6,1] <- 4.5
# between FT and nonworking, DK
ccost[1,7] <- 4.25
ccost[7,1] <- 4.25
# between FT and maternity leave
ccost[1,8] <- 3.5
ccost[8,1] <- 3.5


# between PT1 and PT2
ccost[2,3] <- 1
ccost[3,2] <- 1
# between PT1 and working, no hours
ccost[2,4] <- 1
ccost[4,2] <- 1
# between PT1 and unemployed
ccost[2,5] <- 3
ccost[5,2] <- 3
# between PT1 and OOLF
ccost[2,6] <- 3.5
ccost[6,2] <- 3.5
# between PT1 and nonworking, DK
ccost[2,7] <- 3.25
ccost[7,2] <- 3.25
# between PT1 and maternity leave
ccost[2,8] <- 2.5
ccost[8,2] <- 2.5


# bewteen PT2 and working, no hours
ccost[3,4] <- 1
ccost[4,3] <- 1
# between PT2 and unemployed
ccost[3,5] <- 2
ccost[5,3] <- 2
# between PT2 and OOLF
ccost[3,6] <- 2.5
ccost[6,3] <- 2.5
# between PT2 and nonworking, DK
ccost[3,7] <- 2.25
ccost[7,3] <- 2.25
# between PT2 and maternity leave
ccost[3,8] <- 1.5
ccost[8,3] <- 1.5


# between working, no hours and unemployed
ccost[4,5] <- 3
ccost[5,4] <- 3
# between working, no hours and OOLF
ccost[4,6] <- 3.5
ccost[6,4] <- 3.5
# between working, no hours and nonworking, DK
ccost[4,7] <- 3.25
ccost[7,4] <- 3.25
# between working, no hours and maternity leave
ccost[4,8] <- 2.5
ccost[8,4] <- 2.5


# bewteen unemployed and OOLF
ccost[5,6] <- 0.5
ccost[6,5] <- 0.5
# bewteen unemployed and nonworking, DK
ccost[5,7] <- 0.25
ccost[7,5] <- 0.25
# bewteen unemployed and maternity leave
ccost[5,8] <- 1
ccost[8,5] <- 1

# bewteen OOLF and nonworking, DK
ccost[6,7] <- 0.25
ccost[7,6] <- 0.25
# bewteen OOLF and maternity leave
ccost[6,8] <- 1
ccost[8,6] <- 1

# between nonworking, DK and maternity leave
ccost[7,8] <- 1
ccost[8,7] <- 1


ccost
isSymmetric(ccost)

ccost <- ccost*2

###### Table 1: custom substitution cost matrix ######
ccost

## compute distance using Hamming distance
diss <- seqdist(emp.seq, method="HAM", sm=ccost, with.missing=TRUE)
dim(diss)
diss[1:10, 1:10]



######### weighted clustering analysis #########

## compare three clustering algorithms and a range of clustering solutions 2-15
allClust <- wcCmpCluster(diss, weights=emp.data$any.wt, maxcluster=15, 
                         method=c("average", "ward", "pam"), pam.combine=FALSE)

## Plot quality statisitcs - Silhouette and R squared
# default plots
plot(allClust, stat=c("ASWw", "R2", "R2sq"), lwd=2)

# make nicer plots
attributes(allClust)
attributes(allClust$average)
allClust$average$stats

range(allClust$average$stats[,'ASWw'])
range(allClust$ward$stats[,'ASWw'])
range(allClust$pam$stats[,'ASWw'])

# Figure S2 - ASW
pdf("../plots/ASW.pdf")
par(mar=c(5, 5, 2, 2))
plot(2:15, allClust$average$stats[,'ASWw'], type='l', lwd=2, ylim=c(0,0.50), las=1,
     ylab='', xlim=c(2, 16), xlab='Number of Clusters', main=expression('ASW'), bty='n', cex.main=1.8,
     font.lab=2, cex.lab=1.5, cex.axis=1.5)
lines(2:15, allClust$ward$stats[,'ASWw'], type='l', lwd=2, lty=2)
lines(2:15, allClust$pam$stats[,'ASWw'], type='l', lwd=2, lty=3)
title(ylab='ASW', line=3, cex.lab=1.5)
legend('topright', box.col="white", box.lwd=0, c('Average linkage', "Ward's", "K-medoids"), lty=c(1, 2, 3), cex=1.2)
dev.off()


allClust$average$stats[,c('R2', 'R2sq')] #!!! there's an article saying we should use R2, not R2sq

range(allClust$average$stats[,'R2sq'])
range(allClust$ward$stats[,'R2sq'])
range(allClust$pam$stats[,'R2sq'])


# Figure S2 - R2 using squared distance
pdf("../plots/R2sq.pdf")
par(mar=c(5, 5, 2, 2))
plot(2:15, allClust$average$stats[,'R2sq'], type='l', lwd=2, ylim=c(0.40,0.80), las=1, 
     ylab=expression(R^2 ~ 'using squared dissimilarity'), xlim=c(2, 16), cex.main=1.8,
     xlab='Number of Clusters', 
     main=expression(R^2 ~ 'using squared dissimilarity'), 
     bty='n', font.lab=2, cex.lab=1.5, cex.axis=1.5)
lines(2:15, allClust$ward$stats[,'R2sq'], type='l', lwd=2, lty=2)
lines(2:15, allClust$pam$stats[,'R2sq'], type='l', lwd=2, lty=3)
legend('bottomright', box.col="white", box.lwd=0, c('Average linkage', "Ward's", "K-medoids"), lty=c(1, 2, 3), cex=1.2)
dev.off()


range(allClust$average$stats[,'R2'])
range(allClust$ward$stats[,'R2'])
range(allClust$pam$stats[,'R2'])


# Figure S2 - R2 using unsquared distance
pdf("../plots/R2.pdf")
par(mar=c(5, 6, 2, 2))
plot(2:15, allClust$average$stats[,'R2'], type='l', lwd=2, ylim=c(0.20,0.55), xlim=c(2,16),
     ylab='', xlab='Number of Clusters', cex.main=1.8,
     main=expression(R^2 ~ 'using non-squared dissimilarity'), bty='n', 
     cex.lab=1.5, cex.axis=1.5, font.lab=2, las=1)
title(ylab=expression(R^2 ~ 'using non-squared dissimilarity'), line=3.8, cex.lab=1.5)
lines(2:15, allClust$ward$stats[,'R2'], type='l', lwd=2, lty=2)
lines(2:15, allClust$pam$stats[,'R2'], type='l', lwd=2, lty=3)
legend('bottomright', box.col="white", c('Average linkage', "Ward's", "K-medoids"), lty=c(1, 2, 3), cex=1.2)
dev.off()


######### weighted clustering analysis (cluster 3-6) #########
# we have narrowed down the clustering algorithm and number of clusters
# use wcKMedoids instead of wcKMedRange so that we can use the npass parameter to control for random satrt
set.seed(10)
cmp3 <- wcKMedoids(diss, k=3, weights = emp.data$any.wt, npass=5)
cmp4 <- wcKMedoids(diss, k=4, weights = emp.data$any.wt, npass=5)

set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5 <- wcKMedoids(diss, k=5, weights = emp.data$any.wt, npass=5)

cmp6 <- wcKMedoids(diss, k=6, weights = emp.data$any.wt, npass=5)


######### plot medoids and count frequency/proportion #########

# 3 medoids
unique(cmp3$clustering)
medoids <- c(5, 3410, 3425)

jpeg(filename="../plots/medoids3.jpeg", width=1100, height=400, pointsize=16, quality=1000)
par(mar=c(5, 20, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", yaxis=F, weighted=F, font.lab=2)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1)
labels <- c('Full-time', 'Return', 'Nonemployed')
for (i in 1:3) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp3$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted ', pct, '%)', sep='')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.5)
}
dev.off()



# 4 medoids
unique(cmp4$clustering)
medoids <- c(5, 781, 1074, 422)  

# Figure S3 - 4 medoids
#jpeg(filename="../plots/medoids4.jpeg", width=1100, height=500, pointsize=16, quality=1000)
pdf("../plots/medoids4.pdf", width=60, height=25, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", yaxis=F, 
         weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
labels <- c('Full-Time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:4) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp4$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, '(weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()



# calculate cluster statistics: medoid sequence, unweighted count, weighted percent
for (i in 1:4) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp4$clustering==medoids[i]), 
      round(weighted.mean(cmp4$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}



# 5 medoids
unique(cmp5$clustering)
medoids <- unique(cmp5$clustering)
medoids <- c(5, 781, 1074, 3259, 422)

# Figure 2
#jpeg(filename="../plots/medoids5.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5.pdf", width=55, height=30, pointsize=50)
par(mar=c(5, 20, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.2)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.2)
labels <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.5)
}
dev.off()


pdf("../plots/medoids5_v2.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
labels <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()


#dv[dv==422] <- 1 # FT
#dv[dv==3259] <- 2 # PT
#dv[dv==1074] <- 3 # early return
#dv[dv==781] <- 4 # late return
#dv[dv==5] <- 5 # nonemployed

# calculate cluster statistics: medoid sequence, unweighted count, weighted percent
for (i in 1:5) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp5$clustering==medoids[i]), 
      round(weighted.mean(cmp5$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}

# crosstab 4-medoid solution and 5-medoid solution
dv4 <- cmp4$clustering
medoids4 <- c(5, 781, 1074, 422)  
labels <- c('1Full-time', '3Early Return', '4Late Return', '5Nonemployed')
for (i in 1:4) {
  dv4[dv4==medoids4[i]] <- labels[5-i]
}
table(dv4)

dv5 <- cmp5$clustering
medoids5 <- c(5, 781, 1074, 3259, 422)
labels <- c('1Full-time', '2Part-time', '3Early Return', '4Late Return', '5Nonemployed')
for (i in 1:5) {
  dv5[dv5==medoids5[i]] <- labels[6-i]
}
table(dv5)

table(dv5, dv4)
write.csv(table(dv5, dv4), '../data/tmp.csv')


# 6 medoids
unique(cmp6$clustering)
medoids <- unique(cmp6$clustering)
medoids <- c(5, 781, 1074, 2299, 3259, 422)

# Figure S4
#jpeg(filename="../plots/medoids6.jpeg", width=1100, height=800, pointsize=16, quality=1000)
pdf("../plots/medoids6.pdf", width=60, height=40, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", yaxis=F,
         weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
labels <- c('Full-Time', 'Part-Time', 'Withdrawal', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:6) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp6$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()

# calculate cluster statistics: medoid sequence, unweighted count, weighted percent
for (i in 1:6) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp6$clustering==medoids[i]), 
      round(weighted.mean(cmp6$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}


######### turn clustering results into DV #########
######### compare with previous clustering results #########

#dv[dv==422] <- 1 # FT
#dv[dv==3259] <- 2 # PT
#dv[dv==1074] <- 3 # early return
#dv[dv==781] <- 4 # late return
#dv[dv==5] <- 5 # nonemployed

# replace medoids with simpler numbers
dv <- cmp5$clustering
medoids5 <- c(5, 781, 1074, 3259, 422)
for (i in 1:5) {
  dv[dv==medoids5[i]] <- 6-i
}
table(dv)



######### plot all sequences, sorted by silhouette (closeness to medoid) #########

# the default plot function is hard to modify title and ylab, so plot each cluster by myself
# seqIplot(emp.seq, group = pam4, sortv = sil, title="PAM", ylab=NA)

sil <- wcSilhouetteObs(diss, dv, weights = emp.data$any.wt, measure = "ASWw")

labels <- c("Full-Time", "Part-Time", "Early Return", "Late Return", "Nonemployed")

## remember: 
# 1: consistently full-time 
# 2: consistently part-time 
# 3: early returner 
# 4: late returner 
# 5: consistently nonemployed 

# Figure 3
jpeg(filename="../plots/indexplot_no_text.jpeg", width=800, height=960, pointsize=16, quality=2000)
#pdf("../plots/indexplot.pdf", width=40, height=40, pointsize=50)
par(mfrow=c(3,2))


# for copy-editing, remove texts
for (i in 1:5) {
  members <- which(dv==i)
  seqIplot(emp.seq[members,], sortv=sil[members], withlegend = F, border = NA, 
           axes=FALSE, yaxis=FALSE, xlab="", ylab="", font.lab=2,
           cex.lab=0.9, weighted=F) # weights don't matter much here
  axis(1, at=seq(0, 216, 12), labels=NA, cex.axis=1)
}
dev.off()



for (i in 1:5) {
  members <- which(dv==i)
  title <- paste(labels[i], " \n ", 
                 sum(dv==i), " sequences (weighted ", 
                 round(weighted.mean(dv==i, emp.data$any.wt)*100, 0), " %)", sep="")      
  seqIplot(emp.seq[members,], sortv=sil[members], withlegend = F, 
           title=title, border = NA, 
           axes=FALSE, yaxis=FALSE, xlab="Years Since Birth", ylab="", font.lab=2,
           cex.lab=0.9, weighted=F) # weights don't matter much here
  axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1)
}
dev.off()



##create each index plot in a separate file
for (i in 1:5) {
  #png(filename=paste("../plots/indexplot_", i, ".png", sep=""), width = 600, height = 480, res=100)
  pdf(paste("../plots/indexplot_", i, ".pdf", sep=""), width = 30, height = 24, pointsize=50)
  members <- which(dv==i)
  title <- paste(labels[i], " \n ", sum(dv==i), " sequences (weighted ", 
                 round(weighted.mean(dv==i, emp.data$any.wt)*100, 0),
                 " %)", sep="")      
  seqIplot(emp.seq[members,], sortv=sil[members], withlegend = F,  title=title, border = NA, 
           axes=FALSE, yaxis=FALSE, xlab="Years Since Birth", ylab="", weighted=F, 
           cex.lab=0.9, font.lab=2)
  axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1)
  dev.off()
}




## make bar plots of proportion of months in each status by cluster
# read data on number of months in each status, merge with cluster assignment
df <- read.csv('../data/iv_df.csv')
dv.df <- data.frame(caseid_1979=emp.data$caseid_1979, dv18=dv, wt=emp.data$any.wt)
df <- merge(df, dv.df, on='caseid_1979')
dim(df)
head(df)


df$num_ft

cols <- c("num_ft", "num_pt1", "num_pt2", "num_work_miss_hr", 
          "num_gaps",  "num_oolf", "num_unemp", "num_nonwork",  "num_miss")

# unweighted
aggregate(df[, cols], list(df$dv18), mean)/216 # means

# weighted
stats <- matrix(NA, ncol=9, nrow=5)
for (i in 1:5) {
  subdf <- df[df$dv18==i, ]
  row <- rep(NA, 9)
  for (j in 1:9) {
    row[j] <- weighted.mean(subdf[, cols[j]], subdf[, 'wt'])/216
  }
  stats[i, ] <- row
}

round(stats, 2)


#### make percentage table ####
stats.pct <- stats*100
stats.pct

stats.pct <- round(stats.pct, 1)
stats.pct

stats.pct <- t(stats.pct)
rownames(stats.pct) <- cols
colnames(stats.pct) <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')

stats.pct <- apply(stats.pct, 2, function(x) paste(x, "%", sep=""))
write.csv(stats.pct, '../data/tmp.csv')



#### Figure 4 ####
# transpose for plotting
stats <- t(stats)
round(stats, 2)
colnames(stats) <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')


#jpeg(filename="../plots/prop_states_wt.jpeg", width=400, height=500, pointsize=14, quality=1000)
pdf("../plots/prop_states_wt.pdf", width=20, height=25, pointsize=50)
par(mar=c(8, 4, 4, 2))
p <- barplot(stats, xlab="", ylab="Proportion (weighted)", col=c(nicer.colors, "grey"), axisnames=F, font.lab=2, las=1)
text(p, par("usr")[3], labels = labels, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=.9, font=2)
dev.off()



