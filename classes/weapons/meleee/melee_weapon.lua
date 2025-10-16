local Weapon = require "classes.weapons.weapon"
local Vector = require "libs.hump.vector"

local MeleeWeapon = setmetatable({}, { __index = Weapon })
MeleeWeapon.__index = MeleeWeapon
MeleeWeapon.__name = "MeleeWeapon"

function MeleeWeapon.new(world, entity, opts)
    local self = setmetatable(Weapon.new(world, entity, opts), MeleeWeapon)

    self.width = opts and opts.width or 64
    self.height = opts and opts.height or 64

    self.hitbox = world:newRectangleCollider(self.entity.x, self.entity.y - self.height / 2, self.width, self.height)
    self.hitbox:setCollisionClass("PlayerMeleeAttack")
    self.hitbox:setFixedRotation(true)
    self.hitbox:setObject(self)
    self.hitbox:setSensor(true)
    self.hitbox:setActive(false)

    return self
end

function MeleeWeapon:getPosition()
    return self.hitbox:getPosition()
end

function MeleeWeapon:perform_attack(mouse_event)
    Weapon.perform_attack(self)
    self.hitbox:setActive(true)
end

function MeleeWeapon:update(dt)
    Weapon.update(self, dt)
    self.hitbox:setPosition(
        self.entity.x + (self.width * 0.75 *  self.entity.direction),
        self.entity.y - self.height / 2
    )

    if self.attack_duration <= 0 then
        self.hitbox:setActive(false)
    end
end

return MeleeWeapon
