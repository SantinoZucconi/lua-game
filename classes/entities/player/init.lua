local InputComponent = require "classes.entities.components.input_component"
local PlayerSprites = require "classes.entities.player.sprites_2"
local RangeWeapon = require "classes.weapons.range.range_weapon"
local Entity = require "classes.entities.entity"

---@class Player
---@field x number
---@field y number
---@field health number
---@field speed number
---@field invincibility_time number
---@field components table<any>
---@field weapon Weapon
---@field state any
local Player = setmetatable({}, { __index = Entity })
Player.__index = Player
Player.__name = "Player"


---@param world any
---@param sprites any
---@param opts {x : number, y: number, health: number, speed: number, invincibility_time: number}
---@param camera any
---@return Entity|Player
function Player.new(world, sprites, opts, camera)
    local self = setmetatable(Entity.new(world, PlayerSprites, opts), Player)
    self:addComponent(InputComponent.new(self, camera))
    self.weapon = RangeWeapon.new(world, self)
    self.state = nil
    self:set_collision_class(self.__name)
    return self
end

function Player:perform_attack(mouse_event)
    print("performing attack!")
    self.weapon:perform_attack(mouse_event)
end

function Player:inflict_damage(enemy)
    self.weapon:inflict_damage(enemy)
end

return Player
