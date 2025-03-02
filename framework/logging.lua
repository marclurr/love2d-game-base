local levels = {
    debug = 0,
    warn = 2,
    error = 3
}

local log_level = levels.warn

local function print_log(level)
    return function(...)
        if log_level <= levels[level] then
            local info = debug.getinfo(2, "Sl")
            local str = string.format(...)
            print(string.format("%s: [%s]: %s", string.upper(level), info.short_src, str))
        end
   end
end

local function set_colour(c)
    return function()
        io.write(c)
    end
end
local M = {}

M.debug = print_log("debug")
M.warn = print_log("warn")
M.error = print_log("error")

M.colour_red = set_colour("\x1b[31m")
M.colour_reset = set_colour"\x1b[m"

function M.set_level(name)
    if levels[name] then
        log_level = levels[name]
    else
        log.warn("Invalid log level %s", name)
    end
end

return M