local SwapSoul, super = Class(Soul)

local SAFE_TIMER = 0.25
local HIT_GRACE = SAFE_TIMER / 2

function SwapSoul:init()
    super.init(self)
    self.sprite:setSprite("player/heart_swap")

    self.collider = CircleCollider(self, 0, 0, 2)

    self.speed = 6
    -- self.allow_focus = false -- handle this manually (making focus speed up instead)

    self.swap = false
    self.cooldown = 0
    self.safe_timer = 0
    self.was_grazing = false
    self.touched_bullet = false
    self.touched_bullets = {}
    self.touching = false

    self.hit_grace = 0
    self.hit_bullets = {}
end

function SwapSoul:onCollide(bullet)
    if self.inv_timer > 0 then
        -- We handle this ourselves if inv_timer is 0
        super.onCollide(bullet)
    else
        table.insert(self.touched_bullets, bullet)
    end

    self.touched_bullet = true
end

function SwapSoul:update()
    self.touched_bullet = false
    self.touched_bullets = {}

    super.update(self)

    if self.cooldown > 0 then
        self.cooldown = Utils.approach(self.cooldown, 0, DT)
    else
        if Input.pressed("confirm") then
            self:toggleSwap()
        end
    end

    local was_grazing = self.was_grazing
    self.was_grazing = false

    if self.safe_timer > 0 then
        self.safe_timer = Utils.approach(self.safe_timer, 0, DT)
    elseif self.inv_timer == 0 then

        if BAD_APPLE then
            local hit, grazed = self:badAppleCollision()

            if hit then
                if not self.swap then
                    self.touched_bullet = true
                end
            else
                if self.swap then
                    self.touched_bullet = true
                end
                if grazed then
                    local chara = Game.party[1]
                    local recover = 15
                    if chara.karma > 0 then
                        chara.karma = Utils.approach(chara.karma, 0, recover*DT)
                    else
                        chara.health = Utils.approach(chara.health, chara:getStat("health"), recover/2*DT)
                    end
                    if not was_grazing then
                        Assets.playSound("graze")
                        if self.graze_sprite.timer < 0.1 then
                            self.graze_sprite.timer = 0.1
                        end
                    else
                        self.graze_sprite.timer = 1/3
                    end
                    self.was_grazing = true
                end
            end
        end

        if self.touched_bullet ~= self.swap then
            if self.hit_grace == 0 and not self.touching then
                -- add DT once since it gets immediately subtracted this same frame
                self.hit_grace = HIT_GRACE + DT
            end

            for _,bullet in ipairs(self.touched_bullets) do
                if not Utils.containsValue(self.hit_bullets, bullet) then
                    table.insert(self.hit_bullets, bullet)
                end
            end
        else
            self.touching = false
        end
    end

    if self.hit_grace > 0 then
        self.hit_grace = Utils.approach(self.hit_grace, 0, DT)
        if self.hit_grace == 0 then
            self.touching = true
        end
    end
    if self.touching then
        -- Here we actually hurt the player

        if #self.hit_bullets > 0 then
            for _,bullet in ipairs(self.hit_bullets) do
                self:onCollide(bullet)
            end
        end

        -- if self.inv_timer == 0 then
        --     self.inv_timer = 4/3
        --     Game.battle:hurt(1, true)
        -- end
        Game.battle:applyKarma(Game.battle:getPartyBattler("kris"), DTMULT)

        self.hit_bullets = {}
    end
end

function SwapSoul:badAppleCollision()
    local canvas, rx, ry, rw, rh = self:getBadAppleCanvas()

    if not canvas then
        return false, false
    end

    local data = canvas:newImageData(1, 1, rx, ry, rw, rh)

    local grazed = false

    for i = 0, data:getWidth()-1 do
        for j = 0, data:getHeight()-1 do
            local r, g, b, a = data:getPixel(i, j)

            if not self.swap then
                if r == 0 and b == 1 then
                    return true, true
                elseif g == 0 and b == 1 then
                    grazed = true
                end
            else
                if r == 1 and b == 0 then
                    return true, true
                elseif g == 1 and b == 0 then
                    grazed = true
                end
            end
        end
    end

    return false, grazed
end

function SwapSoul:getBadAppleCanvas()
    if not BAD_APPLE or not BAD_APPLE.texture then
        return nil
    end

    local tf = self:getFullTransform()

    local x, y = tf:transformPoint(0, 0)

    local x1, y1 = tf:transformPoint(-self.graze_collider.radius, -self.graze_collider.radius)
    local x2, y2 = tf:transformPoint(self.graze_collider.radius, self.graze_collider.radius)

    x1, y1 = math.floor(x1), math.floor(y1)
    x2, y2 = math.ceil(x2), math.ceil(y2)

    x1, y1 = Utils.clamp(x1, 0, SCREEN_WIDTH-1), Utils.clamp(y1, 0, SCREEN_HEIGHT-1)
    x2, y2 = Utils.clamp(x2, 0, SCREEN_WIDTH-1), Utils.clamp(y2, 0, SCREEN_HEIGHT-1)

    local rx, ry = x1, y1
    local rw, rh = x2 - x1, y2 - y1

    if rw <= 0 or rh <= 0 then
        return nil
    end

    local canvas = Draw.pushCanvas()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(BAD_APPLE.texture, 0, 0, 0, 2, 2)

    love.graphics.setBlendMode(self.swap and "add" or "subtract")
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", x, y, self.collider.radius)

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", x, y, self.graze_collider.radius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setBlendMode("alpha")

    Draw.popCanvas()

    return canvas, rx, ry, rw, rh
end

-- function SwapSoul:doMovement()
--     local speed = self.speed
--     if Input.down("cancel") then
--         self.speed = self.speed / 2
--     end
--     super.doMovement(self)
--     self.speed = speed
-- end

function SwapSoul:toggleSwap(state)
    Assets.playSound("noise")
    self.cooldown = 0.5
    self.safe_timer = SAFE_TIMER - self.hit_grace
    self.hit_grace = 0
    self.hit_bullets = {}
    if state ~= nil then
        self.swap = state
    else
        self.swap = not self.swap
    end
    if self.swap then
        self.sprite:setFrame(2)
    else
        self.sprite:setFrame(1)
    end
end

return SwapSoul