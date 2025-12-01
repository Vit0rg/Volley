local afkSystem = addTimer(function(i)
  if mode == "gameStart" and enableAfkSystem and gameStats.enableAfkMode then
    for name, data in pairs(tfm.get.room.playerList) do
      if playerInGame[name] then
        local time = math.ceil((playersAfk[name] - os.time())/1000)
        if time <= afkTimeValue then
          if gameStats.teamsMode and gameStats.canTransform then
            leaveTeamTeamsMode(name)
            printf("<bv>"..name.." left the game because "..name.." was AFK<n>", nil)
          else
            if not gameStats.teamsMode then
              leaveTeam(name)
              printf("<bv>"..name.." left the game because "..name.." was AFK<n>", nil)
            end
          end
        end
      end
    end
  end
end, 1000, 0, "afkSystem")