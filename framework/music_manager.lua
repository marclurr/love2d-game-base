local M = {}

local current_track, fade_in_out_tween

function M.play(track, loop, start_volume)
    if current_track == track or not track then
        local info = debug.getinfo(3, "Sl")
        log.warn("Can't play nil music. Offending file and line [%s:%d]", info.short_src, info.currentline)
        return
    end

    if current_track then
        current_track:stop()
    end

    current_track = track
    current_track:setVolume(start_volume or Config.values.audio.music_volume)
    current_track:setLooping(loop or true)
    current_track:play()

    log.debug("Music started")
end

function M.stop()
    current_track:stop()
    current_track = nil
    log.debug("Music stopped")
end

function M.fade_out(duration)
    if not current_track then return end

    if fade_in_out_tween then Tween.delete(fade_in_out_tween) end

    fade_in_out_tween = Tween.new_tween(duration, current_track, current_track.setVolume, current_track:getVolume(), 0)
    fade_in_out_tween.on_complete = M.stop
end

function M.fade_in(track, duration, loop)
    M.play(track, loop, 0)

    if current_track then
        if fade_in_out_tween then Tween.delete(fade_in_out_tween) end

        fade_in_out_tween = Tween.new_tween(duration, current_track, current_track.setVolume, 0, Config.values.audio.music_volume)
    end
end
return M