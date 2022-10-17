Helper.Spell = {}

require 'helper/spells/flame'
require 'helper/spells/missile'
require 'helper/spells/damage_circle'
require 'helper/spells/laser'
require 'helper/spells/damage_line'
require 'helper/spells/spread_laser'
require 'helper/spells/spread_missile'
require 'helper/spells/damage_arc'
require 'helper/spells/safety_dance'
require 'helper/spells/sweep'
require 'helper/spells/brust'
require 'helper/spells/bomb'

Helper.Spell.spells = {
    Helper.Spell.SpreadMissile,
    Helper.Spell.Missile, 
    Helper.Spell.Laser, 
    Helper.Spell.Flame,
    Helper.Spell.DamageCircle, 
    Helper.Spell.DamageLine,
    Helper.Spell.DamageArc,
    Helper.Spell.SafetyDance,
    Helper.Spell.Sweep,
    Helper.Spell.Bomb,
    Helper.Spell.Burst
}

function Helper.Spell:can_shoot(spell)
    if Helper.Time.time - spell.start_aim_time > spell.cast_time then
        return true
    else
        return false
    end
end

function Helper.Spell:get_nearest_target(unit, include_list)
    if Helper.Unit.flagged_enemy ~= -1 then
        return Helper.Unit.flagged_enemy
    end

    include_list = include_list or {}

    local unit_list = Helper.Unit:get_list(not unit.is_troop)
    if #unit_list > 0 then
        local target = {}
        local distancemin = 100000000

        local globalTarget = nil
        if main and main.current and main.current.targetedEnemy then
            globalTarget = main.current.targetedEnemy
        end

        --check global target first
        if is_in_list(include_list, globalTarget) and Helper.Geometry:distance(unit.x, unit.y, globalTarget.x, globalTarget.y) then
            return globalTarget
        end

        for _, value in ipairs(unit_list) do
            if Helper.Geometry:distance(unit.x, unit.y, value.x, value.y) < distancemin and (#include_list == 0 or is_in_list(include_list, value)) then
                distancemin = Helper.Geometry:distance(unit.x, unit.y, value.x, value.y)
                target = value
            end
        end
        return target
    else
        return -1
    end
end

function Helper.Spell:get_nearest_target_from_point(x, y, target_is_troop)
    local unit = {
        x = x,
        y = y,
        is_troop = not target_is_troop
    }

    return self:get_nearest_target(unit)
end

function Helper.Spell:get_nearest_least_targeted(unit, range)
    if Helper.Unit.flagged_enemy ~= -1 then
        return Helper.Unit.flagged_enemy
    end
    
    local target_list = {}
    for i, value in ipairs(Helper.Unit:get_list(not unit.is_troop)) do
        if Helper.Geometry:distance(unit.x, unit.y, value.x, value.y) <= range then
            table.insert(target_list, value)
        end
    end

    local targeted_min = 9999
    for i, value in ipairs(target_list) do
        if #value.targeted_by < targeted_min then
            targeted_min = #value.targeted_by
        end
    end

    local least_targeted_units = {}
    for i, value in ipairs(target_list) do
        if #value.targeted_by == targeted_min then
            table.insert(least_targeted_units, value)
        end
    end

    local globalTarget = nil
    if main and main.current and main.current.targetedEnemy then
        globalTarget = main.current.targetedEnemy
        table.insert(least_targeted_units, globalTarget)
    end

    return Helper.Spell:get_nearest_target(unit, least_targeted_units)
end

function Helper.Spell:claimed_target_is_in_range(unit, range)
    if unit.have_target and Helper.Geometry:distance(unit.x, unit.y, unit.claimed_target.x, unit.claimed_target.y) <= range then
        return true
    end

    return false
end

function Helper.Spell:there_is_target_in_range(unit, range)
    for i, target in ipairs(Helper.Unit:get_list(not unit.is_troop)) do
        if Helper.Geometry:distance(unit.x, unit.y, target.x, target.y) < range then
            return true
        end
    end

    return false
end