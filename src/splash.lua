local splash = state:new()

local x = 0
local y = -128
local c = 0

function splash.load()
  m.splash:play()
end

function splash.update(dt)
  y = y + 55 * dt
  if y >= 0 then
    y = 0
    screen:setShake(2)
    c = c + dt
    if c > 0.2 then screen:setShake(0) end
    if c > 2 then state:switch('/src/title') end
  end

  if lk.isDown(key1 or key) then state:switch('/src/title') end
end

function splash.draw()
  lg.draw(i.splash, x, y)
  if debug then
    lg.print(math.floor(y), 2, 2)
    lg.print(c, 2, 64)
  end
end

function splash.keypressed(k)

end

function splash.unload()
  -- called when state is switched

end

return splash
