function [ index ] = GetTeamIndex(team,teamsArray)
    index = strmatch(team, teamsArray);
end

