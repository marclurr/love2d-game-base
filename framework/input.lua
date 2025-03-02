local key_bindings = {
    [BTN_UP] = { key =  "w", controller_button = "dpup" },
    [BTN_DOWN] = { key = "s", controller_button = "dpdown" },
    [BTN_LEFT] = { key = "a", controller_button = "dpleft" },
    [BTN_RIGHT] = { key = "d", controller_button = "dpright" },
    [BTN_A] = { key = "j", controller_button = "a" },
    [BTN_B] = { key = "k", controller_button = "b" },
    [BTN_X] = { key = "l", controller_button = "x" },
    [BTN_Y] = { key = ";", controller_button = "y" },
    [BTN_START] = { key = "escape", controller_button = "start" },
    [BTN_SELECT] = { key = "backspace", controller_button = "back" },
}

local keyboard_map = {}
local controller_map = {}

for btn, binding in pairs(key_bindings) do
    local key, controller_button = binding.key, binding.controller_button
    keyboard_map[key] = btn
    controller_map[controller_button] = btn
end

local state, prev_state = 0, 0

local function press_button(btn)
    if not btn then return end
    state = bit.bor(state, btn)
end

local function release_button(btn)
    if not btn then return end
    state = bit.bxor(state, bit.band(state, btn))
end

local M = {}

function M.update()
    prev_state = state
end

function M.get_state()
    return state
end


function M.get_state_as_string()
    local res = ""
    for i = 0, 15 do
        if M.is_pressed(bit.lshift(1, i)) then
            res = res .. "1"
        else
            res = res .. "0"
        end
    end
    return res
end
function M.is_pressed(btn, _state)
    _state = _state or state
    return bit.band(_state, btn) == btn
end

function M.is_just_pressed(btn, _state, _prev_state)
    _prev_state = _prev_state or prev_state
    return M.is_pressed(btn, _state) and not M.is_pressed(btn, _prev_state)
end

function M.is_just_released(btn, _state, _prev_state)
    _prev_state = _prev_state or prev_state
    return not M.is_pressed(btn, _state) and M.is_pressed(btn, _prev_state)
end

function love.keypressed(_, scancode)
    press_button(keyboard_map[scancode])
end

function love.keyreleased(_, scancode)
    release_button(keyboard_map[scancode])
end

function love.gamepadpressed(_, button)
    press_button(controller_map[button])
end

function love.gamepadreleased(_, button)
    release_button(controller_map[button])
end

return M