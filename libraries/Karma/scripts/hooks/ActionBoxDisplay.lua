local ActionBoxDisplay, super = Class("ActionBoxDisplay", true)

function ActionBoxDisplay:draw()
    -- unfortunately i dont think theres a particularly good way for me to do this other than copy-pasting :(
    if Kristal.getLibConfig("karma", "display_kr") then
        if Game.battle.current_selecting == self.actbox.index then
            Draw.setColor(self.actbox.battler.chara:getColor())
        else
            Draw.setColor(PALETTE["action_strip"], 1)
        end
    
        love.graphics.setLineWidth(2)
        love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)
    
        love.graphics.setLineWidth(2)
        if Game.battle.current_selecting == self.actbox.index then
            love.graphics.line(1  , 2, 1,   36)
            love.graphics.line(212, 2, 212, 36)
        end
    
        Draw.setColor(PALETTE["action_fill"])
        love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)
    
        local bar_width = 76
        Draw.setColor(PALETTE["action_health_bg"])
        love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, bar_width, 9)
    
        local health, max_health = self.actbox.battler.chara:getHealth(), self.actbox.battler.chara:getStat("health")
        local hp_width = (health / max_health) * bar_width
        if hp_width > 0 then
            Draw.setColor(self.actbox.battler.chara:getColor())
            love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.ceil(hp_width), 9)
        end

        local karma = self.actbox.battler.chara.karma
        local kr_width = (karma / max_health) * bar_width
        -- local karma = math.min((self.actbox.battler.chara.karma / self.actbox.battler.chara:getStat("health")) * bar_width, health - 1)
        if kr_width > 0 then
            Draw.setColor(PALETTE["action_health_text_karma"])
            love.graphics.rectangle("fill", 128 + math.ceil(((health - karma) / max_health)*bar_width), 22 - self.actbox.data_offset, math.ceil(kr_width), 9)
        end
    
    
        local color = PALETTE["action_health_text"]
        if health <= 0 then
            color = PALETTE["action_health_text_down"]
        elseif (self.actbox.battler.chara.karma > 0) then
            color = PALETTE["action_health_text_karma"]
        elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4)) then
            color = PALETTE["action_health_text_low"]
        else
            color = PALETTE["action_health_text"]
        end
    
    
        local health_offset = 0
        health_offset = (#tostring(math.ceil(self.actbox.battler.chara:getHealth())) - 1) * 8
    
        Draw.setColor(color)
        love.graphics.setFont(self.font)
        love.graphics.print(math.ceil(self.actbox.battler.chara:getHealth()), 152 - health_offset, 9 - self.actbox.data_offset)
        Draw.setColor(PALETTE["action_health_text"])
        love.graphics.print("/", 161, 9 - self.actbox.data_offset)
        local string_width = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
        Draw.setColor(color)
        love.graphics.print(self.actbox.battler.chara:getStat("health"), 205 - string_width, 9 - self.actbox.data_offset)

        super.super.draw(self)
    else
        super.draw(self)
    end
end

return ActionBoxDisplay