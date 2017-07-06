averageOddsWinners = csvread(averageOddsFile)';
ratio = csvread(ratioFile, 1, 1);
averageTeamsTable = readtable(averageTeamsFile);
averageTeams = table2cell(averageTeamsTable)';
%array = table2array(averageTeams(:,1));
%disp(array);
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
