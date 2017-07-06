trainFile       = './trainSet/train.csv';
testFile        = './testSet/test.csv';
outputFile      = 'submission.csv';
outputFile1      = 'submission1.csv';
ratioFile      = 'statistics/ratio_win.csv';
averageTeamsFile =  'statistics/average_teams.csv';
averageOddsFile = 'AverageOdds.csv';

distrurbSamples = false;
percentage = 20/100;
sigma = 0.5;

findArhitecture = false;
customArhitecture = [30 20];

networkCount = 2;
trainNetwork = zeros(1,networkCount);
trainNetwork(1) = false;
trainNetwork(2) = false;
%COMMENT NEXT 2 LINES AFTER FIRST RUN
%perf = zeros(1,networkCount);
%net = cell(networkCount,1);

networkPercentage = zeros(1,networkCount);
networkPercentage(1) = 50/100;
networkPercentage(2) = 50/100;
assert(sum(networkPercentage) <= 1);

useCurstomThresholds = true;
curstomThresholds = [0.4095 0.3268 0.3409];%0.4095    0.3268    0.3118 [0.3415    0.3408    0.3079]
distribution = [0.50;0.25;0.25];

ReadData;
CreateTrainData;
disp(size(trainData));      
AddTrainSamples;

TrainNetworks;
CreateTests;

if useCurstomThresholds == true
    thresholds = curstomThresholds;
end
newThresholds = mean(ratio)/100;

output = sim(net{1},tests)*networkPercentage(1);
for netIndex = 2:networkCount
    output = output + sim(net{netIndex},tests)*networkPercentage(netIndex);
end
output = output + repmat(distribution,[1 size(tests,2)]) *(1-sum(networkPercentage));
    
Write;
%disp(output);
DisplayInfo;

%disp(min((output')));
%disp(mean((output')));
%disp(max((output')));
%scores = table(:,6);
%Q(isnan(Q))=0;
