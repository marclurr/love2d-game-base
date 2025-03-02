---@diagnostic disable: redundant-parameter
love.graphics.setDefaultFilter("nearest", "nearest")

local MAX_ITERATIONS = 3

function love.run()


    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    local timestep = 1 / 60
    local dt_accum = 0
    local frames = 0

    function ResetGametimer()
        dt_accum = 0
    end
    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
        love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end


        dt = love.timer.step()

        dt_accum = dt_accum + dt
        local count = 0

        while dt_accum >= timestep and count < MAX_ITERATIONS do
            love.update(timestep)
            dt_accum = dt_accum - timestep
            count = count + 1
        end

        if count == 3 then
            log.warn("update running slow")
        end

        love.graphics.origin()
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.draw()
        love.graphics.present()


        love.timer.sleep(0.001)
    end
end
