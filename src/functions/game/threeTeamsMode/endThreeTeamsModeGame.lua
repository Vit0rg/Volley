function endThreeTeamsModeGame(messageTeamLose, indexTeamLose, messageTeamWin, teamWinPlayers)
  tfm.exec.chatMessage(messageTeamLose, nil)
  showTheScore()
  updateTeamsColors(indexTeamLose)
  showMessageWinner()
  ballOnGame = false
  ballOnGame2 = false
  ballOnGame3 = false
  ball_id = nil
  ball_id2 = nil
  ball_id3 = nil
  updateTwoBallOnGame()
  threeTeamsModeWinner(messageTeamWin, teamWinPlayers)
  updateRankingThreeTeamsMode()
  tfm.exec.removeObject(ball_id)
  mode = "endGame"
  gameTimeEnd = os.time() + 5000
end
