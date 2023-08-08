local Touhou, super = Class(EnemyBattler)

function Touhou:init()
    super.init(self)
    -- self.ghosts = {
    --     self:addChild(TouhouGhost()),
    --     self:addChild(TouhouGhost()),
    -- }
    self.sprite = self:addChild(TouhouGhost())
end

return Touhou