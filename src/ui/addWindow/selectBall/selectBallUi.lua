function selectballUI(name)
  removeSelectUI(name)
  local balls = configSelectball()
  local maxPage = getMaxPageball(balls)
  local page = selectballPage[name]

  for i = 1, 5 do
    local index = i + ((page - 1) * 5)

    if balls[index] ~= nil then
      local textSelect = "<a href='event:setball"..index.."'>Select ball</a>"
      local voteText = "<a href='event:voteball"..index.."'>Vote ball ("..showballVotes(balls, index)..")</a>"

      if index == gameStats.customballIndex then
        textSelect = "<j>Selected ball<n>"
      elseif not admins[name] then
        textSelect = "<n2>Select ball<n>"
      end

      /*
      //Maybe add vote system for balls?
      if not canVote[name] then
        voteText = "<n2>Vote ball<n> ("..showballVotes(balls, index)..")"
      end
      */

      ui.addTextArea(""..tostring(99999)..""..tostring(i).."", "", name, (142 + ((i - 1) * 125)), 115, 110, 140, 0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea(""..tostring(999999)..""..tostring(i).."", "", name, (147  + ((i - 1) * 125)), 120, 100, 43, 0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea(""..tostring(9999999)..""..tostring(i).."", "<p align='center'><font size='12px'><a href='event:ball"..balls[index][3].."'>"..formatballName(balls[index][3]).."</a>", name, (147  + ((i - 1) * 125)), 165, 100, 20, 0x142b2e, 0x2d5a61, 0, true)

      ui.addTextArea(""..tostring(99999999)..""..tostring(i).."", "<p align='center'><font size='12px'>"..textSelect.."", name, (147  + ((i - 1) * 125)), 190, 100, 20, 0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea(""..tostring(999999999)..""..tostring(i).."", "<p align='center'><font size='12px'>"..voteText.."", name, (147  + ((i - 1) * 125)), 225, 100, 20, 0x142b2e, 0x2d5a61, 1, true)

      table.insert(selectballImages[name], tfm.exec.addImage(balls[index][6], "~999999"..i.."", (147 + ((i - 1) * 125 )), 118, name))
    end
  end

  selectballPointersNavigation(name, page, maxPage)

  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<a href='event:prevSelectball"..tostring(page - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
  end

  if page >= maxPage then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<a href='event:nextSelectball"..tostring(page + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
  end
end