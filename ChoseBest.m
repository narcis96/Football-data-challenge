function [arhitecture, perf, thresholds] = ChoseBest(trainVectors, trainLabels, arhitectures, minP, maxP, minLayers, maxLayers, indexes)
    assert(minP < maxP);
    assert(minLayers < maxLayers);
    
    arhitecture = [];
    perf = 1;
    thresholds = zeros(1,3);
    for i = 1:arhitectures
         hiddenLayers = sort(minP + randi((maxP-minP), 1, minLayers + randi(maxLayers-minLayers)),'descend');
         disp(hiddenLayers);        

         [performance, currentThresholds] = KFoldCrossValidation(trainVectors, trainLabels, hiddenLayers,indexes);
         disp(performance);

         if performance < perf
            perf = performance;
            arhitecture = hiddenLayers;
            thresholds = currentThresholds;
         end
         
    end

end