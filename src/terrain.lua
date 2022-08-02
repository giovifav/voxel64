
local terrain = object:extend()
--make useful functions local for speed 
local ms = math.sin
local mc = math.cos
local mf = math.floor
function terrain:new(colormap, heighmap)
    self.angle = 90
    self.x = 0
    self.y = 0
    self.horizon = 100
    self.distance = 900
    self.visibility = self.distance * 0.7
    self.viewHeight = 130
    self.scaleHeight = 120
    self.renderWidth = 320
    self.renderHeight = 320
    self.distanceStep = 2
    self.colorMap = love.image.newImageData(colormap)
    self.heightMap = love.image.newImageData(heighmap)
    self.terrainWidth = self.heightMap:getWidth() - 1
    -- base 1  pixel image
    local img = love.image.newImageData(1,1)
    img:setPixel(0,0,1,1,1,1)
    self.image = love.graphics.newImage(img)
    --array for each color + altitude-
    --four tables seems faster than 1 array of tables
    self.r = {}
    self.g = {}
    self.b = {}
    self.h = {}
    --fill tables with every pixel of the color map  + altitude
    for x = 0, self.colorMap:getWidth() - 1 do
        for y = 0, self.colorMap:getHeight() - 1 do
            local r,g,b = self.colorMap:getPixel(x,y)
            local h = self.heightMap:getPixel(x, y)
            self.r[self:toIndex(x,y)] = r
            self.g[self:toIndex(x,y)] = g
            self.b[self:toIndex(x,y)] = b
            self.h[self:toIndex(x,y)] = h
        end
    end
    self.spriteBatch = love.graphics.newSpriteBatch(self.image)
    --delete image data in hope to free up memory
    self.heightMap = nil
    self.colorMap = nil
end

--terrain data to position
function terrain:toXY(n)
    local x = n % self.terrainWidth
    local y = (n - x) / self.terrainWidth
    return x + 1, y + 1
end
--position to terrain data
function terrain:toIndex(x, y)
    return (y - 1) * self.terrainWidth + (x - 1)
end

function terrain:update(dt)
    local dt = dt or love.timer.getDelta()
    local kd = love.keyboard.isDown
    self.lean = 0
    if kd("d") then
        self.angle = self.angle - 2 * dt
        self.lean = 1
    end
    if kd("a") then
        self.angle = self.angle + 2 * dt
        self.lean = -1
    end
    if kd("w") then
        self.x = self.x - 200 * ms(self.angle) * dt
        self.y = self.y - 200 * mc(self.angle) * dt
    end
    if kd("s") then
        self.x = self.x + 100 * ms(self.angle) * dt
        self.y = self.y + 100 * mc(self.angle) * dt
    end
    self:updateRender()
end

function terrain:updateRender()
    
    local sinphi = ms(self.angle)
    local cosphi = mc(self.angle)
    local yBuffer = {}
    for i = 0, self.renderWidth do
        yBuffer[i] = self.renderHeight
    end
    local dz = self.distanceStep
    local z = 0
    self.spriteBatch:clear()
    while z < self.distance do
        local cosz = cosphi * z
        local sinz = sinphi * z
        local pleftx = (-cosz - sinz) + self.x
        local plefty = (sinz - cosz) + self.y
        local prightx = (cosz - sinz) + self.x
        local prighty = (-sinz - cosz) + self.y
        local dx = (prightx - pleftx) / self.renderWidth
        local dy = (prighty - plefty) / self.renderWidth
        for i = 0, self.renderWidth do
            local x = mf((pleftx % self.terrainWidth) + 0.5)
            local y = mf((plefty % self.terrainWidth) + 0.5)
            local r = self.r[self:toIndex(x,y)] 
            local g = self.g[self:toIndex(x,y)] 
            local b = self.b[self:toIndex(x,y)] 
            local h = self.h[self:toIndex(x,y)] 
            local heightOnScreen = mf(((self.viewHeight - h * 256) / z * self.scaleHeight + self.horizon) + 0.5)
            local lean =  mf(((self.lean*(i/self.renderWidth-0.5) +0.5) * self.renderWidth / 9)+ 0.5)
            if heightOnScreen < yBuffer[i] then
                if z > self.visibility then
                    local opacity = (self.distance - z) / self.distance
                    self.spriteBatch:setColor(r,g,b, opacity)
                else
                    self.spriteBatch:setColor(r,g,b, 1)
                end
                local scaleY = yBuffer[i] - heightOnScreen + 1 
                self.spriteBatch:add( i,heightOnScreen + lean, nil, 1, scaleY )
                yBuffer[i] = heightOnScreen
            end
            pleftx = pleftx + dx 
            plefty = plefty + dy 
        end
        if z > 300 then dz = dz + 0.05 end
        z = z + dz
    end
end

function terrain:draw()
    love.graphics.draw(self.spriteBatch)
end

return terrain
