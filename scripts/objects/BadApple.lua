local BadApple, super = Class(Object)

function BadApple:init()
    super.init(self)
    self.layer = BATTLE_LAYERS["below_battlers"]

    self.load_thread = love.thread.newThread(Mod.info.path.."/animthread.lua")
    self.out_channel = love.thread.getChannel("BA_out")

    self.total_time = 0
    self.frame = 0
    self.texture = nil
end

function BadApple:onAdd(parent)
    super.onAdd(self, parent)
    self.load_thread:start(Mod.info.path)
    self.music = Music("bad_apple")
end

function BadApple:update()
    super.update(self)

    self.total_time = self.music:tell()
    -- exact framerate of original video, hopefully ensures audio doesn't desync
    local new_frame = math.floor(self.total_time * 29.997)

    if self.frame < new_frame then
        self:setFrame(new_frame)
    end
end

function BadApple:draw()
    super.draw(self)
    if self.texture then
        love.graphics.draw(self.texture, 0, 0, 0, 2, 2)
    end
end

function BadApple:setFrame(frame)
    self.frame = frame
    local out = self.out_channel:pop()
    while out do
        if out.id == frame then
            self.texture = love.graphics.newImage(out.data)
            break
        end
        out.data:release()
        out = self.out_channel:pop()
    end
end

return BadApple