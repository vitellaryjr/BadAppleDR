local Battle, super = Class("Battle", true)

function Battle:init()
    super.init(self)
    self.karma_hp_timer = 0
end

function Battle:nextTurn()
    super.nextTurn(self)
    if self.encounter.use_karma then
        -- used in the case that the karma should apply to only one person
        self.kr_target = Utils.pick(self:getKarmaTargets())
    end
end

function Battle:update()
    super.update(self)
    self.karma_hp_timer = Utils.approach(self.karma_hp_timer, 0, DT)
    for _,battler in ipairs(self.party) do
        local chara = battler.chara
        -- print(chara.health, chara.karma)
        if chara.karma > 0 then
            chara.karma_timer = chara.karma_timer + DTMULT
            if (chara.karma_timer > 1  and chara.karma >= (chara.max_karma))
            or (chara.karma_timer > 2  and chara.karma >= (chara.max_karma * 0.75))
            or (chara.karma_timer > 5  and chara.karma >= (chara.max_karma * 0.5 ))
            or (chara.karma_timer > 15 and chara.karma >= (chara.max_karma * 0.25))
            or (chara.karma_timer > 30) then
                chara.karma_timer = 0
                chara.health = Utils.approach(chara.health, 0, 1)
                chara.karma = math.min(Utils.approach(chara.karma, 0, 1), chara.health - 1)
                battler:checkHealth()
            end
        end
    end
end

function Battle:getKarmaTargets()
    local targets = {}
    if not self.encounter or not self.encounter.use_karma then return targets end
    for _,party in ipairs(self.party) do
        if type(self.encounter.use_karma) == "boolean" or self.encounter.use_karma[party.chara.id] then
            table.insert(targets, party)
        end
    end
    return targets
end

function Battle:applyKarma(battler, amount)
    local chara = battler.chara
    local max = math.min(chara.max_karma, chara.health - 1)
    if self.karma_hp_timer == 0 then
        Assets.playSound("hurt")
        chara.health = Utils.approach(chara.health, 0, 1)
        self.karma_hp_timer = 1/30
    end
    if chara.karma < max then
        chara.karma = Utils.approach(chara.karma, max, amount)
    end
    chara.karma = math.min(chara.karma, chara.health - 1)
    battler:checkHealth()
end

return Battle