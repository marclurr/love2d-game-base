local M = {}

local function draw_layer(tilemap, layer, start_x, end_x, start_y, end_y)
    if not layer then return end
    for y = start_y, end_y  do
        for x = start_x, end_x  do
            local index = x + (y * tilemap.width) + 1
            local tid = layer.data[index]
            if tid > 0 then
                Gfx.draw_tile(tilemap.tileset, tid, x * tilemap.tilewidth, y * tilemap.tileheight)
            end
        end
    end
end

function M.draw(tilemap, ...)
    if not tilemap then return end

    local screen_width = GFX_WIDTH
    local screen_height = GFX_HEIGHT
    local layers_to_draw = {...}
    local x_scroll, y_scroll = Gfx.camera()

    local tileset = tilemap.tileset

    local start_x = math.floor(x_scroll / tilemap.tilewidth)
    local end_x = start_x + (screen_width / tilemap.tilewidth)
    start_x, end_x = math.max(0, start_x), math.min(tilemap.width - 1, end_x)

    local start_y = math.floor(y_scroll / tilemap.tileheight)
    local end_y = start_y + (screen_height / tilemap.tileheight)
    start_y, end_y = math.max(0, start_y), math.min(tilemap.width - 1, end_y)

    if #layers_to_draw == 0 then
        for i = 1, #tilemap.layers do
            local layer = tilemap.layers[i]

            draw_layer(tilemap, layer, start_x, end_x, start_y, end_y)

        end
    else
        if not tilemap.layers_by_name then return end
        for i = 1, #layers_to_draw do
            local layer_name = layers_to_draw[i]
            local layer = tilemap.layers_by_name[layer_name]

            draw_layer(tilemap, layer, start_x, end_x, start_y, end_y)
        end
    end

end


return M