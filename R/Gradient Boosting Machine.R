setwd("/Users/gemenenarcis/Documents/MATLAB/Football-data-challenge/")
library(gbm)
traincsv <- read.csv(“../trainSet/train.csv",header = TRUE,sep=",")
testcsv <- read.csv(“../testSet/test.csv",header = TRUE,sep=",")
dates <- as.Date(traincsv$Date, "%Y-%m-%d")
years <- as.numeric(format(dates, "%Y"))
months <- format(dates, "%d")
uniqueYears <- sort.int(unique(years))
indexes <- matrix(0,2,length(uniqueYears) - 1)
for (i in 1:(length(uniqueYears) - 1))
{
  year <- uniqueYears[i]
  nextYear <- uniqueYears[i+1]
  indx <- as.numeric(format(dates, "%Y")) == year & as.numeric(format(dates, "%m") >= 8)
  indx <- indx | (as.numeric(format(dates, "%Y")) == nextYear & as.numeric(format(dates, "%m") <= 6))
  indx <- which(indx == TRUE)
  
  #attention!!the dates in train have to be sorted
  indexes[1,i] <- min(indx);
  indexes[2,i] <- max(indx);
  
  print(length(indx))
  print(indexes[2,i] - indexes[1,i] + 1)
}
matches <- matrix(0, length(traincsv$ID), 2);
winners <- matrix(0, length(traincsv$ID), 1);

for (i in 1:length(traincsv$ID))
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
#data.frame("Actual" = train$HomeTeam, 
 #          "PredictedProbability" = train$AwayTeam)

LogLossBinary = function(actual, predicted, eps = 1e-15) {  
  predicted = pmin(pmax(predicted, eps), 1-eps)  
  - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
}

for (i in 1:1)#ncol(indexes))
{
  dataSubsetProportion = .2;
  rows = indexes[1,i]:indexes[2,i]
  trainingNonHoldoutSet = train[!(1:nrow(train) %in% rows), 3:4];#to train
  print(nrow(trainingHoldoutSet))
  print(nrow(trainingNonHoldoutSet))
  
    
  gbmWithCrossValidation = gbm(formula = train$FTR[!(1:nrow(train) %in% rows)] ~ .,
                               distribution = "multinomial",
                               data = trainingNonHoldoutSet,
                               n.trees = 2000,
                               shrinkage = .1,
                               n.minobsinnode = 200, 
                               cv.folds = 5,
                               n.cores = 1)
  bestTreeForPrediction = gbm.perf(gbmWithCrossValidation)
  
  gbmHoldoutPredictions = predict(object = gbmWithCrossValidation,
                                  newdata = trainingHoldoutSet,
                                  n.trees = bestTreeForPrediction,
                                  type = "response")
  
  gbmNonHoldoutPredictions = predict(object = gbmWithCrossValidation,
                                     newdata = trainingNonHoldoutSet,
                                     n.trees = bestTreeForPrediction,
                                     type = "response")
  print(paste(LogLossBinary(train$Response[randomRows], gbmHoldoutPredictions), 
              "Holdout Log Loss"))
  print(paste(LogLossBinary(train$Response[!(1:nrow(train) %in% randomRows)], gbmNonHoldoutPredictions), 
              "Non-Holdout Log Loss"))
}


#dataSubsetProportion = .2;
#randomRows = sample(1:nrow(train), floor(nrow(train) * dataSubsetProportion));#
#trainingHoldoutSet = train[randomRows, ];#to test
#trainingNonHoldoutSet = train[!(1:nrow(train) %in% randomRows), ];#to train

#gbmWithCrossValidation = gbm(formula = Response ~ .,
#                             distribution = "bernoulli",
#                             data = trainingNonHoldoutSet,
#                             n.trees = 2000,
#                             shrinkage = .1,
#                             n.minobsinnode = 200, 
#                             cv.folds = 5,
#                             n.cores = 1)

#best  TreeForPrediction = gbm.perf(gbmWithCrossValidation)
#"%y-%d-%d"
#for(i in 1:length(train$HomeTeam))
#{
  #array = unlist(train[i,], use.names = FALSE);
  #array = array[!is.na(array)];
  #print(array);
#}
