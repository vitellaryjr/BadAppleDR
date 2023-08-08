local test, super = Class(Wave)

function test:init()
    super.init(self)
    self.time = -1
    self:setArenaPosition(320, 240)
end

function test:onStart()
    super.onStart(self)
    local arena, soul = Game.battle.arena, Game.battle.soul
    Assets.playSound("beam")
    Assets.playSound("gigatalk", 0.5)
    local beam = self:spawnBullet(RectangleBullet(SCREEN_WIDTH, arena.y + arena.height/4, 0, arena.height/2))
    beam:setLayer(BATTLE_LAYERS["below_soul"])
    beam:setOrigin(1, 0.5)
    local siner = 0
    local siner_func = beam:addChild(Callback{update = function()
        siner = siner + 24*DT
        beam.height = Utils.wave(siner, arena.height/2 + 24, arena.height/2 + 32)
    end})
    self.timer:tween(1, beam, {width = SCREEN_WIDTH})
end

return test