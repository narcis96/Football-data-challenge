function [performance,thresholds ] = ChoseBestThresholds(net, testVectors, testLabels)
    
    thresholds = zeros(1,3);
    testIndx = vec2ind(testLabels);
    
    best = 1;
    for i=1:500
        currentThresholds = sort(rand(1,3),'descend');
        output = sim(net,testVectors);
        result = GetAnswer(output, currentThresholds(1), currentThresholds(2), currentThresholds(3));
        differences = numel(find(abs(result-testIndx)));
        performance = differences/size(testLabels,2);
        if performance < best
            best = performance;
            thresholds = currentThresholds;
        end
    end
end

