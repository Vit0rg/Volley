function teleportPlayersToSpecWithSpecificSpawn(name)
  if #lobbySpawn > 0 then
    local index = math.random(1, #lobbySpawn)

    tfm.exec.movePlayer(name, lobbySpawn[index].x, lobbySpawn[index].y)
  else
    tfm.exec.movePlayer(name, 391, 74)
  end
end