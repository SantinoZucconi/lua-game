local sti = require "libs.sti"
local wf = require "libs.windfield"
local camera = require "libs.hump.camera"
local love = require "love"
local handleCollision = require "collision_manager"

local Game = {}
Game.__index = Game

function Game.new()
    love.graphics.setDefaultFilter("nearest", "nearest")
    local self = setmetatable({}, Game)
    self.cam = camera()
    self.gameMap = sti("maps/map_2.lua")

    self.world = wf.newWorld(0, 0, true)

    self.world:addCollisionClass("Player")
    self.world:addCollisionClass("Enemy")
    self.world:addCollisionClass("Wall")
    self.world:addCollisionClass("PlayerMeleeAttack", { ignores = { "Player", "Wall" } })
    self.world:addCollisionClass("PlayerRangeAttack", { ignores = { "Player" } })

    local walls = {}
    if self.gameMap.layers["Walls"] then
        for i, obj in pairs(self.gameMap.layers["Walls"].objects) do
            local wall = self.world:newRectangleCollider(
                obj.x,
                obj.y,
                obj.width,
                obj.height
            )
            wall:setType("static")
            wall:setCollisionClass("Wall")
            table.insert(walls, wall)
        end
    end
    self.entities = {}
    self.player = nil
    self.world:setCallbacks(
        function(a, b, coll) handleCollision(a:getUserData(), b:getUserData(), coll) end, -- beginContact
        nil, -- endContact
        nil, -- preSolve
        nil  -- postSolve
    )

    return self
end

function Game:add(entity)
    if entity.__name == "Player" then
        self.player = entity
    end
    table.insert(self.entities, entity)
end

function Game:update(dt)
    self.world:update(dt)
    self:update_camera()
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        if e.is_dead and e:is_dead() then
            e:destroy()
            table.remove(self.entities, i)
        else
            if e.update then e:update(dt) end
        end
    end
end

function Game:update_camera()
    self.cam:lookAt(self.player.x, self.player.y)

    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    if self.cam.x < window_width / 2 then
        self.cam.x = window_width / 2
    end
    if self.cam.y < window_height / 2 then
        self.cam.y = window_height / 2
    end

    local map_width = self.gameMap.width * self.gameMap.tilewidth
    local map_height = self.gameMap.height * self.gameMap.tileheight


    if self.cam.x > (map_width - window_width / 2) then
        self.cam.x = (map_width - window_width / 2)
    end
    if self.cam.y > (map_height - window_height / 2) then
        self.cam.y = (map_height - window_height / 2)
    end
end

function Game:draw()
    self.cam:attach()
        self.gameMap:drawLayer(self.gameMap.layers[1])
        self.gameMap:drawLayer(self.gameMap.layers[2])
        for _, e in ipairs(self.entities) do
            e:draw()
        end
        --self.world:draw() -- see the colliders
    self.cam:detach()
    local player_health = string.format("HP: %d", self.player.health)
    love.graphics.print(player_health, 0, 5)
    love.graphics.print(player_health, love.graphics.getWidth() - 5, 5)
end

return Game
