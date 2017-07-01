trainFile       = './trainSet/train.csv';
testFile        = './testSet/test.csv';
outputFile      = 'submission.csv';
ratioFile      = 'ratio_win.csv';
averageTeamsFile =  'average_teams.csv';
networkConfidence = 4/10;
%read

ratio = csvread(ratioFile, 1, 1);
averageTeamsTable = readtable(averageTeamsFile);
averageTeams = table2cell(averageTeamsTable)';
array = table2array(averageTeams(:,1));
disp(array);
table = readtable(trainFile);
disp(size(table));

matches = table2cell(table(:,[3 4]));
testTable = readtable(testFile);
testMatches = table2cell(testTable(:,[3 4]));
teams = unique([matches; testMatches])';
testMatches = testMatches';
winners = char(table2cell(table(:,5)));
dates = datevec(table2cell(table(:,2)));
uniqueYears = unique(dates(:,1))';
countTeams = size(teams,2);

trainData = [];
trainLabels = [];
indexes = [];
for year = uniqueYears
    yearMatches = find(dates(:,1) == year)';
    
    score = zeros(1,countTeams);
    winnings = zeros(1,countTeams);
    losses = zeros(1,countTeams);
    ties = zeros(1,countTeams);
    homeMatches = zeros(1,countTeams);
    awayMatches = zeros(1,countTeams);
    currentYearTrainData = [];
    
    indexes = [indexes [size(trainData,2) + 1 0]'];
    for i = yearMatches 
       team1 = GetTeamIndex(matches(i, 1), teams);
       team2 = GetTeamIndex(matches(i, 2), teams);
       match = GetFeatures(matches(i, 1), matches(i, 2), teams, homeMatches, awayMatches, winnings, ties, losses,score);
       trainData = [trainData match'];
       winner = -1;
       loser = -1;
        if winners(i) == 'H'
            winner = 1;
            loser = 2;
            trainLabels = [trainLabels [1 0 0]'];
        elseif winners(i) == 'A'
            winner = 2;
            loser = 1;
            trainLabels = [trainLabels [0 0 1]'];
        else
            trainLabels = [trainLabels [0 1 0]'];
        end
            
        if(winner > 0)
            winner = GetTeamIndex(matches(i, winner), teams);
            loser = GetTeamIndex(matches(i,loser), teams);
            
            score(winner) = score(winner) + 3;
            winnings(winner) = winnings(winner) + 1;
            losses(loser) = losses(loser) + 1;

        else
            ties(team1) = ties(team1) + 1;
            ties(team2) = ties(team2) + 1;

            score(team1) = score(team1) + 1;
            score(team2) = score(team2) + 1;
        end

        homeMatches(team1) = homeMatches(team1) + 1;
        awayMatches(team2) = awayMatches(team2) + 1;

    end
    indexes(end) = size(trainData,2);
end

disp(size(trainData));      


percentage = 25/100;
sigma = 0.2;
minValue = min(min(trainData));
maxValue = max(max(trainData));
[newTrainVectors, newTrainLabels] = DistrurbRandomSamples(trainData, trainLabels, percentage, sigma, minValue, maxValue);
trainData = [trainData newTrainVectors];
trainLabels = [trainLabels newTrainLabels];
disp(size(trainData));      


arhitectures = 3;
minPerceptrons = 20;
maxPerceptrons = 40;
minLayers = 1;
maxLayers = 2;
arhitecture = [30 15];
trainfcs = 'trainlm';
%performFcn = 'crossentropy';
performFcn = 'mse';

%[arhitecture,performance,thresholds] = ChoseBest(trainData, trainLabels, arhitectures, minPerceptrons, maxPerceptrons, minLayers, maxLayers,indexes, trainfcs, performFcn);
%perf = 1;
%while perf > 0.180
  % [net,perf] = Train(trainData, trainLabels, arhitecture, trainfcs, performFcn);
 %   disp(sprintf('perf = %f ',perf));
%end
%perf1 = 1;
%while perf1 > 0.21
 %   [net1,perf1] = Train1(trainData, trainLabels, arhitecture, trainfcs, performFcn);
%end

%disp(sprintf('currentPerformance  = %d ',currentPerformance));
%disp(sprintf('performace = %f ',performace));
%while performace > 0.69
 %   [performace, thresholds] = KFoldCrossValidation(trainData,trainLabels, arhitecture,indexes);
%end

tests = [];
score = zeros(1,countTeams);
winnings = zeros(1,countTeams);
losses = zeros(1,countTeams);
ties = zeros(1,countTeams);
homeMatches = zeros(1,countTeams);
awayMatches = zeros(1,countTeams);
count = zeros(1,3);
for i = 1:size(testMatches,2)
    team1 = GetTeamIndex(testMatches(1,i), teams);
    team2 = GetTeamIndex(testMatches(2,i), teams);
    match = GetFeatures(testMatches(1,i), testMatches(2,i), teams, homeMatches, awayMatches, winnings, ties, losses, score);
    tests = [tests match'];
    winner = -1;
    loser = -1;
    output = sim(net,match');
    output = output*networkConfidence + rand()*(1-networkConfidence);
    if output(1) > 0.5
        winner = 1;
        loser = 2;
    elseif output(3) > 0.25
            winner = 2;
            loser = 1;
    end
    
    if(winner > 0)
            if(winner == 1)
                count(1) = count(1) + 1;
            else
                count(3) = count(3) + 1;
            winner = GetTeamIndex(matches(i, winner), teams);
            loser = GetTeamIndex(matches(i,loser), teams);
            
            score(winner) = score(winner) + 3;
            winnings(winner) = winnings(winner) + 1;
            losses(loser) = losses(loser) + 1;

            end
        else
            ties(team1) = ties(team1) + 1;
            ties(team2) = ties(team2) + 1;
            count(2) = count(2) + 1;
            score(team1) = score(team1) + 1;
            score(team2) = score(team2) + 1;
    end
    
    homeMatches(team1) = homeMatches(team1) + 1;
    awayMatches(team2) = awayMatches(team2) + 1;
    
end
thresholds = [0.4300    0.3325    0.4015];
newThresholds = mean(ratio)/100;
[answers, output] = Test(net, tests, thresholds(1), thresholds(2),thresholds(3));
answers1 = vec2ind(sim(net,tests));nrTests = size(tests,2);
final = zeros(nrTests,2);
final(:,1) = 1:size(final,1);
final(:,2) = answers;

csvwrite(outputFile,final);
csvwrite(strcat('./tests/',outputFile),final);
partition = [numel(find(answers==1)) numel(find(answers==2)) numel(find(answers==3))];
partition1 = [numel(find(answers1==1)) numel(find(answers1==2)) numel(find(answers1==3))];
%disp(output);
disp(sprintf('thresholds =  '));
disp(thresholds);
disp(sprintf('count =  '));
disp(count);
disp(sprintf('perf = %f ',perf));
disp(sprintf('networkConfidence = %f ',networkConfidence));
disp(sprintf('partition =  '));
disp(partition);
disp(sprintf('partition1 =  '));
disp(partition1);
%disp(min((output')));
%disp(mean((output')));
%disp(max((output')));
%scores = table(:,6);
%Q(isnan(Q))=0;
