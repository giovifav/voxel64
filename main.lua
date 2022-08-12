local render
function love.load()
    love.window.setTitle('voxelspace')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle("smooth")
    voxelspace = require('voxelspace')
    local terrain = voxelspace.terrain('maps/1.png', 'maps/1h.png')
    render = voxelspace.render(terrain)
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
    render:update(dt)
    
    if love.keyboard.wasPressed("1")then
        local terrain = voxelspace.terrain('maps/1.png', 'maps/1h.png')("maps/C1W.png","maps/C1D.png")
        render = voxelspace.render(terrain)
    end
    if love.keyboard.wasPressed("2")then
        local terrain = voxelspace.terrain("maps/C2W.png","maps/C2D.png")
        render = voxelspace.render(terrain)
    end
    if love.keyboard.wasPressed("3")then
        local terrain = voxelspace.terrain("maps/C3W.png","maps/C3D.png")
        render = voxelspace.render(terrain)
    end
    if love.keyboard.wasPressed("4")then
        local terrain = voxelspace.terrain("maps/C4W.png","maps/C4D.png")
        render = voxelspace.render(terrain)
    end
    
    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.setBackgroundColor(86 /255,180/255,211/255)
    love.graphics.push()
    love.graphics.scale(2,2)
    render:draw() 
    love.graphics.pop()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end