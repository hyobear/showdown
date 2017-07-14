local title = state:new()

-- up/down to select between Start Game and Instructions

local ix = 0
local iy = 0
local keyTimer = 0

function title.load()
  m.splash:stop()
  choice = 2
end

function title.update(dt)
  keyTimer = keyTimer + dt
  if lk.isDown('up') then
    choice = 1
  elseif lk.isDown('down') then
    choice = 2
  end

  if lk.isDown('z') and keyTimer > 0.5 then
    if choice == 1 then state:switch('/src/game') end -- ready up screen
    if choice == 2 then state:switch('/src/instructions') end -- instructions
    s.select:play()
  end
end

function title.draw()
  lg.draw(i.title, 0, 0, 0, 1, 1)
  if choice == 1 then ix = 16; iy = 81 end
  if choice == 2 then ix = 16; iy = 93 end

  -- indicator
  lg.rectangle('line', ix, iy, 96, 11)
  -- options
  lg.print('Start Game', 36, 78) lg.print('Instructions', 32, 90)
end

function title.unload()

end

return title
