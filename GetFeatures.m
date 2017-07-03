function [ match ] = GetFeatures(homeTeam, awayTeam, teams, homeMatches, awayMatches, winnings, ties, losses, score)
    team1 = GetTeamIndex(homeTeam, teams);
    team2 = GetTeamIndex(awayTeam, teams);
        
    assert(1<= team1 && team1 <= size(teams,2));
    assert(1<= team2 && team2 <= size(teams,2));
        
    team1matches = homeMatches(team1) + awayMatches(team1);
    team2matches = homeMatches(team2) + awayMatches(team2);

    team1points = score(team1);
    team2points = score(team2);

    team1winnings = winnings(team1);
    team2winnings = winnings(team2);

    team1ties = ties(team1);
    team2ties = ties(team2);
        
    team1losses = losses(team1);
    team2losses = losses(team2);

    team1home = homeMatches(team1);%homeWinnings
    team1away = awayMatches(team1);%awayWinnings
    team2home = homeMatches(team2);
    team2away = awayMatches(team2);
        

    leaderboard = sort(unique(score),'descend');

    team1Place = find(leaderboard == team1points);
    team2Place = find(leaderboard == team2points);  
    
    first5_1 = 0;
    first5_2 = 0;
    last5_1 = 0;
    last5_2 = 0;
    if team1Place < 5
        first5_1 = 1;
    elseif team1Place >= size(leaderboard) - 5
        last5_1 = 1;
    end
  
    if team2Place < 5
        first5_2 = 1;
    elseif team2Place >= size(leaderboard) - 5
        last5_2 = 1;
    end
    
        
    match = [];
    arrayteams = zeros(size(teams));
    arrayteams(team1) = 1;
    arrayteams(team2) = 2;
    match = [match arrayteams];
    %match = [team1 team2];
    %match = [match team1points team2points team1winnings team2winnings];
    %match = [match team1ties team2ties team1losses team2losses];
    match = [match team1home team2home];
    match = [match team1away team2away];
    %match = [match first5_1 first5_2];
    %match = [match last5_1 last5_2];
    %match = [match team1matches team2matches];
    %match = [match team1Place(1) team2Place(1)];
end

