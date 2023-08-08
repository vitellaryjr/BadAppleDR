function Mod:preInit()
    DONE_ONCE = nil
    SHOWCASE = true
end

function Mod:load(...)
    BAD_APPLE = nil
    if DONE_ONCE then
        Game:encounter("badapple", false)
    end
end