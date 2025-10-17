local AttackCommand = {}
AttackCommand.__index = AttackCommand
AttackCommand.__name = "AttackCommand"

function AttackCommand.new(mouse_event)
    local self = setmetatable({}, AttackCommand)
    self.mouse_event = mouse_event
    return self
end

function AttackCommand:execute(attack_component)
    attack_component:perform_attack(self.mouse_event)
end

return AttackCommand
