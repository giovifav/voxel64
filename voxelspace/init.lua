

local voxelspace = {
    _VERSION     = 'loveVoxelSpace v0.0.1',
    _DESCRIPTION = 'voxelspace render in lua for love2d',
    _URL         = 'http://foobar.page.or.repo.com',
    _LICENSE     = [[
    ... (license text, or name/url for long licenses)
    ]]
}

local current_folder = (...):gsub('%.init$', '') 
voxelspace.terrain = require(current_folder .. '.terrain')
voxelspace.render = require(current_folder .. '.render')


return voxelspace