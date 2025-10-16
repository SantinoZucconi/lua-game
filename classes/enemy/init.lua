local Vector = require "libs.hump.vector"

local Enemy = {}
Enemy.__index = Enemy
Enemy.__name = "Enemy"

function Enemy.new(x, y, world)
    local self = setmetatable({}, Enemy)
    self.x, self.y = x, y
    self.w, self.h = 16, 16
    self.speed = 100
    self.health = 3
    self.currentSpeed = self.speed
    self.speedRecoveryTime = 0.5
    self.speedTimer = 0
    self.damage = 1
    self.invincibility_time = 0.3

    self.collider = world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass("Enemy")
    self.collider:setObject(self)
    self.collider:setFixedRotation(true)

    return self
end

function Enemy:decreaseSpeed()
    self.currentSpeed = self.speed * 0.3
    self.speedTimer = self.speedRecoveryTime
end

function Enemy:update(dt, player)
    local dx = player.x - self.x
    local dy = player.y - self.y
    local len = math.sqrt(dx*dx + dy*dy)
    if len > 0 then
        dx, dy = dx / len, dy / len
    end

    if self.speedTimer > 0 then
        self.speedTimer = self.speedTimer - dt
        if self.speedTimer <= 0 then
            self.currentSpeed = self.speed
        end
    end

    local velocity = {x = 0, y = 0}
    velocity.x = dx * self.currentSpeed
    velocity.y =  dy * self.currentSpeed

    if self.pushed and self.pushed.current_time < self.pushed.time then
        self.pushed.current_time = self.pushed.current_time + dt
        local ratio = dt / self.pushed.current_time
        velocity = velocity + Vector(self.pushed.x * ratio, self.pushed.y * ratio)
    else
        self.pushed = nil
    end

    self.collider:setLinearVelocity(velocity.x, velocity.y)
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.damaged and self.invincibility_time > 0 then
        self.invincibility_time = self.invincibility_time - dt
    else
        self.damaged = false
        self.invincibility_time = 0.3
    end
end

function Enemy:attack(player)
    local eBody = self.collider
    local px, py = player:getPosition()
    local ex, ey = eBody:getPosition()
    local dx, dy = px - ex, py - ey

    local len = math.sqrt(dx*dx + dy*dy)
    if len == 0 then len = 1 end
    dx, dy = dx / len, dy / len

    local pushStrength = 800
    local push_x = pushStrength * dx
    local push_y = pushStrength * dy
    local collision = { push_x = push_x , push_y = push_y }
    player:take_damage(self.damage, self)
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0) -- rojo
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1) -- reset color
end

function Enemy:takeDamage(amount, collision)
    if not self.damaged then
        self.damaged = true
        self.health = math.max(0, self.health - amount)
        if self.health == 0 then
            self:die()
        end
    end
    self.pushed = { x = collision.push_x, y = collision.push_y, time = 0.2, current_time = 0 }
end

function Enemy:die()
    self.collider:destroy()
end

function Enemy:is_dead()
    return self.health == 0
end

return Enemy
