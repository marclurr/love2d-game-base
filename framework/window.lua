local resoltuions = {
    ["960x540"] = {960, 540},
    ["1280x720"] = {1280, 720},
    ["1440x820"] = {1440, 810},
}

local M = {}

function M.init()
    M.reconfigure()
end

function M.reconfigure()
    local w, h = table.unpack(resoltuions[Config.values.video.resolution] or {1280, 720})
    local flags = {}
    flags.fullscreen = Config.values.video.fullscreen == true
    flags.vsync = Config.values.video.vsync and 1 or 0
    flags.resizable = true
    log.debug("Reconfiguring window with parameters (width=%d, height=%d, fullscreen=%s, vsync=%s)", w, h, flags.fullscreen, flags.vsync)
    love.window.setMode(w, h, flags)
    love.window.setTitle(string.format("%s - %s", NAME, VERSION))
end


return M