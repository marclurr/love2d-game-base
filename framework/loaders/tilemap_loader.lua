return {
    get_dependencies = function(tileset)
        return {
            {"Tilesets", tileset}
        }
    end,

    load = function (tileset_name, filename)
        local chunk, err = love.filesystem.load(filename)
        if (err) then
            error("Couldn't load tilemap [%s]", filename)
        end

        local tileset = Tilesets[tileset_name]
        local tilemap = chunk()
        tilemap.tileset = tileset

        local layers_by_name = {}
        for i = 1, #tilemap.layers do
            local layer = tilemap.layers[i]
            if layer.type == "tilelayer" then
                layers_by_name[layer.name] = layer
            end
        end

        tilemap.layers_by_name = layers_by_name

        return tilemap
    end
}