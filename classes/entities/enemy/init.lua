local AIComponent = require "classes.entities.components.ai_component"
local PlayerSprites = require "classes.entities.player.sprites"
local RangeWeapon = require "classes.weapons.range.range_weapon"
local Entity = require "classes.entities.entity"

---@class Enemy
---@field x number
---@field y number
---@field health number
---@field speed number
---@field invincibility_time number
---@field components table<any>
---@field damage number
---@field state any
local Enemy = setmetatable({}, { __index = Entity })
Enemy.__index = Enemy
Enemy.__name = "Enemy"


---@param world any
---@param sprites any
---@param player Player
---@param opts {x : number, y: number, health: number, speed: number, invincibility_time: number}
---@return Entity|Enemy
function Enemy.new(world, sprites, player, opts)
    local self = setmetatable(Entity.new(world, PlayerSprites, opts), Enemy)
    self:addComponent(AIComponent.new(self, player))
    self.damage = 1
    self.state = nil
    self:set_collision_class(self.__name)
    return self
end

function Enemy:inflict_damage(player)
    player:take_damage(self.damage, {from = self, push_strength = 800})
end

return Enemy
