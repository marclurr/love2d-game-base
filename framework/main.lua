DEBUG = false
NAME = "%_NAME_%"
VERSION = "%_VERSION_%"


require("const")
log = require("logging")

love.filesystem.setIdentity(APP_IDENTITY)


require("runner")

-- Globals
utf8 = require("utf8")
Config = require("config")
Bus = require("bus")
Input = require("input")
Window =  require("window")
ResourceLoader = require("resource_loader")
MusicManager = require("music_manager")
Tween = require("tween")
Gfx = require("gfx")
Map = require("map")
Canvas = require("canvas")

Textures = {}
Sprites = {}
Animations = {}
Tilesets = {}
Tilemaps = {}
Sfx = {}
Music = {}

-- // Globals

local tick_loader, loaded, progress = nil, false, 0

local arg_handlers = {}
arg_handlers.debug = function()
    DEBUG = true
    log.set_level("debug")
end

arg_handlers.info = function()
    print(NAME)
    print("Version: " .. VERSION)
    love.event.quit()
end

local entry_point

function love.load(args)


    for i = 1, #args do
        local arg = args[i]
        if string.sub(arg, 1, 2) == "--" then
            arg = string.sub(arg, 3)
            if arg_handlers[arg] then
                arg_handlers[arg]()
            end
        end
    end
    Config.load()
    log.debug("Starting %s version %s", NAME, VERSION)

    Window.init()

    ResourceLoader.load_all("resources.lua")
    -- tick_loader  = ResourceLoader.load("resources.lua")

    local chunk, err = love.filesystem.load("entry.lua")
    if err then
        error("entry.lua is missing")
    end

    entry_point = chunk()
    if entry_point.init then
        entry_point.init()
    end
end


function love.update(dt)

    Tween.update(dt)
    entry_point.update(dt)
    Input.update()




end

function love.draw()
    entry_point.draw()
end