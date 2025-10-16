local love = require "love"
local MeleeWeapon = require "classes.weapons.melee_weapon"

local Sword = setmetatable({}, { __index = MeleeWeapon })
Sword.__index = Sword
Sword.__name = "Sword"

function Sword.new(world, entity, opts)
    local self = setmetatable(MeleeWeapon.new(world, entity, opts), Sword)
    return self
end

function Sword:draw()
    if self.attack_duration > 0 then
        love.graphics.setColor(1, 0, 0, 0.5)
        local x, y = self.hitbox:getPosition()
        local w, h = self.width, self.height
        love.graphics.rectangle("fill", x - w/2, y - h/2, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Sword:perform_attack()
    MeleeWeapon.perform_attack(self)
end

return Sword
