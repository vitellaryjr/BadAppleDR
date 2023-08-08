local BadAppleCollisionRender, super = Class(Object)

function BadAppleCollisionRender:init()
    super.init(self)

    self.layer = BATTLE_LAYERS["above_bullets"]
end

function BadAppleCollisionRender:draw()
    super.draw(self)

    if not DEBUG_RENDER then
        return
    end

    if not Game.battle.soul or not Game.battle.soul.bad_apple then
        return
    end

    local soul = Game.battle.soul

    local canvas, rx, ry, rw, rh = soul:getBadAppleCanvas()

    if not canvas then return end

    Draw.drawCanvasPart(canvas, SCREEN_WIDTH - rw, SCREEN_HEIGHT - rh, rx, ry, rw, rh)
end

return BadAppleCollisionRender