function textSyncCondition(sync)
  local syncConditionValues = {50, 100, 150, 200}
  local syncText = {"Perfect", "Good", "Fair", "Bad", "Terrible"}
  
  for i = 1, #syncConditionValues do
    if sync <= syncConditionValues[i] then
      return syncText[i]
    end
  end
  
  return syncText[5]
end