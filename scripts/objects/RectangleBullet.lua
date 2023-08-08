local RectangleBullet, super = Class(Bullet)

function RectangleBullet:init(x, y, w, h)
    super.init(self, x, y)

    self:setOrigin(0, 0)
    self:setScale(1)

    self.tp = 0
    self.destroy_on_hit = false
    self.remove_offscreen = false

    self.collider = Hitbox(self, 0, 0, w, h)

    self.width = w
    self.height = h
end

function RectangleBullet:update()
    super.update(self)

    self.collider.width = self.width
    self.collider.height = self.height
end

function RectangleBullet:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    super.draw(self)
end

return RectangleBullet