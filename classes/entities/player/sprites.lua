local anim8 = require "libs.anim8"
local love = require "love"

local PlayerSprites = {}
PlayerSprites.__index = PlayerSprites
PlayerSprites.__name = "PlayerSprites"

function PlayerSprites.getSprites()
    local sprites = {
        idle   = love.graphics.newImage("assets/Blue_witch/idle.png"),
        run    = love.graphics.newImage("assets/Blue_witch/run.png"),
        charge = love.graphics.newImage("assets/Blue_witch/charge.png"),
        damage = love.graphics.newImage("assets/Blue_witch/damage.png"),
    }

    local idleGrid = anim8.newGrid(
        sprites.idle:getWidth(),
        sprites.idle:getHeight() / 6,
        sprites.idle:getWidth(),
        sprites.idle:getHeight()
    )

    local runGrid = anim8.newGrid(
        sprites.run:getWidth(),
        sprites.run:getHeight() / 8,
        sprites.run:getWidth(),
        sprites.run:getHeight()
    )

    local chargeGrid = anim8.newGrid(
        sprites.charge:getWidth(),
        sprites.charge:getHeight() / 5,
        sprites.charge:getWidth(),
        sprites.charge:getHeight()
    )

    local damageGrid = anim8.newGrid(
        sprites.damage:getWidth(),
        sprites.damage:getHeight() / 3,
        sprites.damage:getWidth(),
        sprites.damage:getHeight()
    )

    local animation_state = {
        idle = {
            sprite = sprites.idle,
            animation = anim8.newAnimation(idleGrid(1, '1-6'), 0.2),
            width = sprites.idle:getWidth(),
            height = sprites.idle:getHeight() / 6
        },
        run = {
            sprite = sprites.run,
            animation = anim8.newAnimation(runGrid(1, '1-8'), 0.08),
            width = sprites.run:getWidth(),
            height = sprites.run:getHeight() / 8
        },
        charge = {
            sprite = sprites.charge,
            animation = anim8.newAnimation(chargeGrid(1, '1-5'), 0.07),
            width = sprites.charge:getWidth(),
            height = sprites.charge:getHeight() / 5
        },
        damage = {
            sprite = sprites.damage,
            animation = anim8.newAnimation(damageGrid(1, '1-3'), 0.15),
            width = sprites.damage:getWidth(),
            height = sprites.damage:getHeight() / 3
        }
    }

    return {
        states = animation_state,
        current = animation_state.idle
    }
end

return PlayerSprites
