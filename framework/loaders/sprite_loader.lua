return {
    get_dependencies = function(texture_name)
        return {
            {"Textures", texture_name}
        }
    end,

    load = function(texture_name, x, y, w, h, ox, oy)
        local texture = Textures[texture_name]
        assert(texture)
        return {
            ["texture"] = texture,
            q = love.graphics.newQuad(x, y, w, h, texture:getWidth(), texture:getHeight()),
            ["ox"] = ox,
            ["oy"] = oy
        }

    end
}