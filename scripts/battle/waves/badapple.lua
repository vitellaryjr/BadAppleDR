local attack, super = Class(Wave)

function attack:init()
    super.init(self)
    self.time = -1
    self:setArenaPosition(320, 240)
end

function attack:onStart()
    super.onStart(self)
    local kris = Game.battle:getPartyBattler("kris")
    local enemy = Game.battle:getEnemyBattler("touhou")
    local arena, soul = Game.battle.arena, Game.battle.soul
    self.timer:script(function(wait)
        if not DONE_ONCE then
            wait(1)
            enemy.sprite.main:setSprite("enemy/gun")
            enemy.sprite.main:play(3/30, false)
            wait(0.5)
            Assets.playSound("segapower")
            local grad = self:spawnSprite("gradient", arena.x, arena.y)
            grad.alpha = 0
            grad:fadeTo(0.75, 0.5)
            wait(1.5)
            grad:remove()
            local sfx = Assets.playSound("beam")
            Assets.playSound("gigatalk", 0.5)
            local beam = self:spawnBullet(RectangleBullet(SCREEN_WIDTH, arena.y, 0, arena.height))
            beam:setLayer(BATTLE_LAYERS["below_soul"])
            beam:setOrigin(1, 0.5)
            local siner = 0
            local siner_func = beam:addChild(Callback{update = function()
                siner = siner + 24*DT
                beam.height = Utils.wave(siner, arena.height + 24, arena.height + 32)
            end})
            while true do
                beam.width = Utils.approach(beam.width, SCREEN_WIDTH - (soul.x + 12), 60*DTMULT)
                if beam.width == (SCREEN_WIDTH - (soul.x + 12)) then break end
                wait()
            end
            kris.active = false
            beam.active = false
            soul.can_move = false
            sfx:pause()
            wait(2)
            Assets.playSound("great_shine")
            -- deltarune does this so i'll do it too i guess
            Assets.playSound("great_shine", 1, 0.8)
            Assets.playSound("closet_impact", 1, 1.5)
            Game.battle:swapSoul(SwapSoul())
            soul = Game.battle.soul
            soul.can_move = false
            soul.color = {1,1,1}
            self.timer:after(0.25, function()
                self.timer:tween(0.5, soul.color, {1,0,0})
            end)
            local text_timer = 0
            local text
            while not soul.swap do
                if text_timer < 2 then
                    text_timer = text_timer + DT
                    if text_timer >= 2 then
                        text = self:spawnObject(Text(
                            SHOWCASE and ("Press [Z] to SWAP") or ("Press "..Input.getText("confirm").." to SWAP"),
                            SCREEN_WIDTH/2, arena.bottom + 40, SCREEN_WIDTH, 40,
                            {font_size = 16, align = "center"}
                        ))
                        text:setOrigin(0.5, 0.5)
                        text:setScale(1)
                        text.alpha = 0
                        text:fadeTo(1, 1)
                    end
                end
                wait()
            end
            if text then text:remove() end
            kris.active = true
            beam.active = true
            soul.can_move = true
            sfx:play()
            while beam.width < SCREEN_WIDTH do
                beam.width = Utils.approach(beam.width, SCREEN_WIDTH, 60*DTMULT)
                wait()
            end
            wait(1)
            siner_func:remove()
            self.timer:tween(1, beam, {height = 0}, "out-quad", function() beam:remove() end)
            arena.visible = false
            arena:setSize(632, 472)
            kris.visible = false
            enemy.visible = false
            enemy.sprite.main:setSprite("enemy/main")
            -- wait(0.6)
            -- soul.can_move = true
            -- soul:toggleSwap(false)
            wait(2)
        else
            arena.visible = false
            arena:setSize(632, 472)
            Game.battle:swapSoul(SwapSoul())
            soul = Game.battle.soul
        end
        BAD_APPLE = self:spawnObject(BadApple())
        Game.battle:addChild(BadAppleCollisionRender())

        while BAD_APPLE.frame < 6508 do wait() end
        soul.visible = false
        soul.active = false
        wait(3)
        Game:returnToMenu()
    end)
end

return attack