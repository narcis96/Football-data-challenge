setwd("/Users/gemenenarcis/Documents/MATLAB/Football-data-challenge/R/")
library(gbm)
traincsv <- read.csv("../trainSet/train_R.csv",header = TRUE,sep=",")
train = traincsv[1:1520,]
test = traincsv[1521:nrow(traincsv),]
print(dim(train))
print(dim(test))

dates <- as.Date(traincsv$Date, "%Y-%m-%d")
years <- as.numeric(format(dates, "%Y"))
months <- format(dates, "%d")
SplitByYears <- function (years, months)
{
  uniqueYears <- sort.int(unique(years))
  for (i in 1:(length(uniqueYears) - 1))
  {
    year <- uniqueYears[i]
    if(year != 2015)
    {
      nextYear <- uniqueYears[i+1]
      indx <- as.numeric(format(dates, "%Y")) == year & as.numeric(format(dates, "%m")) >= 8
      indx <- indx | (as.numeric(format(dates, "%Y")) == nextYear & as.numeric(format(dates, "%m")) <= 6)
      indx <- which(indx == TRUE)
      
      if(length(indx) > 0)
      {
        rbind(indexes, indx)
      }
    }
  }
  return(indexes)
}


matches <- matrix(0, length(train$ID), 2);
winners <- matrix(0, length(train$ID), 1);

for (i in 1:length(train$ID))
{
  array <- unlist(train[i,], use.names = FALSE)
  array <- array[!is.na(array)]
  matches[i,] <- array[3:4]
  winners[i] <- array[5]
  if(winners[i] == 3)
    winners[i] <- 1
  else if(winners[i] == 1)
    winners[i] <- 3
}

rows = 1521:2130
trainIndx = !(1:nrow(traincsv) %in% rows)
testIndx = (1:nrow(traincsv) %in% rows)
train = traincsv[trainIndx, 3:4];#to train
test = traincsv[testIndx, 3:4];#to test

print(nrow(test))
print(nrow(train))

gbmWithCrossValidation = gbm(formula = traincsv$FTR[trainIndx] ~ .,
                             distribution = "multinomial",
                             data = train,
                             n.trees = 2000,
                             shrinkage = .1,
                             n.minobsinnode = 200, 
                             cv.folds = 5,
                             n.cores = 1)
bestTreeForPrediction = gbm.perf(gbmWithCrossValidation)

gbmTestPredictions = predict(object = gbmWithCrossValidation,
                                newdata = test,
                                n.trees = bestTreeForPrediction,
                                type = "response")

print(gbmTestPredictions)
for (i in 1:nrow(gbmTestPredictions))
{
  val = as.numeric(which.max(gbmTestPredictions[i, , ]));
  if(val == 1)
    ch = 'A'
  else if(val == 2)
    ch = 'D'
  else
    ch = 'H'
  MyData <- data.frame(ID = i, FTR = ch)
  if(i > 1)
    output <- rbind(output, MyData)
  else
    output <- MyData
}
write.csv(output, file = "submission.csv",row.names=FALSE)