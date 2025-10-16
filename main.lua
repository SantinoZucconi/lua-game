local Game = require("game")
local Player = require("classes.player.init")
local love = require("love")
local Enemy = require("classes.enemy.test")

local game = Game.new()
local player = Player.new(200, 200, game.world, game.cam)
local enemy = Enemy.new(300, 300, player, game.world)
function love.load()
    game:add(player)
    game:add(enemy)
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
