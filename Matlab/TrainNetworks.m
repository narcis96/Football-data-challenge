arhitectures = 3;
minPerceptrons = 20;
maxPerceptrons = 40;
minLayers = 1;
maxLayers = 2;
trainfcs = 'trainlm';
%performFcn = 'crossentropy';
performFcn = 'mse';
if findArhitecture == true
    [arhitecture,performance,thresholds] = ChoseBest(trainData, trainLabels, arhitectures, minPerceptrons, maxPerceptrons, minLayers, maxLayers,indexes, trainfcs, performFcn);
else
    arhitecture = customArhitecture;    
end
minimum = 1;
for i = 1:networkCount
  if trainNetwork(i) == true
      perf(i) = 1;  
      while perf(i) > 0.65
        net{i} = Train(trainData, trainLabels, arhitecture, trainfcs, performFcn);
        [perf(i),currentThresholds] = ChoseBestThresholds(net{i}, trainData, trainLabels);
        disp(sprintf('perf = %f ',perf(i)));
        disp(sprintf('currentThresholds =  '));
        disp(currentThresholds);
      end
  end
end
