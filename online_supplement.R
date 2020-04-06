# setup
library(TraMineR)
library(cluster)
library(WeightedCluster)
library(plyr)
library(Hmisc)
library(SDMTools)
library(weights)
library(aod)


##########################################################
### define weighted sequences 
##########################################################

# define employment seq with maternal leave
emp.data <- read.csv("../data/monthly_df.csv", header=TRUE)
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
# 8 - maternity leave

emp.labels <- c("Full-time employed", 
                "Part-time employed",
                "Marginally employed",
                "Employed with missing hours",
                "Unemployed",
                "Out of labor force",
                "Nonworking (unemployed or OOLF)", 
                "Within-job gaps")

emp.scode <- seq(1, 8)

# set color scheme 
colors <- c("#DEEBF7", "#9ECAE1", "#4292C6", "#084594", "#EF6548", "#FDBB84", "#990000", "#FDD49E")


# create TraMineR sequence object, use any.weight for analysis
# seq starts from 16th column because we included one year prebirth
emp.seq <- seqdef(emp.data[, 16:231], weights=emp.data$any.wt, states = emp.scode, 
                  labels = emp.labels, right=NA, cpal=colors)


##################################################################
### produce clustering results of 14-year sample
##################################################################

# 14-year sequences
emp.data14 <- read.csv("../data/monthly_df_seq14.csv", header=TRUE)
dim(emp.data14)

# replace 0 with NA - first 3 columns are "caseid_1979" "start_y" "start_m"
emp.data14[, 4:171][emp.data14[, 4:171]==0] <- NA

# merge weights into emp.data
emp.data14 <- merge(emp.data14, all.wt, by='caseid_1979')
emp.data14 <- merge(emp.data14, any.wt, by='caseid_1979')
head(emp.data14)

emp.seq14 <- seqdef(emp.data14[, 4:171], weights=emp.data14$any.wt, states=emp.scode, 
                    labels=emp.labels, right=NA, cpal=colors)


# 18-year sequences, right-censored months assigned to missing
emp.data14_18 <- read.csv("../data/monthly_df_seq14_18.csv", header=TRUE)
dim(emp.data14_18)

# replace 0 with NA - first 3 columns are "caseid_1979" "start_y" "start_m"
emp.data14_18[, 4:219][emp.data14_18[, 4:219]==0] <- NA

# merge weights into emp.data
emp.data14_18 <- merge(emp.data14_18, all.wt, by='caseid_1979')
emp.data14_18 <- merge(emp.data14_18, any.wt, by='caseid_1979')
head(emp.data14_18)

emp.seq14_18 <- seqdef(emp.data14_18[, 4:219], weights=emp.data14_18$any.wt, states=emp.scode, 
                       labels=emp.labels, right=NA, cpal=colors)



# Theoretical substitution cost matrix

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
ccost



## Compute distance using Hamming distance
diss <- seqdist(emp.seq, method="HAM", sm=ccost, with.missing=TRUE)
diss14 <- seqdist(emp.seq14, method="HAM", sm=ccost, with.missing=TRUE)
diss14_18 <- seqdist(emp.seq14_18, method="HAM", sm=ccost, with.missing=TRUE)


######### plot medoids #########
set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5 <- wcKMedoids(diss, k=5, weights = emp.data$any.wt, npass=5)

set.seed(1) # to reproduce the exact same cluster assignment each time
cmp5.seq14 <- wcKMedoids(diss14, k=5, weights = emp.data14$any.wt, npass=5)

set.seed(1) # to reproduce the exact same cluster assignment each time
cmp5.seq14_18 <- wcKMedoids(diss14_18, k=5, weights = emp.data14_18$any.wt, npass=5)



# plot 5 medoids of 14-year sample
unique(cmp5.seq14$clustering)
medoids14 <- unique(cmp5.seq14$clustering)
medoids14 <- c(6, 3629, 2603, 806, 18)

###### Figure S6(a) ######
#jpeg(filename="../plots/medoids5_seq14.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5_seq14.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq14[medoids14,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", yaxis=F, 
         weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 168, 12), labels=0:14, cex.axis=1.5)
