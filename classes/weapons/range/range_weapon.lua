local Weapon = require "classes.weapons.weapon"
local Vector = require "libs.hump.vector"
local Bullet = require "classes.weapons.range.bullets"

local RangeWeapon = setmetatable({}, { __index = Weapon })
RangeWeapon.__index = RangeWeapon
RangeWeapon.__name = "RangeWeapon"

function RangeWeapon.new(world, entity, opts)
    local self = setmetatable(Weapon.new(world, entity, opts), RangeWeapon)
    self.width = opts and opts.width or 8
    self.max_cooldown = opts and opts.cooldown or 0.3
    self.height = opts and opts.height or 8
    self.bullet_speed = opts and opts.bullet_speed or 500
    self.bullets = {}

    return self
end

function RangeWeapon:perform_attack(mouse_event)
    if self.cooldown > 0 then return end
    self.cooldown = self.max_cooldown
    self.attack_duration = self.max_attack_duration
    self:spawn_bullet(mouse_event)
end

function RangeWeapon:spawn_bullet(mouse_event)
    local p_pos = Vector(self.entity.x, self.entity.y)
    local mouse_pos = Vector(mouse_event.x, mouse_event.y)
    local distance = (mouse_pos - p_pos):normalized()
    local bullet = {
        x = p_pos.x,
        y = p_pos.y,
        vx = distance.x * self.bullet_speed,
        vy = distance.y * self.bullet_speed,
        collider = self.world:newRectangleCollider(p_pos.x, p_pos.y, self.width, self.height)
    }
    table.insert(self.bullets, Bullet.new(bullet))
end

function RangeWeapon:draw()
    for i = #self.bullets, 1, -1 do
        self.bullets[i]:draw()
    end
end

function RangeWeapon:update(dt)
    Weapon.update(self, dt)
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        if bullet:is_dead() then
            table.remove(self.bullets, i)
            goto continue
        end
        bullet:update(dt)
        ::continue::
    end
end

return RangeWeapon
