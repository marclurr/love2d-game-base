local M = {}

local listeners = setmetatable({}, {
    __index = function(table, key)
        rawset(table, key, {})
        return rawget(table, key)
    end
})

function M.emit(event_name, ...)
    local listeners_for_event = listeners[event_name]

    for _, fn in pairs(listeners_for_event) do
        fn(...)
    end
end

function M.add_listener(event_name, fn)
    local listeners_for_event = listeners[event_name]

    local handle = {event_name, fn}
    listeners_for_event[handle] = fn
end

function M.remove_listener(handle)
    local event_name = table.unpack(handle)
    local listeners_for_event = listeners[event_name]

    listeners_for_event[handle] = nil
end

return M