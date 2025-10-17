local InputComponent = require "classes.entities.components.input_component"
local PlayerSprites = require "classes.entities.player.sprites_2"
local Entity = require "classes.entities.entity"
local IdleState = require "classes.entities.states.idle_state"

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
    self:add_component(InputComponent.new(self, camera))
    self.state = IdleState.new(self)
    self:set_collision_class(self.__name)
    return self
end

return Player
