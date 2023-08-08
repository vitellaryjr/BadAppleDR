local Bullet, super = Class("Bullet", true)

function Bullet:init(...)
    super.init(self, ...)
    self.use_karma = false -- can be overridden per bullet
    self.karma_damage = Game.battle.encounter.karma_damage
    self.karma_decay = 1
end

function Bullet:onCollide(soul)
    if not Game.battle.encounter.use_karma and not self.use_karma then
        return super.onCollide(self, soul)
    end
    local style = Kristal.getLibConfig("karma", "damage_style")
    if style == "all" or style == "all_full" then
        local targets = Game.battle:getKarmaTargets()
        for _,target in ipairs(targets) do
            if style == "all_full" then
                Game.battle:applyKarma(target, self:getKarma()*DTMULT)
            else
                Game.battle:applyKarma(target, self:getKarma()*DTMULT/#targets)
            end
        end
    else
        Game.battle:applyKarma(Game.battle.kr_target, self:getKarma()*DTMULT)
    end
    if self.karma_decay > 0 then
        self.karma_damage = Utils.approach(self.karma_damage, 1, self.karma_decay*DTMULT)
    end
end

function Bullet:getKarma()
    return self.karma_damage
end

return Bullet