labels <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.seq14$clustering==medoids14[i], emp.data14$any.wt)*100, 0)
  t <- paste(name, '(weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()


###### Figure S6(b) ######
unique(cmp5.seq14_18$clustering)
medoids14_18 <- c(6, 835, 1148, 3467, 452)

#jpeg(filename="../plots/medoids5_seq14_18.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5_seq14_18.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq14_18[medoids14_18,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
labels <- c('Full-Time', 'Part-Time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.seq14_18$clustering==medoids14_18[i], emp.data14_18$any.wt)*100, 0)
  t <- paste(name, '(weighted ', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()


######### descriptives of cluster solutions #########
# calculate cluster statistics: medoid sequence, unweighted count, weighted percent
for (i in 1:5) {
  print(medoids14[i])
  print(emp.seq14[medoids14[i], ], format = "SPS")
  cat(sum(cmp5.seq14$clustering==medoids14[i]), 
      round(weighted.mean(cmp5.seq14$clustering==medoids14[i], emp.data14$any.wt)*100, 0),
      '%',
      '\n')
}


# calculate cluster statistics: medoid sequence, unweighted count, weighted percent
for (i in 1:5) {
  print(medoids14_18[i])
  print(emp.seq14_18[medoids14_18[i], ], format = "SPS")
  cat(sum(cmp5.seq14_18$clustering==medoids14_18[i]), 
      round(weighted.mean(cmp5.seq14_18$clustering==medoids14_18[i], emp.data14_18$any.wt)*100, 0),
      '%',
      '\n')
}


########   membership crosstab   ########

unique(cmp5$clustering)
medoids5 <- c(5, 781, 1074, 3259, 422)
for (i in 1:5) {
  print(medoids5[i])
  print(emp.seq[medoids5[i], ], format = "SPS")
  print("------")
}


# replace medoids with simpler numbers
dv <- cmp5$clustering
for (i in 1:5) {
  dv[dv==medoids5[i]] <- 6-i
}
table(dv)


dv14 <- cmp5.seq14$clustering
for (i in 1:5) {
  dv14[dv14==medoids14[i]] <- 6-i
}
table(dv14)


dv14_18 <- cmp5.seq14_18$clustering
for (i in 1:5) {
  dv14_18[dv14_18==medoids14_18[i]] <- 6-i
}
table(dv14_18)


outcome18 <- data.frame(caseid_1979=emp.data$caseid_1979, dv18=dv)
head(outcome18)

outcome14 <- data.frame(caseid_1979=emp.data14$caseid_1979, dv14=dv14, wt=emp.data14$any.wt, allwt=emp.data14$all.wt)
head(outcome14)
dim(outcome18); dim(outcome14)


# merge
outcome.common <- merge(outcome18, outcome14, by='caseid_1979', how='right')
head(outcome.common)
dim(outcome.common)

###### TABLE S17(a) in online supplement - crosstab ######
table(outcome.common$dv14, outcome.common$dv18) 
round(weighted.mean(outcome.common$dv18==1&outcome.common$dv14==3 | 
                      outcome.common$dv18==3&outcome.common$dv14==4 |
                      outcome.common$dv18==4&outcome.common$dv14==5, outcome.common$wt), 2)

#differently caterogized
sum(outcome.common$dv14!=outcome.common$dv18)
round(weighted.mean(outcome.common$dv14!=outcome.common$dv18, outcome.common$wt), 2)


# column sums
table(outcome.common$dv18)
for (c in 1:5) {
  cat(c, round(weighted.mean(outcome.common$dv18==c, outcome.common$wt), 2)*100, '\n')
}

# row sums
table(outcome14$dv14)
for (c in 1:5) {
  cat(c, round(weighted.mean(outcome14$dv14==c, outcome14$wt), 2)*100, '\n')
}

# 14-year only respondents
remainder14 <- outcome14[!(outcome14$caseid_1979 %in% outcome18$caseid_1979), ]
table(remainder14$dv14)



# export all cases together
outcome <- merge(outcome14, outcome18, by='caseid_1979', all=T)
head(outcome)
dim(outcome)
write.csv(outcome, file='../data/dv_df.csv', row.names=FALSE)



### for 18-year-seq version of clusters ###
outcome14_18 <- data.frame(caseid_1979=emp.data14_18$caseid_1979, dv14_18=dv14_18, 
                           wt=emp.data14_18$any.wt, allwt=emp.data14_18$all.wt)
head(outcome14_18)


# merge
outcome.common <- merge(outcome18, outcome14_18, by='caseid_1979', how='right')
head(outcome.common)
dim(outcome.common)


###### TABLE S17(b) in online supplement, crosstab ######
table(outcome.common$dv14_18, outcome.common$dv18) 

#differently categorized
sum(outcome.common$dv14_18!=outcome.common$dv18)
round(weighted.mean(outcome.common$dv14_18!=outcome.common$dv18, outcome.common$wt), 3)


# column sums
table(outcome.common$dv18)
for (c in 1:5) {
  cat(c, round(weighted.mean(outcome.common$dv18==c, outcome.common$wt), 2)*100, '\n')
}

# row sums
table(outcome14_18$dv14_18)
for (c in 1:5) {
  cat(c, round(weighted.mean(outcome14_18$dv14_18==c, outcome14_18$wt), 2)*100, '\n')
}

# 14-year only respondents
remainder14_18 <- outcome14_18[!(outcome14_18$caseid_1979 %in% outcome18$caseid_1979), ]
table(remainder14_18$dv14_18)



########################################################################
### Alternative substitution cost matrices 
########################################################################

## constant substitution cost matrix
ccost.const <- seqsubm(emp.seq, method = "CONSTANT", with.missing=TRUE, cval=1)
ccost.const 
emp.const.ham <- seqdist(emp.seq, method = "HAM", sm=ccost.const, with.missing=TRUE)


### transition rate substitution matrix - Table S7(a) ###
## transition rate substitution cost matrix
ccost.trate <- seqsubm(emp.seq, method = "TRATE", with.missing=TRUE, missing.trate=TRUE)
round(ccost.trate,2) # default missing cost = 2

# what is the smallest positive cost?
min(ccost.trate[ccost.trate>0])

mincost <- min(ccost.trate[ccost.trate>0])
ccost.trate <- ccost.trate/mincost
round(ccost.trate,3) # default missing cost = 2
write.csv(ccost.trate, '../data/ccost_trate_default.csv')


emp.trate.ham <- seqdist(emp.seq, method = "HAM", sm = ccost.trate, with.missing=TRUE)


### NEW: alterantive transition rate substitution matrix - Table S7(b) ###

# first, explore maximum sum of transition rates among all pairs of statuses
trate <- seqtrate(emp.seq, with.missing=T, weight=T) # include missing state, use weights
round(trate, 4)

# calculate sum (P(state 1 to state 2) + P(state 2 to state 1))
tmp <- matrix(NA, nrow=9, ncol=9)
diag(tmp) <- 0
tmp
combo <- combn(1:9, 2)
for (i in 1:ncol(combo)) {
  val <- (trate[combo[1, i], combo[2, i]] + trate[combo[2, i], combo[1, i]])
  tmp[combo[1, i], combo[2, i]] <- val
  tmp[combo[2, i], combo[1, i]] <- val
}
round(tmp, 4)

# the max sum is
max(tmp)


ccost.trate2 <- seqsubm(emp.seq, method = "TRATE", with.missing=TRUE, cval=0.3, missing.trate=TRUE)
round(ccost.trate2, 2) # default missing cost = 2

mincost <- min(ccost.trate2[ccost.trate2>0])
ccost.trate2 <- ccost.trate2/mincost
round(ccost.trate2, 3)
write.csv(ccost.trate2, '../data/ccost_trate_new.csv')

emp.trate.ham2 <- seqdist(emp.seq, method = "HAM", sm = ccost.trate2, with.missing=TRUE)
emp.trate.ham2[1:10, 1:10]


## plot medoids

# constant
set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5.const <- wcKMedoids(emp.const.ham, k=5, weights = emp.data$any.wt, npass=5)

unique(cmp5.const$clustering)
medoids <- unique(cmp5.const$clustering)
medoids <- c(3406, 656, 327, 3259, 3437)

###### Figure S1(a) ######
#jpeg(filename="../plots/medoids5_const.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5_const.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.const$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, '(weighted', pct, '%)', sep=' ')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()

for (i in 1:5) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp5.const$clustering==medoids[i]), 
      round(weighted.mean(cmp5.const$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}



# default transition rate
set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5.trate <- wcKMedoids(emp.trate.ham, k=5, weights = emp.data$any.wt, npass=5)

unique(cmp5.trate$clustering)
medoids <- unique(cmp5.trate$clustering)
medoids <- c(5, 656, 327, 3259, 31)

###### Figure S1(b) ######
#jpeg(filename="../plots/medoids5_trate.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5_trate.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.trate$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted ', pct, '%)', sep='')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()

for (i in 1:5) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp5.trate$clustering==medoids[i]), 
      round(weighted.mean(cmp5.trate$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}



###### use new trate ######
set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5.trate2 <- wcKMedoids(emp.trate.ham2, k=5, weights = emp.data$any.wt, npass=5)

unique(cmp5.trate2$clustering)
medoids <- unique(cmp5.trate2$clustering)
medoids <- c(3406, 656, 327, 3259, 3437)

###### Figure S1(c) ######
#jpeg(filename="../plots/medoids5_trate2.jpeg", width=1100, height=600, pointsize=16, quality=1000)
pdf("../plots/medoids5_trate2.pdf", width=60, height=30, pointsize=50)
par(mar=c(5, 23, 2, 2))
seqiplot(emp.seq[medoids,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years Since Birth", ylab="", 
         yaxis=F, weighted=F, font.lab=2, cex.lab=1.5)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1.5)
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.trate2$clustering==medoids[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted ', pct, '%)', sep='')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.8)
}
dev.off()


for (i in 1:5) {
  print(medoids[i])
  print(emp.seq[medoids[i], ], format = "SPS")
  cat(sum(cmp5.trate2$clustering==medoids[i]), 
      round(weighted.mean(cmp5.trate2$clustering==medoids[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}



### recode and crosstab cluster membership ###

getWtMeans <- function(dv, wt) {
  for (i in 1:5) {
    print(round(weighted.mean(dv==i, wt)*100, 0))
  }
}

# cum-derived (main result)
dv <- cmp5$clustering
unique(dv)
medoids <- c(5, 781, 1074, 3259, 422)
for (i in 1:5) {
  dv[dv==medoids[i]] <- 6-i
}
table(dv)
getWtMeans(dv, emp.data$any.wt)

# constant
unique(cmp5.const$clustering)
dv.const <- cmp5.const$clustering
medoids <- c(3406, 656, 327, 3259, 3437)
for (i in 1:5) {
  dv.const[dv.const==medoids[i]] <- 6-i
}
table(dv.const)
getWtMeans(dv.const, emp.data$any.wt)

# default transition rate
unique(cmp5.trate$clustering)
dv.trate <- cmp5.trate$clustering
medoids <- c(5, 656, 327, 3259, 31)
for (i in 1:5) {
  dv.trate[dv.trate==medoids[i]] <- 6-i
}
table(dv.trate)
getWtMeans(dv.trate, emp.data$any.wt)

# customized transition rate
unique(cmp5.trate2$clustering)
dv.trate2 <- cmp5.trate2$clustering
medoids <- c(3406, 656, 327, 3259, 3437)
for (i in 1:5) {
  dv.trate2[dv.trate2==medoids[i]] <- 6-i
}
table(dv.trate2)
getWtMeans(dv.trate2, emp.data$any.wt)


# crosstab

###### Table S8(a) ######
table(dv, dv.const) 
write.csv(table(dv, dv.const), '../data/tmp.csv')

#differently caterogized for const
sum(dv!=dv.const)
round(weighted.mean(dv!=dv.const, emp.data$any.wt), 2)


###### Table S8(b) ######
table(dv, dv.trate) 
write.csv(table(dv, dv.trate), '../data/tmp.csv')

#differently caterogized for trate
sum(dv!=dv.trate)
round(weighted.mean(dv!=dv.trate, emp.data$any.wt), 2)


###### Table S8(c) ######
table(dv, dv.trate2) 
write.csv(table(dv, dv.trate2), '../data/tmp.csv')

#differently caterogized for trate2
sum(dv!=dv.trate2)
round(weighted.mean(dv!=dv.trate2, emp.data$any.wt), 2)


################################################################
##########     alternatve cost for within-job gaps    ##########
################################################################

# Make within-job gaps more similar to employed statuses

ccost2 <- ccost

ccost2[8, 1] <- 2
ccost2[8, 2] <- 2
ccost2[8, 3] <- 2
ccost2[8, 4] <- 2
ccost2[8, 5] <- 6
ccost2[8, 6] <- 7
ccost2[8, 7] <- 6.5

ccost2[1, 8] <- 2
ccost2[2, 8] <- 2
ccost2[3, 8] <- 2
ccost2[4, 8] <- 2
ccost2[5, 8] <- 6
ccost2[6, 8] <- 7
ccost2[7, 8] <- 6.5

ccost2



## compute distance using Hamming distance
diss <- seqdist(emp.seq, method="HAM", sm=ccost, with.missing=TRUE)
diss2 <- seqdist(emp.seq, method="HAM", sm=ccost2, with.missing=TRUE)



######### weighted clustering analysis #########
set.seed(10) # to reproduce the exact same cluster assignment each time
cmp5 <- wcKMedoids(diss, k=5, weights = emp.data$any.wt, npass=5)

# version 2
set.seed(10)
cmp5.2 <- wcKMedoids(diss2, k=5, weights = emp.data$any.wt, npass=5)



# 5 medoids
unique(cmp5.2$clustering)
medoids2 <- c(5, 781, 1074, 3259, 3425)
seqiplot(emp.seq[medoids2,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Year since birth", ylab="", yaxis=F, weighted=F)


for (i in 1:5) {
  print(medoids2[i])
  print(emp.seq[medoids2[i], ], format = "SPS")
  cat(sum(cmp5.2$clustering==medoids2[i]), 
      round(weighted.mean(cmp5.2$clustering==medoids2[i], emp.data$any.wt)*100, 0),
      '%',
      '\n')
}


# crosstab 2 cost matrices
dv <- cmp5$clustering
unique(dv)
medoids <- c(5, 781, 1074, 3259, 422)
for (i in 1:5) {
  dv[dv==medoids[i]] <- 6-i
}
table(dv)

dv2 <- cmp5.2$clustering
unique(dv2)
medoids2 <- c(5, 781, 1074, 3259, 3425)
for (i in 1:5) {
  dv2[dv2==medoids2[i]] <- 6-i
}
table(dv2)

table(dv, dv2)

sum(dv!=dv2)
round(weighted.mean(dv!=dv2, emp.data$any.wt), 2)




###### plot - Response Letter Figure 1 ######
unique(cmp5.2$clustering)
medoids2 <- unique(cmp5.2$clustering)
medoids2 <- c(5, 781, 1074, 3259, 3425)

# plot medoids
png('../plots/medoids5_v2.png', width=1100, height=600, pointsize = 16, res=80)
par(mar=c(5, 20, 2, 2))
seqiplot(emp.seq[medoids2,], withlegend = F, title = NA, 
         border = NA, axes=FALSE, xlab="Years since birth", ylab="", yaxis=F, weighted=F)
axis(1, at=seq(0, 216, 12), labels=0:18, cex.axis=1)
labels <- c('Full-time', 'Part-time', 'Early Return', 'Late Return', 'Nonemployed')
for (i in 1:5) {
  name <- labels[length(labels)+1-i]
  pct <- round(weighted.mean(cmp5.2$clustering==medoids2[i], emp.data$any.wt)*100, 0)
  t <- paste(name, ' (weighted ', pct, '%)', sep='')
  mtext(t, side=2, at=0.7+(i-1)*1.2, las=1, line=0.5, cex=1.5)
}
dev.off()



#######################################################################
##### compare age 20-40 sequences for mothers and childless women #####
#######################################################################

###### Figure S5(a) for mothers ######

# read employment seq
emp.data <- read.csv("../data/age_seq_mothers.csv", header=TRUE)
names(emp.data)[1:10]
ncol(emp.data)
dim(emp.data)

# read weights (2 kinds)
all.wt <- read.table('../data/customweight_nlsy79_all.txt')
all.wt <- rename(all.wt, c("V1"="caseid_1979", "V2"="all.wt"))

any.wt <- read.table('../data/customweight_nlsy79_any or all.txt')
any.wt <- rename(any.wt, c("V1"="caseid_1979", "V2"="any.wt"))

# merge weights into emp.data
emp.data <- merge(emp.data, all.wt, by='caseid_1979')
emp.data <- merge(emp.data, any.wt, by='caseid_1979')
head(emp.data)

# calculate proportions
weighted.mean(emp.data['month1']==1, emp.data$any.wt)
pct <- c()
for (i in 1:240) {
  pct <- c(pct, weighted.mean(emp.data[paste('month', i, sep='')]==1, emp.data$any.wt))
  print(paste(round(20+i/12, 1), 
              round(weighted.mean(emp.data[paste('month', i, sep='')]==1, emp.data$any.wt), 2)))
}
max(pct)
                   
# replace 0 with NA - first 3 columns are "caseid_1979" "start_y"     "start_m"
emp.data[, 4:243][emp.data[, 4:243]==0] <- NA



# make nicer plots
ncol(emp.data) # 245
emp.seq.nicer <- emp.data[, 4:243] # last two columns are newly added weights


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

# create new sequence object for plotting purpose
nicer.colors <- c("#DEEBF7", "#9ECAE1", "#4292C6", "#084594", 
                  "#FDD49E", "#FDBB84", "#EF6548", "#990000") 
emp.seq.color <- seqdef(emp.seq.nicer, weights=emp.data$any.wt, states=nicer.scode, labels=nicer.labels, 
                        right=NA, cpal=nicer.colors)


# double check legend
seqlegend(emp.seq.color, fontsize = 1.3, box.col="white")

# create state distribution plot for mothers - Figure S5(a)
#jpeg('../plots/state_distribution_mothers.jpeg', width = 800, height = 640, pointsize = 16, quality=800)
pdf('../plots/state_distribution_mothers.pdf', width=50, height=32, pointsize=50)
par(mar=c(6, 6, 2, 2), mgp = c(4, 1, 0))
seqdplot(emp.seq.color, withlegend = F, border = NA, title=NULL, axes=FALSE,
         with.missing=T, ### change!
         xlab="Age", ylab="Proportion (weighted)", las=2, weighted=T, 
         font.lab=2, yaxis=F, cex.lab=1.5)
axis(1, at=seq(0, 240, 12), labels=20:40, cex.axis=1.5)
axis(2, at=seq(0, 1, 0.2), labels=format(seq(0, 1, 0.2), nsmall=2), cex.axis=1.5, las=2)
dev.off()



###### Figure S5(b) for childless women ######

# read employment seq
emp.data <- read.csv("../data/age_seq_childless.csv", header=TRUE)
names(emp.data)[1:10]
ncol(emp.data)
dim(emp.data)


# read weights (2 kinds)
all.wt <- read.table('../data/customweight_nlsy79_all.txt')
all.wt <- rename(all.wt, c("V1"="caseid_1979", "V2"="all.wt"))

any.wt <- read.table('../data/customweight_nlsy79_any or all.txt')
any.wt <- rename(any.wt, c("V1"="caseid_1979", "V2"="any.wt"))

# merge weights into emp.data
emp.data <- merge(emp.data, all.wt, by='caseid_1979')
emp.data <- merge(emp.data, any.wt, by='caseid_1979')
head(emp.data)


# calculate proportions
weighted.mean(emp.data['month1']==1, emp.data$any.wt)
pct <- c()
for (i in 1:240) {
  pct <- c(pct, weighted.mean(emp.data[paste('month', i, sep='')]==1, emp.data$any.wt))
  print(paste(round(20+i/12, 1), 
              round(weighted.mean(emp.data[paste('month', i, sep='')]==1, emp.data$any.wt), 2)))
}
max(pct)


# replace 0 with NA - first 3 columns are "caseid_1979" "start_y"     "start_m"
emp.data[, 4:243][emp.data[, 4:243]==0] <- NA



# make nicer plots

ncol(emp.data) # 245
emp.seq.nicer <- emp.data[, 4:243] # last two columns are newly added weights


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

# create new sequence object for plotting purpose
nicer.colors <- c("#DEEBF7", "#9ECAE1", "#4292C6", "#084594", 
                  "#FDD49E", "#FDBB84", "#EF6548", "#990000") 
emp.seq.color <- seqdef(emp.seq.nicer, weights=emp.data$any.wt, states=nicer.scode, labels=nicer.labels, 
                        right=NA, cpal=nicer.colors)


# double check legend
seqlegend(emp.seq.color, fontsize = 1.3, box.col="white")

# create state distribution plot for childless women, separately - Figure S5(b)
#jpeg('../plots/state_distribution_childless.jpeg', width = 800, height = 640, pointsize = 16, quality=800)
pdf('../plots/state_distribution_childless.pdf', width=50, height=32, pointsize=50)
par(mar=c(6, 6, 2, 2), mgp = c(4, 1, 0))
seqdplot(emp.seq.color, withlegend = F, border = NA, title=NULL, axes=FALSE,
         with.missing=T, ### change!
         xlab="Age", ylab="Proportion (weighted)", las=2, weighted=T, font.lab=2, 
         yaxis=F, cex.lab=1.5)
axis(1, at=seq(0, 240, 12), labels=20:40, cex.axis=1.5)
axis(2, at=seq(0, 1, 0.2), labels=format(seq(0, 1, 0.2), nsmall=2), cex.axis=1.5, las=2)
dev.off()






