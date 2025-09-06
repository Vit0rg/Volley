function windowUISync(name)
  local playersSync = {}
  closeRankingUI(name)
  openRank[name] = false
  for name1, data in pairs(tfm.get.room.playerList) do
    local playerSync = tfm.get.room.playerList[name1].averageLatency
    local syncCondition = textSyncCondition(tfm.get.room.playerList[name1].averageLatency)
    
    if not playerLeft[name1] then
      playersSync[#playersSync + 1] = { name = name1, sync = tfm.get.room.playerList[name1].averageLatency, syncCondition = syncCondition }
    end
  end
  
  table.sort(playersSync, function(a, b) return a.sync < b.sync end)
  
  local str = ""
  for i = 1, 3 do
    if playersSync[i] ~= nil then
      str = ""..str.."<p align='left'><font size='12px'><a href='event:sync"..playersSync[i].name.."'>"..playersSync[i].name.."</a></p><p align='right'><font size='12px'>"..playersSync[i].syncCondition.."</p><br><br>"
    end
  end
  
  ui.addWindow(24, "<p align='center'><font size='14px'>Select player sync (click on player name to select the sync)</p><br><br><p align='left'><font size='12px'>Player</p><p align='right'><font size='12px'>Sync condition</p><br>"..str.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
end