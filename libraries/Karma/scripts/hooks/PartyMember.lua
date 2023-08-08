local PartyMember, super = Class("PartyMember", true)

function PartyMember:init()
    super.init(self)
    self.karma = 0
    self.max_karma = math.floor(self.stats.health * 0.4)
    self.karma_timer = 0
end

return PartyMember