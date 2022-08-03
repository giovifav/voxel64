function love.load()
    love.window.setTitle('voxelspace')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle("rough")
    --importing globals
    object = require('libs.classic')
    terrain = require('src.terrain')("maps/C1W.png","maps/C1D.png")
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
    

    if love.keyboard.wasPressed("1")then
        terrain = require('src.terrain')("maps/C1W.png","maps/C1D.png")

    end
    if love.keyboard.wasPressed("2")then
        terrain = require('src.terrain')("maps/C2W.png","maps/C2D.png")

    end
    if love.keyboard.wasPressed("3")then
        terrain = require('src.terrain')("maps/C3W.png","maps/C3D.png")

    end
    if love.keyboard.wasPressed("4")then
        terrain = require('src.terrain')("maps/C4W.png","maps/C4D.png")

    end



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