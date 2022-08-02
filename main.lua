function love.load()
    love.window.setTitle('voxelspace')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle("rough")
    --importing globals
    object = require('libs.classic')
    terrain = require('src.terrain')("assets/map.png","assets/heightmap.png")
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    terrain:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.setBackgroundColor(86 /255,180/255,211/255)
    love.graphics.push()
    love.graphics.scale(2,2)
    terrain:draw() 
    love.graphics.pop()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end