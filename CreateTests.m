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
    if averageOddsWinners(2,i) < 1.5 && averageOddsWinners(1,i) ~= 2
          winner = averageOddsWinners(1,i);
          if(winner == 3)
              winner = 2;
          end
    else
        output = sim(net{1},match')*networkPercentage(1);
        for netIndex = 2:networkCount
            output = output + sim(net{netIndex},match')*networkPercentage(netIndex);
        end
        output = output + distribution*(1-sum(networkPercentage));%magic part
        x = rand();
        %y = rand()*(1-sum(networkPercentage));
         if x < output(1)
         	winner = 1;
         elseif 1-output(3) < x
         	winner = 2;
         end
    end

    
    if(winner > 0)
            if(winner == 1)
                count(1) = count(1) + 1;
            else
                count(3) = count(3) + 1;
            
            loser = 3 - winner;
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