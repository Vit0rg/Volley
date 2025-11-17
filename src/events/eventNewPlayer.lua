function eventNewPlayer(name)
  customMapCommand[name] = true
  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectMapImages[name] = {}
  isOpenProfile[name] = false
  playerTrophyImage[name] = 0
  if playerAchievements[name] == nil then
    playerAchievements[name] = {
      [1] = { image = "img@193d6763c82", quantity = 0 },
      [2] = { image = '19636907e9e.png', quantity = 0},
      [3] = { image = "197d9272515.png", quantity = 0 },
      [4] = { image = "1984ac78d52.png", quantity = 0 },
      [5] = { image = "1984ac773d3.png", quantity = 0 }
    }
  end
  playerAchievementsImages[name] = {}
  settings[name] = false
  settingsMode[name] = false
  playerLeft[name] = false
  playerLeftRight[name] = 0
  playerConsumable[name] = true
  playerConsumableKey[name] = 56
  playerConsumableItem[name] = 80
  playerForce[name] = 0
  showOutOfCourtText[name] = false
  playerOutOfCourt[name] = false
  openRank[name] = false
  playerLanguage[name] = {tr = trad, name = name}
  pagesList[name] = {helpPage = 1}
  playersAfk[name] = os.time()

  showCrownToAllPlayers()
  if canVote[name] == nil then
    canVote[name] = true
  end

  if showCrownImages[name] == nil then
    showCrownImages[name] = true
  end

  if playersOnGameHistoric[name] == nil then
    playersOnGameHistoric[name] = { teams = {} }
  end

  if playerLastMatchCount[name] == nil then
    playerLastMatchCount[name] = countMatches
  else
    if playerLastMatchCount[name] ~= countMatches then
      playersOnGameHistoric[name] = { teams = {} }
    end
  end

  if playerBan[name] == nil then
    playerBan[name] = false
    playerBanHistory[name] = ""
  end

  if gameStats.killSpec or killSpecPermanent then
    tfm.exec.killPlayer(name)
  else
    tfm.exec.respawnPlayer(name)
  end

  if playersNormalMode[name] == nil then
    playersNormalMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageNormalMode[name] = 1
    playersFourTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsYellow = 0, winsGreen = 0}
    pageFourTeamsMode[name] = 1
    playersTwoTeamsMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageTwoTeamsMode[name] = 1
    playersRealMode[name] = {name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0}
    pageRealMode[name] = 1
    playerRankingMode[name] = "Normal mode"
  end

  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  
  system.bindKeyboard(name, 32, true, true)
  system.bindKeyboard(name, 0, true, true)
  system.bindKeyboard(name, 1, true, true)
  system.bindKeyboard(name, 2, true, true)
  system.bindKeyboard(name, 3, true, true)
  system.bindKeyboard(name, 49, true, true)
  system.bindKeyboard(name, 50, true, true)
  system.bindKeyboard(name, 51, true, true)
  system.bindKeyboard(name, 52, true, true)
  system.bindKeyboard(name, 55, true, true)
  system.bindKeyboard(name, 56, true, true)
  system.bindKeyboard(name, 57, true, true)
  system.bindKeyboard(name, 48, true, true)
  system.bindKeyboard(name, 77, true, true)
  system.bindKeyboard(name, 76, true, true)
  system.bindKeyboard(name, 80, true, true)

  tfm.exec.setNameColor(name, 0xD1D5DB)
  if playerBan[name] then
    tfm.exec.chatMessage("<bv>You have been banned from the room by the admin "..playerBanHistory[name].."<n>", name)
    tfm.exec.kickPlayer(name)
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)
  
  if mode == "startGame" then
    eventNewGameShowLobbyTexts(gameStats.teamsMode)

    ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", name, 10, 370, 150, 30, 1, false, false, _)

    if admins[name] then
      ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150, 30, 1, false, false, _)
    end
  elseif mode ~= "startGame" then
    tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", name)
    showTheScore()
    teleportPlayersToSpecWithSpecificSpawn(name)

    tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage2, name)
    canVote[name] = true
  end
  tfm.exec.chatMessage("<j>#Volley Version: "..gameVersion.."<n>", name)
  tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
end