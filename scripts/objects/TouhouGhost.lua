local Ghost, super = Class(Object)

function Ghost:init(x, y)
    super.init(self, x, y, 60, 60)
    self:setOrigin(0.5, 1)
    self.mode = "light" -- light, dark, xor

    self.main = self:addChild(Sprite("enemy/main"))

    self.body_frames = Assets.getFrames("enemy/body")
    self.body = love.math.random(#self.body_frames)
    self.body_timer = 0
    self.body_speed = Utils.random(1,3)

    self.head_frames = Assets.getFrames("enemy/head")
    self.head = love.math.random(#self.head_frames)
    self.head_timer = 0
    self.head_speed = Utils.random(1,3)
end

function Ghost:update()
    super.update(self)
    self.body_timer = self.body_timer + DT
    if self.body_timer >= self.body_speed then
        self.body_timer = Utils.random(-1,0)
        self.body_speed = Utils.random(1,3)
        self.body = love.math.random(#self.body_frames)
    end

    self.head_timer = self.head_timer + DT
    if self.head_timer >= self.head_speed then
        self.head_timer = Utils.random(-1,0)
        self.head_speed = Utils.random(1,3)
        self.head = love.math.random(#self.head_frames)
    end
end

function Ghost:draw()
    if self.mode == "light" then
        love.graphics.setBlendMode("add")
    elseif self.mode == "dark" then
        love.graphics.setBlendMode("subtract")
    end

    if self.body_timer > 0 then
        if self.body_timer < (self.body_speed/2) then
            love.graphics.setColor(1,1,1, Utils.ease(0,1, (self.body_timer*2) / self.body_speed, "out-sine"))
        else
            love.graphics.setColor(1,1,1, Utils.ease(1,0, ((self.body_timer / self.body_speed) - 0.5)*2, "in-sine"))
        end
        love.graphics.draw(self.body_frames[self.body])
    end
    
    if self.head_timer > 0 then
        if self.head_timer < (self.head_speed/2) then
            love.graphics.setColor(1,1,1, Utils.ease(0,1, (self.head_timer*2) / self.head_speed, "out-sine"))
        else
            love.graphics.setColor(1,1,1, Utils.ease(1,0, ((self.head_timer / self.head_speed) - 0.5)*2, "in-sine"))
        end
        love.graphics.draw(self.head_frames[self.head])
    end

    -- draw main body
    super.draw(self)

    love.graphics.setBlendMode("alpha")
end

return Ghost