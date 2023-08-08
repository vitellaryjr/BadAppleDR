local Encounter, super = Class("Encounter", true)

function Encounter:init()
    super.init(self)
    -- can be either a boolean or a table
    -- if false, battle uses normal bullets
    -- if true, karma damage is applied equally to all party members
    -- if it's a table, each index of the table can specify a party member ID,
    -- where the value will determine whether karma should be applied to that party member
    self.use_karma = false
    -- the default amount of damage karma should deal, per frame at 30FPS
    self.karma_damage = 1
end

return Encounter