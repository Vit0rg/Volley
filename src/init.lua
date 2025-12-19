local function initializeBalls()
  local spawnBallArea400 = {}
  local spawnBallArea800 = {}
  local spawnBallArea1200 = {}
  local spawnBallArea1600 = {}

  removeTimer('verifyBallCoordinates')

  local ballOnGame = false
  local ballOnGame2 = false
  local ballOnGame3 = false
  local ballOnGameTwoBalls = { ballOnGame, ballOnGame2, ballOnGame3 }
  local ballsId = { nil, nil, nil }

  local ball_id = 0
end

local function initializePlayers()
  local lobbySpawn = {}
  local playersSpawn400 = {}
  local playersSpawn800 = {}
  local playersSpawn1200 = {}
  local playersSpawn1600 = {}

  local playerConsumables = {}

  local playersOnGameHistoric = {}

  local playerCanTransform = {}
  local playerInGame = {}

  local playerCoordinates = {}

  local playerPhysicId = {}
end

local function initializeTeams()
  local twoTeamsPlayerRedPosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }
  local twoTeamsPlayerBluePosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }

  local playersRed = {
    [1] = { name = '' },
    [2] = { name = '' },
    [3] = { name = '' },
    [4] = { name = '' },
    [5] = { name = '' },
    [6] = { name = '' }
  }
  local playersBlue = {
    [1] = { name = '' },
    [2] = { name = '' },
    [3] = { name = '' },
    [4] = { name = '' },
    [5] = { name = '' },
    [6] = { name = '' }
  }
  local playersYellow = {
    [1] = { name = '' },
    [2] = { name = '' },
    [3] = { name = '' }
  }

  local playersGreen = {
    [1] = { name = '' },
    [2] = { name = '' },
    [3] = { name = '' }
  }

  local teamsLifes = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }

  local getTeamsLifes = {}

  local getTeamsColors = {}
  local teamsPlayersOnGame = {}
  local messageTeamsLifes = {}
  local messageTeamsLostOneLife = {}
  local messageTeamsLifesTextChat = {}
  local messageWinners = {}
  local getTeamsColorsName = { 0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267 }

  local score_red = 0
  local score_blue = 0
end

local function initializeTfmSettings()
  tfm.exec.disableAllShamanSkills(true)
  tfm.exec.newGame(lobbyMaps[1][1])
end

