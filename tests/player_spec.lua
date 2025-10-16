local Player = require "classes.player.init"

local function test_inicializacion()
    local player = Player.new(0, 0, world, camera)
end

describe("Player")
