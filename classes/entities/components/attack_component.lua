local RangeWeapon = require "classes.weapons.range.range_weapon"
local AttackComponent = {}
AttackComponent.__index = AttackComponent
AttackComponent.__name = "AttackComponent"

function AttackComponent.new(entity, world)
    local self = setmetatable({}, AttackComponent)
    self.entity = entity
    self.world = world
    self.weapon = RangeWeapon.new(world, entity)
    return self
end

function AttackComponent:update(dt)
    self.weapon:update(dt)
end

function AttackComponent:draw(dt)
    self.weapon:draw(dt)
end

function AttackComponent:set_weapon(weapon)
    self.weapon = weapon
end

function AttackComponent:perform_attack(mouse_event)
    self.weapon:perform_attack(mouse_event)
end

function AttackComponent:inflict_damage(entity)
    self.weapon:inflict_damage(entity)
end

return AttackComponent
