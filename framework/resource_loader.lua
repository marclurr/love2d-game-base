local M = {}

function new_resource_pack(fn)
    local result = {}

    local new_setter = function(key)
        return function(name, ...)
            log.debug(string.format("Defining resource: { %s, %s, { %s } }", key, name, table.concat(table.map({...}, tostring), ", ")))
            table.insert(result, {key, name, { ... }})
        end
    end

    local m = setmetatable({}, {
        __index = function(table, key)
            rawset(table, key, new_setter(key))
            return rawget(table, key)
        end,
    })
    fn(m)

    return result
end

local loaders = {}
loaders.Textures = { load = love.graphics.newImage }
loaders.Sprites = require("loaders.sprite_loader")
loaders.Tilesets = require("loaders.tileset_loader")
loaders.Tilemaps = require("loaders.tilemap_loader")
loaders.Animations = require("loaders.animation_loader")
loaders.Sfx = require("loaders.sound_loader")("static")
loaders.Music = require("loaders.sound_loader")("stream")

local loader_precedence = {}
loader_precedence.Textures = 0
loader_precedence.Sprites = 1
loader_precedence.Tilesets = 1
loader_precedence.Tilemaps = 2
loader_precedence.Animations = 2
loader_precedence.Sfx = 0
loader_precedence.Music = 0

local function validate_dependencies(defs)
    local tree = setmetatable({}, {
        __index = function(table, key)
            rawset(table, key, {})
            return rawget(table, key)
        end
    })

    -- first gather all resource names by type
    for i = 1, #defs do
        local dest, name = table.unpack(defs[i])
        tree[dest][name] = true
    end

    -- now check all dependencies are available
    local all_good = true

    for i = 1, #defs do
        local def = defs[i]
        local dest, name = table.unpack(def)
        local loader = loaders[dest]

        if loader and loader.get_dependencies then
            local deps = loader.get_dependencies(table.unpack(def[3]))

            for _, dep in ipairs(deps) do
                local dep_type, dep_name = table.unpack(dep)
                if not tree[dep_type][dep_name] then
                    all_good = false
                    log.colour_red()
                    log.error("Missing dependency: (%s, %s) -> (%s, %s)", dest, name, dep_type, dep_name)
                    log.colour_reset()
                end
            end
        end
    end

    if not all_good then
        error("Unsatisfied resource dependencies exist.")
    end
end


function M.load(path)
    local chunk, err = love.filesystem.load(path)
    if err then
        log.warn("Could not load resources from [%s]: %s", path, err)
    end

    local defs = chunk()

    validate_dependencies(defs)

    -- sort definitions by hardcoded order of precedence
    table.sort(defs, function(def_a, def_b)
        local dest_a = table.unpack(def_a)
        local dest_b = table.unpack(def_b)

        return loader_precedence[dest_a] < loader_precedence[dest_b]
    end)

    return function (max_time)
        max_time = max_time or 0.005
        local i = 0
        local loaded_count = 0
        local t = 0
        local count = 0

        local start_time = love.timer.getTime()
        while i < #defs and t <= max_time do
            i = i + 1
            local def = defs[i]
            local dest, name = table.unpack(def)
            local loader = loaders[dest]

            if not loader or not loader.load then
                log.warn("No loader configured for resource of type [%s]", dest)
            else
                log.debug("Loading resource [%s] of type [%s] ", name, dest)--string.sub(dest, 1, -2))
                local res = loader.load(table.unpack(def[3]))
                _G[dest][name] = res
            end
            t = love.timer.getTime() - start_time
            count = count + 1
        end

        log.debug("Loaded [%d] resources in [%fs]. [%d of %d] remaining", count, t, #defs - i, #defs)
        return i == #defs, i / #defs
    end
end

function M.load_all(path)
    local load = M.load(path)
    while not load() do end
end

return M