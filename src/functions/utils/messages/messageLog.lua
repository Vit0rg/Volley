function messageLog(message)
  for name, data in pairs(tfm.get.room.playerList) do
    if admins[name] then
      printf(message, name)
    end
  end
end
