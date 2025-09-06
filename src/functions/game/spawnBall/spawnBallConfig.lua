function spawnBallConfig(spawnBalls, x)
  local customBallId = 6
  local ballPlaces = spawnBallsOnSpecificPlaces(spawnBalls, x)
  
  -- print("Ball places:")
  -- print(ballPlaces)
  
  if gameStats.customBall then
    customBallId = balls[gameStats.customBallId].id
  end
  
  ball_id = tfm.exec.addShamanObject(customBallId, ballPlaces[1].x, ballPlaces[1].y, 0, 0, -5, true)
  
  if gameStats.customBall then
    if balls[gameStats.customBallId].isImage then
      tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 10)
    end
  end
  
  if gameStats.twoBalls then
    ball_id2 = tfm.exec.addShamanObject(customBallId, ballPlaces[2].x, ballPlaces[2].y, 0, 0, -5, true)
    
    if gameStats.customBall then
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id2, -15, -15, nil, 1, 1, _, 10)
      end
    end
    ballOnGame2 = true
  end
  
  ballOnGame = true
  updateTwoBallOnGame()
end