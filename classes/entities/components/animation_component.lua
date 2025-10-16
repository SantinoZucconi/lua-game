local AnimationComponent = {}
AnimationComponent.__index = AnimationComponent
AnimationComponent.__name = "AnimationComponent"

function AnimationComponent.new(entity, animation_table)
    local self = setmetatable({}, AnimationComponent)
    if not entity then
        error("No existe la entidad")
    end
    self.entity = entity
    self.entity.direction = 1
    self.states = animation_table.states
    self.current = animation_table.current
    return self
end

function AnimationComponent:draw()
    local scaleX = 2 * self.entity.direction
    local scaleY = 2
    local ox = self.current.width / 2
    local oy = self.current.height * 0.8
    local cx, cy = self.entity.x, self.entity.y

    self.current.animation:draw(
        self.current.sprite,
        cx, cy,
        0,
        scaleX, scaleY,
        ox, oy
    )
end

function AnimationComponent:onDamage()
    self:changeAnimation("damage")
    self.current.animation:gotoFrame(1)
end

function AnimationComponent:changeAnimation(name)
    local newState = self.states[name]
    if not newState then
        error("Animación no encontrada: " .. tostring(name))
        return
    end
    if self.current ~= newState then
        self.current = newState
    end
end

function AnimationComponent:update(dt)
    self.current.animation:update(dt)
    if not self.entity.damaged then
        if self.entity.moving then
            self:changeAnimation("run")
        else
            self:changeAnimation("idle")
        end
        if self.entity.weapon and self.entity.weapon.attack_duration > 0 then
            self:changeAnimation("charge")
        end
    end
end

return AnimationComponent
