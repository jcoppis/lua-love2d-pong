VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

PADDLE_WIDTH = 8
PADDLE_HEIGHT = 52
PADDLE_SPEED = 140

BALL_SIZE = 4

LARGE_FONT = love.graphics.newFont(32)
SMALL_FONT = love.graphics.newFont(16)

GAME_POINTS_TO_WIN = 3

push = require 'push'

gameState = 'title'

player1 =
  { x = 10
  , y = 10
  , score = 0
  }

player2 =
  { x = VIRTUAL_WIDTH - PADDLE_WIDTH - 10
  , y = VIRTUAL_HEIGHT - PADDLE_HEIGHT - 10
  , score = 0
  }

ball =
  { x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2
  , y = VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2
  , dx = 0
  , dy = 0
  }

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)

  resetBall()
end

function love.update(dt)
  if love.keyboard.isDown('w') then
    player1.y = player1.y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    player1.y = player1.y + PADDLE_SPEED * dt
  end

  if love.keyboard.isDown('up') then
    player2.y = player2.y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') then
    player2.y = player2.y + PADDLE_SPEED * dt
  end

  if gameState == 'play' then
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    if collides(ball, player1) then
      ball.x = player1.x + PADDLE_WIDTH
      ball.dx = -ball.dx
    elseif collides(ball, player2) then
      ball.x = player2.x - BALL_SIZE
      ball.dx = -ball.dx
    end

    if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
      ball.dy = -ball.dy
    end

    if ball.x <= 0 then
      resetBall()
      gameState = 'serve'
      player2.score = player2.score + 1
    elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
      resetBall()
      gameState = 'serve'
      player1.score = player1.score + 1
    end

    if player1.score >= GAME_POINTS_TO_WIN or player2.score >= GAME_POINTS_TO_WIN then
      gameState = 'win'
    end
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'enter' or key == 'return' then
    if gameState == 'title' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'win' then
      player1.score = 0
      player2.score = 0
      gameState = 'title'
    end
  end
end

function love.draw()
  push:start()
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  if gameState == 'title' then
    love.graphics.setFont(LARGE_FONT)
    love.graphics.printf('Pong', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(SMALL_FONT)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.setFont(SMALL_FONT)
    love.graphics.printf('Press Enter to Serve!', 0, 10, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'win' then
    love.graphics.setFont(LARGE_FONT)
    local winner = player1.score >= GAME_POINTS_TO_WIN and '1' or '2'
    love.graphics.printf('Player ' .. winner .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(SMALL_FONT)
    love.graphics.printf('Press Enter to Restart', 0,  VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')

  end

  love.graphics.setFont(LARGE_FONT)
  love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 34, VIRTUAL_HEIGHT / 2 - 18)
  love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 16, VIRTUAL_HEIGHT / 2 - 18)

  love.graphics.rectangle('fill', player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
  love.graphics.rectangle('fill', player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT)
  love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE)
  push:finish()
end

function collides(b, p)
  return not (b.x > p.x + PADDLE_WIDTH or b.y > p.y + PADDLE_HEIGHT or p.x > b.x + BALL_SIZE or p.y > b.y + BALL_SIZE)
end

function resetBall()
  math.randomseed(os.time())
  ball.x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2
  ball.y = VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2

  ball.dx = 60 + math.random(60)
  if math.random(2) == 1 then
    ball.dx = -ball.dx
  end

  ball.dy = 30 + math.random(60)
  if math.random(2) == 1 then
    ball.dy = -ball.dy
  end
end