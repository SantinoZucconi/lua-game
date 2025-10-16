local PhysicsComponent = require "classes.components.physics_component"
local AnimationComponent = require "classes.components.animation_component"
local InputComponent = require "classes.components.input_component"
local PlayerSprites = require "classes.player.sprites_2"
local RangeWeapon = require "classes.weapons.range_weapon"
local Weapon = require "classes.weapons.weapon"
local Sword = require "classes.weapons.swords.sword"

---@class Player
---@field x number
---@field y number
---@field health number
---@field speed number
---@field invincibility_time number
---@field components table<any>
---@field weapon Weapon
local Player = {}
Player.__index = Player
Player.__name = "Player"


---@param x number
---@param y number
---@param world any
---@param camera any
---@return Player
function Player.new(x, y, world, camera)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.health = 3
    self.speed = 200
    self.damaged = false
    self.weapon = RangeWeapon.new(world, self)
    self.invincibility_time = 0.1
    local physics_component = PhysicsComponent.new(self, world)
    local input_component = InputComponent.new(self, camera, physics_component)
    local animation_component = AnimationComponent.new(self, PlayerSprites.getSprites())
    self.components = {
        [InputComponent.__name] = input_component,
        [PhysicsComponent.__name] = physics_component,
        [AnimationComponent.__name] = animation_component,
    }
    return self
end

function Player:getPosition()
    return self.x, self.y
end
function Player:addComponent(component)
    component:init(self)
    self.components[component.__name] = component
end

function Player:take_damage(amount, collision)
    self.health = math.max(0, self.health - amount)
    self.damaged = true
    if self.health == 0 then
        print("Player died!")
    end
    for _, component in pairs(self.components) do
        if component.onDamage then component:onDamage(collision) end
    end
end

function Player:perform_attack(mouse_event)
    print("performing attack!")
    self.weapon:perform_attack(mouse_event)
end

function Player:inflict_damage(enemy)
    self.weapon:inflict_damage(enemy)
end

function Player:draw()
    self:draw_components()
    if self.weapon and self.weapon.draw then self.weapon:draw() end
end

function Player:draw_components()
    for _, component in pairs(self.components) do
        if component.draw then component:draw() end
    end
end

function Player:update(dt)
    if self.damaged and self.invincibility_time > 0 then
        self.invincibility_time = self.invincibility_time - dt
    else
        self.damaged = false
        self.invincibility_time = 0.3
    end
    if self.weapon then self.weapon:update(dt) end
    self:update_components(dt)
end

function Player:update_components(dt)
    for _, component in pairs(self.components) do
        if component.update then component:update(dt) end
    end
end

return Player
