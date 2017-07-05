setwd("/Users/gemenenarcis/Documents/MATLAB/Football-data-challenge/");
library(gbm);
train = read.csv("./trainSet/train.csv",header = TRUE,sep=",");
test = read.csv("./testSet/test.csv",header = TRUE,sep=",");
dates <- as.Date(train$Date, "%Y-%m-%d");
years <- as.numeric(format(dates, "%Y"));
months = format(dates, "%d");
uniqueYears = sort.int(unique(years));
for (i in 1:(length(uniqueYears) - 1))
{
  year = uniqueYears[i];
  nextYear = uniqueYears[i+1];
  indx = as.numeric(format(dates, "%Y")) == year & as.numeric(format(dates, "%m") >= 8);
  indx = indx | (as.numeric(format(dates, "%Y")) == nextYear & as.numeric(format(dates, "%m") <= 6));
  indx = which(indx == TRUE)
  print(length(indx));
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

#"%y-%d-%d"
#for(i in 1:length(train$HomeTeam))
#{
  #array = unlist(train[i,], use.names = FALSE);
  #array = array[!is.na(array)];
  #print(array);
#}
