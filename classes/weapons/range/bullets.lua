local love = require "love"
local Bullet = {}
Bullet.__index = Bullet
Bullet.__name = "Bullet"

function Bullet.new(bullet_table)
    local self = setmetatable({}, Bullet)
    self.x, self.y = bullet_table.x, bullet_table.y
    self.vx, self.vy = bullet_table.vx, bullet_table.vy
    self.speed = bullet_table.speed
    self.damage = bullet_table.damage
    self.owner = bullet_table.owner
    self.dead = false

    self.collider = bullet_table.collider
    self.collider:setCollisionClass("PlayerRangeAttack")
    self.collider:setFixedRotation(true)
    self.collider:setObject(self)

    return self
end

function Bullet:getPosition()
    return self.x, self.y
end
function Bullet:is_dead()
    return self.dead
end

function Bullet:update(dt)
    self.collider:setLinearVelocity(self.vx, self.vy)
    self.x, self.y = self.collider:getPosition()
    -- TODO: Cambiar a algo mas dinamico
    if self.x < 0 or self.x > 2000 then
        self.dead = true
        self.collider:destroy()
    end
end

function Bullet:inflict_damage(enemy)
    if enemy then enemy:take_damage(self.damage, {from = self, push_strength = 10}) end
    self.dead = true
    self.collider:destroy()
end

function Bullet:draw()
    if self.dead then return end
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", self.x - 4, self.y - 4, 8, 8)
    love.graphics.setColor(1, 1, 1)
end

return Bullet
