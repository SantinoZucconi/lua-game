local MoveCommand = require "classes.entities.commands.move"
local AttackCommand = require "classes.entities.commands.attack"
local love = require "love"
local Vector = require "libs.hump.vector"

local InputComponent = {}
InputComponent.__index = InputComponent
InputComponent.__name = "InputComponent"

function InputComponent.new(entity, camera)
    local self = setmetatable({}, InputComponent)
    self.entity = entity
    self.camera = camera
    self.__name = InputComponent.__name
    return self
end

function InputComponent:update(dt)
    local dv_x, dv_y = 0, 0
    if love.keyboard.isDown("a") then dv_x = -1 end
    if love.keyboard.isDown("d") then dv_x = 1 end
    if love.keyboard.isDown("w") then dv_y = -1 end
    if love.keyboard.isDown("s") then dv_y = 1 end
    if love.mouse.isDown(1) then
        local mouse_x, mouse_y = love.mouse:getPosition()
        local world_x, world_y = self.camera:worldCoords(mouse_x, mouse_y)
        local mouse_event = { x = world_x, y = world_y }
        self.entity.state:on_command(AttackCommand.new(mouse_event))
    end
    local direction = Vector(dv_x, dv_y)
    self.entity.state:on_command(MoveCommand.new(direction))
end

return InputComponent
