function updateSettingsUI()
  for name, data in pairs(tfm.get.room.playerList) do
    if settings[name] then
      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings.."", name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
      
      if settingsMode[name] then
        local modes = getActionsModes()
        local str = ''

        for i = 1, #modes do
          str = ""..str..""..modes[i].."<br>"
        end
        ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMode'>Select a mode</a><br><br>"..str.."", name, 665, 110, 100, 100, 1, false, false)
      else
        ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 110, 100, 30, 1, false, false)
      end

      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings, name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)

    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 105, 100, 30, 1, false, false)
    
    if globalSettings.randomBall then
      ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:randomball'>Enabled</a>", name, 665, 160, 100, 30, 1, false, false)
      else
      ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:randomball'>Disabled</a>", name, 665, 160, 100, 30, 1, false, false)
    end

    if globalSettings.randomMap then
      ui.addWindow(22, "<p align='center'><font size='11px'><a href='event:randommap'>Enabled</a>", name, 665, 215, 100, 30, 1, false, false)
      else
      ui.addWindow(22, "<p align='center'><font size='11px'><a href='event:randommap'>Disabled</a>", name, 665, 215, 100, 30, 1, false, false)
    end

    if globalSettings.twoBalls then
      ui.addWindow(44, "<p align='center'><font size='11px'><a href='event:twoballs'>Enabled</a>", name, 665, 275, 100, 30, 1, false, false)
      else
      ui.addWindow(44, "<p align='center'><font size='11px'><a href='event:twoballs'>Disabled</a>", name, 665, 275, 100, 30, 1, false, false)
    end
    end
  end
end
