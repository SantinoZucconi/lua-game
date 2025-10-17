local IdleState = {}
IdleState.__index = IdleState

function IdleState.new(entity)
    local self = setmetatable({}, IdleState)
    self.entity = entity
    return self
end

function IdleState:can_execute(cmd)
    return true
end

function IdleState:on_command(cmd)
    if cmd.__name == "MoveCommand" then
        cmd:execute(self.entity.components["PhysicsComponent"])
    elseif cmd.__name == "AttackCommand" then
        cmd:execute(self.entity.components["AttackComponent"])
    end
end

return IdleState
