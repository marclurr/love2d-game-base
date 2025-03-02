return function(type)
    return {
        load = function(path)
            return love.audio.newSource(path, type)
        end
    }
end