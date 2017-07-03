setwd("/Users/gemenenarcis/Documents/MATLAB/Football-data-challenge/")
#train = read.csv("./trainSet/train.csv",header = TRUE,sep=",")
test = read.csv("./testSet/test.csv",header = TRUE,sep=",")
for(i in 1:length(test$HomeTeam))
{
    values = numeric(3)
    for(j in 1:3)
    {
      array = unlist(test[i,seq(from = 4 + j, to = length(test[i,]), by=3)], use.names = FALSE);
      values[j] = mean(array[!is.na(array)])
    }
    index = which.min(values);
#    MyData <- data.frame(ID = i, FTR = index, Odd = min(values))
    MyData <- data.frame(index, min(values))
    if(i > 1)
      total <- rbind(total, MyData)
    else
      total = MyData
}
write.csv(total, file = "AverageOdds.csv",row.names=FALSE)
