local instructions = state:new()

local inst = {}
local keyTimer = 0
local page = 1

function instructions.load()
  inst.a = 'CONTROLS:'
  inst.b = key1 .. '=P1 READY UP/SHOOT/\nSELECT'
  inst.c = key2 .. '=P2 READY UP/SHOOT/\nBACK'
  inst.d = '\n\nPRESS > FOR RULES'
  inst.e = 'RULES:'
  inst.f = 'SHOOT THE OTHER\nPLAYER\nDO NOT SHOOT BEFORE\nCOUNTDOWN ENDS'
  inst.g = 'THAT WILL RESULT\nIN DISQUALIFICATION'
  inst.h = 'PRESS < FOR CONTROLS'
end

function instructions.update(dt)
  keyTimer = keyTimer + dt
  if lk.isDown(key2) and keyTimer > 0.2 then
    state:switch('/src/title')
  end

  if lk.isDown('left') then
    page = 1
  elseif lk.isDown('right') then
    page = 2
  end
end

function instructions.draw()
  if page == 1 then
    lg.print(inst.a .. '\n' .. inst.b .. '\n' .. inst.c .. '\n' .. inst.d, 2, 2)
  elseif page == 2 then
    lg.print(inst.e .. '\n' .. inst.f .. '\n' .. inst.g .. '\n' .. inst.h, 2, 2)
  end
end

function instructions.unload()

end

return instructions
