local en, super = Class(Encounter)

function en:init()
    super.init(self)
    self.enemy = self:addEnemy("touhou", 550, 270)
    self.background = false
    self.music = nil
    self.use_karma = true
end

function en:onBattleStart()
    local kris = Game.battle:getPartyBattler("kris")
    kris.y = 270
    Game.battle.battle_ui.action_boxes[1].y = -5
    if DONE_ONCE then
        kris.visible = false
        self.enemy.visible = false
        self.fade_rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        self.fade_rect.layer = BATTLE_LAYERS["top"]
        Game.battle:addChild(self.fade_rect)
        Game.battle.timer:after(1, function()
            self.fade_rect:fadeOutAndRemove()
        end)
    end
    -- Game.battle.main_actbox = Game.battle:addChild(ActionBox(213, 400, 1, kris))
end

function en:beforeStateChange(old, new)
    if old == "INTRO" and new == "ACTIONSELECT" then
        Game.battle:startCutscene(function(cs)
            if SHOWCASE then
                cs:wait(function() return Input.pressed("space") end)
            elseif not DONE_ONCE then
                cs:wait(1)
            end
            
            cs:after(function()
                Game.battle:setState("DEFENDINGBEGIN", {"badapple"})
            end)
        end)
        return true
    end
end

function en:onStateChange(old, new)
    Game.battle.current_selecting = 1
end

function en:onGameOver()
    DONE_ONCE = true
    if BAD_APPLE then
        BAD_APPLE.music:stop()
    end
end

return en