local easing_functions = {}
easing_functions.linear = function(t) return t end
easing_functions.quad = function(t) return t*t end


local tweens = {}
local M = {}

function M.new_tween(duration, object, field, start_value, end_value, easing_fn)
    if not object[field] and type(field) ~= "function" then
        log.warn("Not tweening non-existent field [%s]", field)
        return
    end

    -- don't tween if it's not necessary. this lets us be lazy when calling this function
    if object[field] and object[field] == end_value then return end

    local tween = {}
    tween.time = 0
    tween.duration = duration
    tween.object = object
    tween.field = field
    tween.start_value = start_value
    tween.end_value = end_value

    if not easing_fn then
        tween.easing_fn = easing_functions.linear
    else
        if type(easing_fn) == "function" then
            tween.easing_fn = easing_fn
        elseif type(easing_fn) == "string" then
            tween.easing_fn = easing_functions[easing_fn]
        end
    end


    table.insert(tweens, tween)

    return tween
end

function M.delete(tween)
    for i = 1, #tweens do
        if tweens[i] == tween then
            table.remove(tweens, i)
            return
        end
    end

    log.warn("Cannot delete unrecognised tween")
end

function M.update(dt)

    for i = #tweens, 1, -1 do
        local tween = tweens[i]

        tween.time = math.min(tween.duration, tween.time + dt)
        local t = tween.time / tween.duration
        local new_value = tween.start_value + (tween.end_value - tween.start_value) * tween.easing_fn(t)

        if type(tween.field) == "string" then
            tween.object[tween.field] = new_value
        elseif type(tween.field) == "function" then
            tween.field(tween.object, new_value)
        end

        if t == 1 then
            if tween.on_complete then
                tween.on_complete(tween.object, new_value)
            end
            table.remove(tweens, i)
        end
    end
end

return M