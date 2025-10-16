local MoveCommand = {}
MoveCommand.__index = MoveCommand
MoveCommand.__name = "MoveCommand"

function MoveCommand.new(direction)
    local self = setmetatable({}, MoveCommand)
    self.direction = direction or { x = 0, y = 0 }
    return self
end

function MoveCommand:execute(physics_component)
    physics_component:move(self.direction)
end

return MoveCommand
