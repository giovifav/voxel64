local current_folder = (...):gsub('%.[^%.]+$', '')
local Object = require(current_folder .. '.oop')

local terrain = Object:extend()

function terrain:new(size)
    self.map = love.graphics.newImage(love.image.newImageData(size, size))
    self.lights = love.graphics.newShader(current_folder .. "/shaders/lights.glsl")
    self.generator = love.graphics.newShader(current_folder .. "/shaders/generator.glsl")
    local biome = love.graphics.newImage(current_folder .. "/assets/biome_2.png")
    self.generator:send("biome", biome)
    self.canvas = love.graphics.newCanvas(size,size)
    local density = size / 600
    love.math.setRandomSeed(os.time())
    for i = 1, love.math.random(100), 1 do
        love.math.random()
    end
    local x, y = love.math.random(5000),love.math.random(5000)
    self.heightMap = love.image.newImageData(size, size)
    self.colorMap  = self:generateTerrain(x,y,density)
    local function generateImages(x, y, r, g, b, a)
        self.heightMap:setPixel(x,y,a,a,a,1)
        a = 1
        return r,g,b,a
    end
    self.colorMap:mapPixel(generateImages)
    self.width = self.heightMap:getWidth() - 1
    --array for each color + altitude-
    --four tables seems faster than 1 array of tables
    -- faster then unpack({r,g,b,h})
    self.r = {}
    self.g = {}
    self.b = {}
    self.h = {}
    --fill tables with every pixel of the color map  + altitude
    for x = 0, self.colorMap:getWidth() - 1 do
        for y = 0, self.colorMap:getHeight() - 1 do
            local r, g, b = self.colorMap:getPixel(x, y)
            local h = self.heightMap:getPixel(x, y)
            self.r[self:toIndex(x, y)] = r
            self.g[self:toIndex(x, y)] = g
            self.b[self:toIndex(x, y)] = b
            self.h[self:toIndex(x, y)] = h
        end
    end
        --delete image data in hope to free up memory
        self.heightMap = nil
        self.colorMap = nil
end

local function shaderRender(img, shader)
    local w,h = img:getDimensions()
    local canvas = love.graphics.newCanvas(w,h)
	canvas:renderTo(function()
		love.graphics.clear(1,0,0,1)
		love.graphics.setShader(shader)
			love.graphics.setBlendMode("replace", "premultiplied")
			love.graphics.draw(img,0,0)
		love.graphics.setShader()
	end)
	love.graphics.setBlendMode("alpha")
	return canvas:newImageData()
end

function terrain:generateTerrain(x,y,dens)
	self.generator:send("dens", dens or 1)
	self.generator:send("off", {x,y})
	local data = shaderRender(self.canvas, self.generator)
	self.lights:send("sun", {0.5, 0.0, 0.5})
	self.lights:send("preci", 0.01)
	local data = shaderRender(love.graphics.newImage(data), self.lights)
	return data
end

function terrain:draw()
    love.graphics.draw(self.colorMap)
end

--terrain data to position
function terrain:toXY(n)
    local x = n % self.width
    local y = (n - x) / self.width
    return x + 1, y + 1
end

--position to terrain data
function terrain:toIndex(x, y)
    return (y - 1) * self.width + (x - 1)
end

function terrain:getColor(x, y)
    return self.r[self:toIndex(x, y)] , self.g[self:toIndex(x, y)] , self.b[self:toIndex(x, y)] , 1
end

function terrain:getR(x,y)
    
    return self.r[self:toIndex(x, y)] 
end

function terrain:getG(x,y)
    return self.g[self:toIndex(x, y)] 
end

function terrain:getB(x,y)
    return self.b[self:toIndex(x, y)] 
end

function terrain:getH(x,y)
    return self.h[self:toIndex(x, y)] 
end


return terrain