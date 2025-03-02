local M = {}

M.canvas = love.graphics.newCanvas(GFX_WIDTH, GFX_HEIGHT)

function M.use()
    love.graphics.setCanvas(M.canvas)
end

function M.use_window()
    love.graphics.setCanvas()
end


function M.present()
    M.use_window()
    local width, height = love.graphics.getDimensions()
    local scale = math.floor(math.min(width / GFX_WIDTH, height / GFX_HEIGHT))
    love.graphics.draw(M.canvas, width / 2, height / 2, 0, scale, scale, GFX_WIDTH / 2, GFX_HEIGHT / 2)
end



return M