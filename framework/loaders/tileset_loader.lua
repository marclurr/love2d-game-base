return {
    get_dependencies = function(texture_name)
        return {
            {"Textures", texture_name}
        }
    end,

    load = function(texture_name, tile_width, tile_height)
    local texture = Textures[texture_name]

    local tiles = {}

    local columns = texture:getWidth() / tile_width
    local rows = texture:getHeight() / tile_height

    for row = 0, rows -1 do
        for column = 0, columns - 1 do
            local x = column * tile_width
            local y = row * tile_height

            table.insert(tiles, love.graphics.newQuad(x, y, tile_width, tile_height, texture:getWidth(), texture:getHeight()))
        end
    end

    return {
        ["texture"] = texture,
        ["tiles"] = tiles,
        ["tile_width"] = tile_width,
        ["tile_height"] = tile_height,
    }

    end
}