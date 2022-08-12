

local voxelspace = {
    _VERSION     = 'loveVoxelSpace v0.0.1',
    _DESCRIPTION = 'voxelspace render in lua for love2d',
    _URL         = 'http://foobar.page.or.repo.com',
    _LICENSE     = [[
    ... (license text, or name/url for long licenses)
    ]]
}

----------------------------------------------------------------------------------------------------------------------------------------
-- classic
-- Copyright (c) 2014, rxi
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
Object = {}
Object.__index = Object
function Object:new()
end
function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end
function Object:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end
function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end
function Object:__tostring()
  return "Object"
end
function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

-------------------------------------------------------------------------------------------------




local current_folder = (...):gsub('%.init$', '') 
voxelspace.terrain = require(current_folder .. '.terrain')
voxelspace.render = require(current_folder .. '.render')

return voxelspace