VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

push = require 'push'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.update(dt)
end

function love.keypressed(key)
end

function love.draw()
  push:start()
  love.graphics.print('Hello World')
  push:finish()
end