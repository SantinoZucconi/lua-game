local Vector = require "libs.hump.vector"

local PhysicsComponent = {}
PhysicsComponent.__index = PhysicsComponent
PhysicsComponent.__name = "PhysicsComponent"

function PhysicsComponent.new(entity, world, opts)
    local self = setmetatable({}, PhysicsComponent)
    self.entity = entity
    self.world = world
    self.speed = opts and opts.speed or 200
    self.pushed = self.pushed or nil
    self.velocity = Vector(0, 0)

    if not self.collider then
        self.collider = world:newRectangleCollider(self.entity.x, self.entity.y, 16, 16)
        self.collider:setFixedRotation(true)
        self.collider:setObject(entity)
    end
    self.command_queue = {}

    return self
end

function PhysicsComponent:set_collision_class(class)
    self.collider:setCollisionClass(class)
end

function PhysicsComponent:enqueue(command)
    table.insert(self.command_queue, command)
end

function PhysicsComponent:pop()
    return table.remove(self.command_queue, 1)
end

function PhysicsComponent:update(dt)
    self.entity.moving = false
    local command = self:pop()
    if command then command:execute(self) end
    if self.pushed and self.pushed.current_time < self.pushed.time then
        self.pushed.current_time = self.pushed.current_time + dt
        local ratio = dt / self.pushed.current_time
        self.velocity = self.velocity + Vector(self.pushed.x * ratio, self.pushed.y * ratio)
    else
        self.pushed = nil
    end

    self.collider:setLinearVelocity(self.velocity.x, self.velocity.y)
    self.entity.x, self.entity.y = self.collider:getPosition()
end

function PhysicsComponent:move(direction)
    local velocity = direction * self.speed
    self.entity.moving = velocity:len() > 0

    if direction.x > 0 then
        self.entity.direction = 1
    elseif direction.x < 0 then
        self.entity.direction = -1
    end
    self.collider:setLinearVelocity(velocity.x, velocity.y)
    self.velocity = velocity
    self.entity.x, self.entity.y = self.collider:getPosition()
end

function PhysicsComponent:getPosition()
    return self.collider:getPosition()
end

function PhysicsComponent:destroy()
    self.collider:destroy()
end

function PhysicsComponent:onDamage(collition)
    local fx, fy = collition.from:getPosition()
    local tx, ty = self.entity:getPosition()
    local f_vector = Vector(fx, fy)
    local t_vector = Vector(tx, ty)
    local direction = (t_vector - f_vector):normalized()

    local push_x = collition.push_strength * direction.x
    local push_y = collition.push_strength * direction.y

    self.pushed = { x = push_x, y = push_y, time = 0.3, current_time = 0 }
end

return PhysicsComponent
