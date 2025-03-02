return {
    get_dependencies = function(time, loop, ...)
        return table.map({...}, function(el)
            return { "Sprites", el }
        end)
    end,

    load = function(time, loop, ...)
        return {
            frame_time = time,
            ["loop"] = loop,
            frames = table.map({...}, function(frame)
                return Sprites[frame]
            end)
        }
    end
}