local MoveCommand = require "classes.entities.commands.move"
local Vector = require "libs.hump.vector"

local AIComponent = {}
AIComponent.__index = AIComponent
AIComponent.__name = "AIComponent"

function AIComponent.new(entity, player)
    local self = setmetatable({}, AIComponent)
    self.entity = entity
    self.player = player
    self.physics = self.entity.components["PhysicsComponent"]
    return self
end

function AIComponent:update(dt)
    local dx = self.player.x - self.entity.x
    local dy = self.player.y - self.entity.y

    local velocity = Vector(dx, dy):normalized()
    self.physics:enqueue(MoveCommand.new(velocity))
end

function AIComponent:decreaseSpeed()
    self.current_speed = self.entity.speed * 0.3
    self.speed_timer = self.speed_recovery_time
end

function AIComponent:onDamage(dt)
end
return AIComponent
