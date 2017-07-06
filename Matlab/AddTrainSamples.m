if distrurbSamples == true
    minValue = min(min(trainData));
    maxValue = max(max(trainData));
    [newTrainVectors, newTrainLabels] = DistrurbRandomSamples(trainData, trainLabels, percentage, sigma, minValue, maxValue);
    trainData = [trainData newTrainVectors];
    trainLabels = [trainLabels newTrainLabels];
    disp(size(trainData));      
end