local kris, super = Class("kris", true)

function kris:init()
    super.init(self)
    self.health = 99
    self.stats.health = 99
end

return kris