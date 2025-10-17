local PhysicsComponent = require "classes.entities.components.physics_component"
local AttackComponent = require "classes.entities.components.attack_component"
local AnimationComponent = require "classes.entities.components.animation_component"

---@class Entity
---@field x number
---@field y number
---@field health number
---@field speed number
---@field max_invincibility_time number
---@field invincibility_time number
---@field components table<any>
---@field state any
local Entity = {}
Entity.__index = Entity
Entity.__name = "Entity"


---@param world any
---@param sprites any
---@param opts {x : number, y: number, health: number, speed: number, invincibility_time: number}
---@return Entity
function Entity.new(world, sprites, opts)
    local self = setmetatable({}, Entity)
    self.x = opts and opts.x or 0
    self.y = opts and opts.y or 0
    self.health = opts and opts.health or 3
    self.speed = opts and opts.speed or 3
    self.max_invincibility_time = opts and opts.invincibility_time or 1
    self.invincibility_time = 0

    self.damaged = false

    local physics_component = PhysicsComponent.new(self, world, opts)
    local attack_component = AttackComponent.new(self, world)
    local animation_component = AnimationComponent.new(self, sprites.getSprites())

    self.components = {
        [PhysicsComponent.__name] = physics_component,
        [AttackComponent.__name] = attack_component,
        [AnimationComponent.__name] = animation_component,
    }
    return self
end

function Entity:getPosition()
    return self.x, self.y
end

function Entity:add_component(component)
    self.components[component.__name] = component
end

function Entity:add_command(command)
    self.state:add_command(command)
end

function Entity:take_damage(amount, collision)
    self.health = math.max(0, self.health - amount)
    self.damaged = true
    if self.health == 0 then
        print("Entity died!")
    end
    for _, component in pairs(self.components) do
        if component.onDamage then component:onDamage(collision) end
    end
end

function Entity:is_dead()
    return self.health == 0
end

function Entity:destroy()
    for _, component in pairs(self.components) do
        if component.destroy then component:destroy() end
    end
end

function Entity:set_collision_class(class)
    self.components["PhysicsComponent"]:set_collision_class(class)
end

------------------------------------------------- DRAW ------------------------------------------------------------------

function Entity:draw()
    self:draw_components()
end

function Entity:draw_components()
    for _, component in pairs(self.components) do
        if component.draw then component:draw() end
    end
end

------------------------------------------------- UPDATE ----------------------------------------------------------------

function Entity:update(dt)
    if self.damaged and self.invincibility_time > 0 then
        self.invincibility_time = self.invincibility_time - dt
    else
        self.damaged = false
        self.invincibility_time = self.max_invincibility_time
    end
    self:update_components(dt)
end

function Entity:update_components(dt)
    for _, component in pairs(self.components) do
        if component.update then component:update(dt) end
    end
end

return Entity
