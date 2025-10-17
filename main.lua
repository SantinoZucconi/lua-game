local Game = require("game")
local Player = require("classes.entities.player.init")
local love = require("love")
local Enemy = require("classes.entities.enemy.init")

local game = Game.new()
local player = Player.new(game.world, nil, {x = 200, y = 200, speed = 200, health = 100}, game.cam)
local enemy = Enemy.new(game.world, nil, player, {x = 300, y = 300, speed = 0})
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
