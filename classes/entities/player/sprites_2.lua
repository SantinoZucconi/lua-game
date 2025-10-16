local anim8 = require "libs.anim8"
local love = require "love"

local PlayerSprites = {}
PlayerSprites.__index = PlayerSprites
PlayerSprites.__name = "PlayerSprites"

function PlayerSprites.getSprites()
    local sprite_sheet = love.graphics.newImage("assets/platformer/herochar_sprites/herochar_spritesheet(new).png")
    local grid16 = anim8.newGrid(16, 16, sprite_sheet:getWidth(), sprite_sheet:getHeight())
    local grid32 = anim8.newGrid(32, 16, sprite_sheet:getWidth(), sprite_sheet:getHeight())

    local animation_state = {
        idle = {
            sprite = sprite_sheet,
            animation = anim8.newAnimation(grid16("1-4", 6), 0.2),
            width = 16,
            height = 16
        },
        run = {
            sprite = sprite_sheet,
            animation = anim8.newAnimation(grid16("1-6", 2), 0.2),
            width = 16,
            height = 16
        },
        charge = {
            sprite = sprite_sheet,
            animation = anim8.newAnimation(grid16("1-4", 4), 0.2),
            width = 32,
            height = 16
        },
        damage = {
            sprite = sprite_sheet,
            animation = anim8.newAnimation(grid16("1-3", 9), 0.2),
            width = 16,
            height = 16
        },
        roll = {
            sprite = sprite_sheet,
            animation = anim8.newAnimation(grid16("1-3", 10), 0.2),
            width = 16,
            height = 16
        }
    }

    return {
        states = animation_state,
        current = animation_state.idle
    }
end

return PlayerSprites
