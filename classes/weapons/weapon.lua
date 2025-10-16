local Vector = require "libs.hump.vector"

---@class Weapon
local Weapon = {}
Weapon.__index = Weapon
Weapon.__name = "Weapon"

function Weapon.new(world, entity, opts)
    local self = setmetatable({}, Weapon)
    self.entity = entity
    self.world = world

    self.attack_duration = 0
    self.cooldown = 0

    self.damage = opts and opts.damage or 1
    self.max_cooldown = opts and opts.cooldown or 0.7
    self.max_attack_duration = opts and opts.attack_duration or 0.3
    self.push_strength = opts and opts.push_strength or 800

    return self
end

function Weapon:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end

    if self.attack_duration > 0 then
        self.attack_duration = self.attack_duration - dt
    end
end

function Weapon:perform_attack(mouse_event)
    if self.cooldown > 0 then return end
    self.cooldown = self.max_cooldown
    self.attack_duration = self.max_attack_duration
end

function Weapon:inflict_damage(enemy)
    enemy:take_damage(self.damage, {from = self, push_strength = self.push_strength})
end

return Weapon
