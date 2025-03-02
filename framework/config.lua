local CONFIG_FILENAME = "prefs.lua"

local default_config = {
    video = {
        fullscreen = false,
        aspect_ratio = "16:9",
        -- resolution = "1280x720",
        resolution = "1280x720",
        vsync = false,
        scaling_mode = "pixel_perfect" -- pixel_perfect/fit_window
    },

    audio = {
        music_volume = 1,
        sfx_volume = 1
    }
}

local function serialise_table(t, depth)
    assert(type(t) == "table", string.format("Can only serialise a table but got [%s]", type(t)))

    depth = depth or 0
    local indent = ""

    for i = 0, depth - 1 do
        indent = indent .. "\t"
    end

    if type(t) == "table" then
        local s = "{\n"
        for k, v in pairs(t) do
            local fmt = "%s\t%s = %s,\n"
            local val
            if type(v) == "number" or type(v) == "boolean" then
                val = tostring(v)
            elseif type(v) == "string" then
                val = "\"" .. v .. "\""
            elseif type(v)== "table" then
                val = serialise_table(v, depth + 1)
            end

            s = s .. string.format(fmt, indent, k, val)
        end
        s = s .. indent .. "}"
        return s
    end

end

local M = {}

M.values = default_config


function M.load()
    if DEBUG then
        log.debug("Reinstating default config")
        M.persist()
        return
    end

    local chunk, err = love.filesystem.load(CONFIG_FILENAME)
    if not err and chunk then
        M.values = chunk()
    else
        log.debug("[%s] is missing, writing default values", CONFIG_FILENAME)
        M.persist()
    end
end

function M.persist()
    local data = string.format("return %s", serialise_table(M.values))
    love.filesystem.write(CONFIG_FILENAME, data)
end


-- always overwrite config in DEBUG mode for now


return M