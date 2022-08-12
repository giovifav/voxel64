--- the terrain class generate terrain data info with color map and height map

local terrain = Object:extend()
function terrain:new(colormap, heighmap)
    self.colorMap = love.image.newImageData(colormap)
    self.heightMap = love.image.newImageData(heighmap)
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
