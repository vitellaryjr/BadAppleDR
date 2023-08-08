local mod_path = ...

require("love.image")
require("love.timer")

local out = love.thread.getChannel("BA_out")

for i=1,6562 do
    -- dont store more than 100 at a time, to save on memory
    while out:getCount() > 100 do
        love.timer.sleep(0.01)
    end
    local num = i
    for _=#tostring(i),3 do
        num = "0"..num
    end
    local path = mod_path.."/assets/badapple/"..num..".png"
    if love.filesystem.getInfo(path) then
        out:push({id = i, data = love.image.newImageData(path)})
    end
end