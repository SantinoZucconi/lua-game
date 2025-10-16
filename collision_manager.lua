local rules = {
    Player_Enemy = function(player, enemy, coll)
        enemy:inflict_damage(player)
    end,
    PlayerMeleeAttack_Enemy = function(player, enemy, coll)
        player:inflict_damage(enemy)
    end,
    PlayerRangeAttack_Enemy = function(player, enemy, coll)
        player:inflict_damage(enemy)
    end,
    PlayerRangeAttack_Wall = function(player, enemy, coll)
        player:inflict_damage(enemy)
    end
}

function handleCollision(a, b, coll)
    if not a or not b then return end
    print(a.collision_class , b.collision_class)
    local aClass, bClass = a.collision_class, b.collision_class
    local key1 = aClass .. "_" .. bClass
    local key2 = bClass .. "_" .. aClass

    if rules[key1] then
        rules[key1](a.object, b.object, coll)
    elseif rules[key2] then
        rules[key2](b.object, a.object, coll)
    end
end

function handlePostCollision(a, b, coll)
    local aClass, bClass = a.collision_class, b.collision_class
    local key1 = aClass .. "_" .. bClass
    local key2 = bClass .. "_" .. aClass

    if rules[key1] then
        rules[key1](a.object, b.object, coll)
    elseif rules[key2] then
        rules[key2](b.object, a.object, coll)
    end
end

return handleCollision
