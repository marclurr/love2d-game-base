
local M = {}


function M.init()


end



function M.update(dt)


end

function M.draw()
    Canvas.use()
    love.graphics.clear()

    love.graphics.printf("hello world", 0, GFX_HEIGHT / 2, GFX_WIDTH, "center")


    Canvas.present()
end


return M

