function enableAfkMode()
  local enableAfkSystem = addTimer(function(i)
    if i == 1 then
      gameStats.enableAfkMode = true
    end
  end, 5000, 1, "enableAfkSystem")
end