
local current_folder = (...):gsub('%.[^%.]+$', '')
local Object = require(current_folder .. '.oop')



local render = Object:extend()
--make useful functions local for speed
local ms = math.sin
local mc = math.cos
local mf = math.floor

function render:new(terrain)
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
    self.distanceStep = 1
    self.terrain = terrain
    self.lean = 0
    -- base 1  pixel image
    local img = love.image.newImageData(1, 1)
    img:setPixel(0, 0, 1, 1, 1, 1)
    img = love.graphics.newImage(img)
    -- base 1  pixel image for background
    local backgroundImage = love.image.newImageData(1, 1)
    backgroundImage:setPixel(0, 0, 0, 0, 0, 1)
    backgroundImage = love.graphics.newImage(backgroundImage)
    self.spriteBatch = love.graphics.newSpriteBatch(img)
    self.backgroundBatch = love.graphics.newSpriteBatch(backgroundImage)
end

function render:update(dt)
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

function render:updateRender()
    local sinphi = ms(self.angle)
    local cosphi = mc(self.angle)
    local buffer = {}
    for i = 0, self.renderWidth do
        buffer[i] = self.renderHeight
    end
    local dz = self.distanceStep
    local z = 0
    self.spriteBatch:clear()
    self.backgroundBatch:clear()
    while z < self.distance do
        local cosz = cosphi * z
        local sinz = sinphi * z

        local pleftx = (-cosz - sinz) + self.x
        local plefty = (sinz - cosz) + self.y
        local prightx = (cosz - sinz) + self.x
        local prighty = (-sinz - cosz) + self.y
        local dx = (prightx - pleftx) / self.renderWidth
        local dy = (prighty - plefty) / self.renderWidth
        for i = 0, self.renderWidth-1 do
            local x = mf((pleftx % self.terrain.width) + 0.5)
            local y = mf((plefty % self.terrain.width) + 0.5)
            local r, g, b = self.terrain:getColor(x,y)
            local h = self.terrain:getH(x,y)
            local heightOnScreen = mf(((self.viewHeight - h * 256) / z * self.scaleHeight + self.horizon) + 0.5)
            local lean = mf(((self.lean * (i / self.renderWidth - 0.5) + 0.5) * self.renderWidth / 9) + 0.5)
            local heightLean = heightOnScreen + lean
            if heightOnScreen < buffer[i] then
                local scaleY = buffer[i] - heightOnScreen + 1
                if z > self.visibility then
                    local opacity = (self.distance - z) / self.distance
                    self.backgroundBatch:add(i, heightLean, nil, 1, scaleY)
                    self.spriteBatch:setColor(r, g, b, opacity)
                    self.spriteBatch:add(i, heightLean, nil, 1, scaleY)
                else
                    self.spriteBatch:setColor(r, g, b, 1)
                    self.spriteBatch:add(i, heightLean, nil, 1, scaleY)
                end
                buffer[i] = heightOnScreen
            end
            pleftx = pleftx + dx
            plefty = plefty + dy
        end
        if z > 300 then dz = dz + 0.05 end
        z = z + dz
        end
end

function render:draw()
    love.graphics.draw(self.backgroundBatch)
    love.graphics.draw(self.spriteBatch)
end

return render
