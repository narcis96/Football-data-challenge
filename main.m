trainFile       = './trainSet/train.csv';
testFile        = './testSet/test.csv';
outputFile      = 'submission.csv';
ratioFile      = 'ratio_win.csv';

%read

ratio = csvread(ratioFile, 1, 1);

table = readtable(trainFile);
disp(size(table));

matches = table2cell(table(:,[3 4]));
testTable = readtable(testFile);
testMatches = table2cell(testTable(:,[3 4]));
teams = unique([matches; testMatches]);

winners = char(table2cell(table(:,5)));
dates = datevec(table2cell(table(:,2)));
uniqueYears = unique(dates(:,1))';
countTeams = size(teams,1);

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
arhitectures = 3;
minPerceptrons = 4;
maxPerceptrons = 10;
minLayers = 1;
maxLayers = 2;
[arhitecture,performance,thresholds] = ChoseBest(trainData, trainLabels, arhitectures, minPerceptrons, maxPerceptrons, minLayers, maxLayers,indexes);
[net,perf] = Train(trainData, trainLabels, arhitecture);
func = {'tansig','logsig','tansig', 'logsig'};
trainfcs = 'trainlm';
perf1 = 1;
while perf1 > 0.2
    [net1,perf1] = Train1(trainData, trainLabels, arhitecture, func, trainfcs);
end
testMatches = testMatches';


tests = [];
score = zeros(1,countTeams);
winnings = zeros(1,countTeams);
losses = zeros(1,countTeams);
ties = zeros(1,countTeams);
homeMatches = zeros(1,countTeams);
awayMatches = zeros(1,countTeams);

for i = 1:size(testMatches,2)
    team1 = GetTeamIndex(testMatches(1,i), teams);
    team2 = GetTeamIndex(testMatches(2,i), teams);
    match = GetFeatures(testMatches(1,i), testMatches(2,i), teams, homeMatches, awayMatches, winnings, ties, losses, score);
    tests = [tests match'];
    winner = -1;
    loser = -1;
    if winners(i) == 'H'
        winner = 1;
        loser = 2;
    elseif winners(i) == 'A'
            winner = 2;
            loser = 1;
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
newThresholds = mean(ratio)/100;
[answers, output] = Test(net, tests, thresholds(1), thresholds(2),thresholds(3));
%[answers1, output1] = Test(net, tests, newThresholds(1), 0,newThresholds(2));
[answers1, output1] = Test(net1, tests, thresholds(1), thresholds(2),thresholds(3));

nrTests = size(tests,2);
final = zeros(nrTests,2);
final(:,1) = 1:size(final,1);
final(:,2) = answers1;

csvwrite(outputFile,final);
csvwrite(strcat('./tests/',outputFile),final);

%scores = table(:,6);
%Q(isnan(Q))=0;