local function initializeSettings()
  local durationDefault = 300
  local duration = os.time() + durationDefault * 1000
  local durationTimerPause = durationDefault

  local mode = "startGame"

  local mapsToTest = { [1] = "", [2] = "", [3] = "" }

  for i = 1, #customMaps do
    mapsVotes[i] = 0
  end

  -- The amount of redundancy here is astonishing.
  -- Should refactor too. @Tanarchosl
  local gameStats = {
    gameMode = '',
    redX = 0,
    blueX = 0,
    yellowX = 0,
    greenX = 0,
    redX2 = 0,
    blueX2 = 0,
    setMapName = '',
    winscore = 7,
    initTimer = 0,
    isCustomMap = false,
    randomMap = false,
    customMapIndex = 0,
    totalVotes = 0,
    mapIndexSelected = 0,
    canTransform = false,
    teamsMode = false,
    canJoin = true,
    customBall = true,
    customBallId = 12,
    banCommandIsEnabled = true,
    killSpec = false,
    isGamePaused = false,
    psyhicObjectForce = 1,
    twoTeamsMode = false,
    enableAfkMode = false,
    realMode = false,
    redServeIndex = 1,
    blueServeIndex = 1,
    redPlayerServe = "",
    bluePlayerServe = "",
    redServe = false,
    blueServe = false,
    redQuantitySpawn = 0,
    redLimitSpawn = 3,
    blueQuantitySpawn = 0,
    blueLimitSpawn = 3,
    lastPlayerRed = "",
    lastPlayerBlue = "",
    teamWithOutAce = "",
    reduceForce = false,
    aceRed = false,
    aceBlue = false,
    twoBalls = false,
    consumables = false,
    actualMode = "",
    stopTimer = false,
    threeTeamsMode = false,
    threeBalls = false
  }

  -- Check the use of this countId variable, maybe delete
  local countId = 1

  if globalSettings.twoBalls then
    gameStats.twoBalls = true
  end

  if globalSettings.threeBalls then
      gameStats.threeBalls = true
    end

  if globalSettings.randomBall then
    gameStats.customBall = true
    local indexBall = math.random(1, #balls)
    gameStats.customBallId = indexBall
  end

  -- Refactor this garbage asap
  if globalSettings.randomMap then
    gameStats.randomMap = true
    gameStats.isCustomMap = true
    local indexMap = 1

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    local _modes = {['normalMode'] = 'customMaps',
                    ['twoTeamsMode'] = 'customMapsFourTeamsMode',
                    ['teamsMode'] = 'customMapsFourTeamsMode',
                    ['threeTeamsMode'] = 'customMapsThreeTeamsMode'
                  }

    -- This looks disgusting
    if gameStats.twoTeamsMode or gameStats.teamsMode then
      indexMap = math.random(1, #customMapsFourTeamsMode)
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage('<bv>' ..customMapsFourTeamsMode[gameStats.customMapIndex][3] ..' map (created by ' .. customMapsFourTeamsMode[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
    elseif gameStats.threeTeamsMode then
      indexMap = math.random(1, #customMapsThreeTeamsMode)
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage('<bv>'..customMapsThreeTeamsMode[gameStats.customMapIndex][3] ..' map (created by ' .. customMapsThreeTeamsMode[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
    elseif not gameStats.realMode then
      indexMap = math.random(1, #customMaps)
      gameStats.customMapIndex = indexMap
      print('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by ' .. customMaps[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
    end
  end

  --[[ Refactor this
    if gameStats.mode = "normalMode" then
    ]]
  if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realmode then
    if globalSettings.consumables then
      gameStats.consumables = true

      tfm.exec.chatMessage("<bv>Room Setup: Consumables has been activated in normal mode<n>", nil)
    end

    if globalSettings.mapType ~= '' then
      gameStats.setMapName = globalSettings.mapType

      tfm.exec.chatMessage("<bv>Room Setup: The map size has been set to " .. globalSettings.mapType .. "<n>", nil)
    end
  end

  for name, data in pairs(tfm.get.room.playerList) do
    playerLeftRight[name] = 0
    playerConsumableKey[name] = 56
    playerConsumable[name] = true
    playerConsumableItem[name] = 80
    playerForce[name] = 0
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = { x = 0, y = 0 }
    playerPhysicId[name] = 0
    playersOnGameHistoric[name] = { teams = {} }

    for i = 1, #keys do
      system.bindKeyboard(name, keys[i], true, true)
    end

    tfm.exec.setNameColor(name, 0xD1D5DB)

    -- This has no real effect for now, but persistent individual ranking system 
    -- could make use of it
    -- Tanarchosl
    tfm.exec.setPlayerScore(name, 0, false)

    pagesList[name] = { helpPage = 1 }

    canVote[name] = true
  end
end

local function initializeMode()
  getTeamsColorsName = { '#F59E0B', '#EF4444', '#3B82F6', '#109267'}
  local teamColors = {
    [1] = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}, --4t
    [2] = {0xEF4444, 0x3B82F6, 0x109267}, --3t
    [3] = {},
  }

  local teamsLifes = {
    [1] = { yellow = 3 },
    [2] = { red = 3 },
    [3] = { blue = 3 },
    [4] = { green = 3 }
  }

  local modes = {
    [1] = {"Normal mode", },
    [2] = {"2 teams mode", gameStats.twoTeamsMode},
    [3] = {"3 teams mode", gameStats.threeTeamsMode},
    [4] = {"4 teams mode", gameStats.teamsMode},
    [5] = {"Real mode", gameStats.realMode},
  }

  if globalSettings.mode == "4 teams mode" then
    gameStats.teamsMode = true
    getTeamsColorsName = { 0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267 }
    teamsLifes = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }
    updateLobbyTextAreas()
  elseif globalSettings.mode == "3 teams mode" then
    gameStats.threeTeamsMode = true
    getTeamsColorsName = { 0xEF4444, 0x3B82F6, 0x109267 }
    playersYellow = {
      [1] = { name = '' },
      [2] = { name = '' },
      [3] = { name = '' },
      [4] = { name = '' }
    }

    playersGreen = {
      [1] = { name = '' },
      [2] = { name = '' },
      [3] = { name = '' },
      [4] = { name = '' }
    }

    teamsLifes = { [1] = { yellow = 5 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
    updateLobbyTextAreas()

  elseif globalSettings.mode == "2 teams mode" then
    gameStats.twoTeamsMode = true
  elseif globalSettings.mode == "Real mode" then
    gameStats.realMode = true
  end

  if not gameStats.teamsMode then
    for i = 1, 3 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", nil, x[i],
        y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 4, 6 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. i .. "'>Join", nil, x[i],
        y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    end

    for i = 8, 10 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. (i - 4) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 11, 13 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end

  initGame = os.time() + 25000
end

local function logRoomSetup()
  printf("<bv>Room Setup: Two-ball mode activated<n>", nil)
  printf("<bv>Room Setup: Random ball activated<n>", nil)
  printf("<bv>Room Setup: Random map activated<n>", nil)
  printf("<bv>Room Setup: Current mode: " .. globalSettings.mode .. "<n>", nil)
end

local function initializeUI()
  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", nil, 5, 15, 100, 30, 0.2, false,
    false, _)
  ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", nil, 10, 370, 150, 30, 1,
    false, false, _)
  ui.removeTextArea(0)
  ui.addTextArea(7, "<p align='center'>", nil, 375, 50, 30, 20, 0x161616, 0x161616, 1, false)

  if selectMapOpen[name] then
    selectMapPage[name] = 1
    selectMapUI(name)
  end

  if admins[name] then
    ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150,
      30, 1, false, false, _)
  end
end

local function init()
  initializeBalls()
  initializePlayers()
  initializeTeams()

  initializeTfmSettings()
  initializeSettings()

  initializeMode()
  initializeUI()

  afkSystem()
  logRoomSetup()
end

init()
