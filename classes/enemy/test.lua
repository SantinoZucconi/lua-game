local PhysicsComponent = require "classes.components.physics_component"
local AnimationComponent = require "classes.components.animation_component"
local AIComponent = require "classes.components.ai_component"
local PlayerSprites = require "classes.player.sprites"
local RangeWeapon = require "classes.weapons.range_weapon"

local Enemy = {}
Enemy.__index = Enemy
Enemy.__name = "Enemy"

function Enemy.new(x, y, player, world)
    local self = setmetatable({}, Enemy)
    self.x = x
    self.y = y
    self.health = 3
    self.damage = 1
    self.speed = 50
    self.damaged = false
    self.weapon = RangeWeapon.new(world, self)
    self.invincibility_time = 0.1

    local physics_component = PhysicsComponent.new(self, world, { speed = 100 })
    local ai_component = AIComponent.new(self, player, physics_component)
    local animation_component = AnimationComponent.new(self, PlayerSprites.getSprites())

    self.components = {
        [AIComponent.__name] = ai_component,
        [PhysicsComponent.__name] = physics_component,
        [AnimationComponent.__name] = animation_component,
    }
    return self
end

function Enemy:getPosition()
    return self.x, self.y
end
function Enemy:addComponent(component)
    component:init(self)
    self.components[component.__name] = component
end

function Enemy:take_damage(amount, collision)
    self.health = math.max(0, self.health - amount)
    self.damaged = true
    if self.health == 0 then
        print("Enemy died!")
    end
    for _, component in pairs(self.components) do
        if component.onDamage then component:onDamage(collision) end
    end
end

function Enemy:perform_attack(mouse_event)
    self.weapon:perform_attack(mouse_event)
end

function Enemy:inflict_damage(player)
    player:take_damage(self.damage, {from = self, push_strength = 800})
end

function Enemy:is_dead()
    return self.healt == 0
end

function Enemy:destroy()
end
function Enemy:draw()
    self:draw_components()
    if self.weapon and self.weapon.draw then self.weapon:draw() end
end

function Enemy:draw_components()
    for _, component in pairs(self.components) do
        if component.draw then component:draw() end
    end
end

function Enemy:update(dt)
    if self.damaged and self.invincibility_time > 0 then
        self.invincibility_time = self.invincibility_time - dt
    else
        self.damaged = false
        self.invincibility_time = 0.3
    end
    if self.weapon then self.weapon:update(dt) end
    self:update_components(dt)
end

function Enemy:update_components(dt)
    for _, component in pairs(self.components) do
        if component.update then component:update(dt) end
    end
end

return Enemy
