love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("rough")

local camera_x, camera_y = 0, 0

local M = {}

function M.camera(new_x, new_y)
    camera_x = new_x or camera_x
    camera_y = new_y or camera_y
    return camera_x, camera_y
end


function M.draw_tile(tileset, id, x, y)
    local tile = tileset.tiles[id]
    if not tile then return end

    love.graphics.draw(tileset.texture, tile, math.round(x - camera_x), math.round(y - camera_y))
end

function M.draw_sprite(spr, x, y)
    if not spr then return end

    local ox = spr.ox or 0
    local oy = spr.oy or 0

    love.graphics.draw(spr.texture, spr.q, math.round(x - camera_x), math.round(y - camera_y), 0, 1, 1, ox, oy)
end

function M.draw_text(text, x, y)
    for i = 1, #text do
        local char = string.byte(text:sub(i, i)) - M.font[2]
        local id = M.font[1] + char

        M.draw_tile(id, x + (i - 1) * 8, y)
    end
end

return M