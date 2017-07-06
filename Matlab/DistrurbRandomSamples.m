function [newLabels ,newTargets] = DistrurbRandomSamples(labels, targets, percentage, sigma, minValue, maxValue)
    assert(0 < percentage && percentage <= 1);
    labelsSize = size(labels);
    total = labelsSize(end);
    count = floor(total*percentage);
    
    perm = randperm(total);
    perm = perm(1:count);
    
    newLabels = labels(:,perm(1:count));
    newLabels = newLabels + randn(size(newLabels))*sigma;
    newLabels(newLabels < minValue) = minValue;
    newLabels(newLabels > maxValue) = maxValue;
    newTargets = targets(:,perm(1:count));
end