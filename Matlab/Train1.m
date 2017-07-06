function [net, perf] = Train1(trainVectors, trainLabels, hiddenLayers, trainFcn, performFcn)
    lastLayer = size(trainLabels, 1);    
    hiddenLayers = [hiddenLayers lastLayer];
    net = newff(minmax(trainVectors),hiddenLayers); %trainscg
    net.IW{1,1} = rand(size(net.IW{1,1}))*0.1;net.b{1} = rand(size(net.b{1}))*0.1;
    net.LW{2,1} = rand(size(net.LW{2,1}))*0.1;net.b{2} = rand(size(net.b{2}))*0.1;
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 75/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    net.trainFcn = trainFcn;
    net.performFcn = performFcn;
    net.performParam.regularization = 0.00022;
%     net.performParam.normalization = 'percent';
    for i = 1:size(hiddenLayers,2)
        net.layers{i}.transferFcn = 'logsig';%'softmax';
    end
    % Train the Network
    [net,~] = train(net,trainVectors,trainLabels);

    result = net(trainVectors);
    perf = perform(net,trainLabels,result);
    
end