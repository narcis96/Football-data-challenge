function [performace, thresholds] = KFoldCrossValidation(trainVectors, trainLabels, hiddenLayers,indexes, func, trainfcs)
    performaces = [];
    best = 1;
    thresholds = zeros(1,3);
    sz = size(trainVectors);
    total = sz(end);


    for column = indexes
        
        ind = zeros(1,total);
        ind(column(1):column(2)) = 1;
       
        testIndx = find(ind)';
        trainIndx = find(~ind)';
        
        currentTrainVectors = trainVectors(:,trainIndx);
        currentTestVectors = trainVectors(:,testIndx);
        
        currentTrainLabels = trainLabels(:,trainIndx); 
        currentTestLabels = trainLabels(:,testIndx);
        
        disp(sprintf('train size = %d ',size(currentTrainVectors,2)));
        disp(sprintf('test size = %d ',size(currentTestLabels,2)));
        perf = 1;
        while perf > 0.2
            [currentNet, perf] = Train(currentTrainVectors, currentTrainLabels, hiddenLayers, func, trainfcs);  
        end
        [currentPerformance,currentThresholds] = ChoseBestThresholds(currentNet, currentTestVectors, currentTestLabels);
        %currentPerformance = mean(mean(abs(currentTestLabels-result)));
        if currentPerformance < best
            best = currentPerformance;
            thresholds = currentThresholds;
        end
        performaces = [performaces currentPerformance];
       
    end
    
    performace = mean(performaces);
    
end