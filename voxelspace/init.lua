

local voxelspace = {
    _VERSION     = 'loveVoxelSpace v0.0.1',
    _DESCRIPTION = 'voxelspace render in lua for love2d',
    _URL         = 'http://foobar.page.or.repo.com',
    _LICENSE     = [[
    ... (license text, or name/url for long licenses)
    ]]
}

local current_folder = (...):gsub('%.init$', '') 
voxelspace.imgMapsTerrain = require(current_folder .. '.imgMapsTerrain')
voxelspace.shaderGenTerrain = require(current_folder .. '.shaderGenTerrain')
voxelspace.render = require(current_folder .. '.render')


return voxelspace