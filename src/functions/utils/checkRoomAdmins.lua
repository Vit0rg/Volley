-- Todo: Refactor this to use the player lookup 
-- to check for admins, there is no need to use a double 
-- lookup.

function getPlayersNames()
  local playersNames = {}
  for name, data in pairs(tfm.get.room.playerList) do
    table.insert(playersNames, data.playerName)
  end
  return playersNames
end

function checkRoomAdmins(playersNames, admins)
  for _, playerName in ipairs(playersNames) do
    if admins[playerName] then
      return true
    end
  end

  return false
end

if not checkRoomAdmins(getPlayers(), admins) then
    spawnGetAdminButton()
end
