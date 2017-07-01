function [net, perf] = Train(trainVectors, trainLabels, hiddenLayers, trainFcn, performFcn)
    %default value trainFcn = 'trainscg';
    %default value performFcn = 'crossentropy';
    net = patternnet(hiddenLayers,trainFcn,performFcn);

    % Set up Division of Data for Training, Validation, Testing
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;

    % Train the Network
    net = train(net,trainVectors,trainLabels);
    
    result = net(trainVectors);
    perf = perform(net,trainLabels,result);
    
end