LogLossBinary = function(actual, predicted, eps = 1e-15) {  
  predicted = pmin(pmax(predicted, eps), 1-eps)  
  - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
}

for (i in 1:nrow(indexes))
{
  dataSubsetProportion = .2;
  rows = indexes[i,]
  trainingNonHoldoutSet = traincsv[!(1:nrow(traincsv) %in% rows), 3:4];#to train
  trainingHoldoutSet = traincsv[(1:nrow(traincsv) %in% rows), 3:4];#to test
  
  print(nrow(trainingHoldoutSet))
  print(nrow(trainingNonHoldoutSet))
  
  gbmWithCrossValidation = gbm(formula = traincsv$FTR[!(1:nrow(traincsv) %in% rows)] ~ .,
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
  print(paste(LogLossBinary(winners[rows], gbmHoldoutPredictions), 
              "Holdout Log Loss"))
  print(paste(LogLossBinary(winners[!(1:nrow(traincsv) %in% rows)], gbmNonHoldoutPredictions), 
              "Non-Holdout Log Loss"))
  print(head(data.frame("Actual" = winners[rows], 
                        "PredictedProbability" = gbmHoldoutPredictions)))
}