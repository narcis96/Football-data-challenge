trainData = [];
trainLabels = [];
indexes = [];
for i = 1:size(uniqueYears,2) - 1
    
    year = uniqueYears(i);
    nextYear = uniqueYears(i+1);
    
    yearMatches = find(dates(:,1) == year & dates(:,2) <= 6)';
    yearMatches = [yearMatches find(dates(:,1) == nextYear & dates(:,2) >= 8)'];
    
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