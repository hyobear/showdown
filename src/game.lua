local game = state:new()

-- up/down to select between Start Game and Instructions

local clock = 3
local countdownEnd = math.random(0.5, 5)
local keyTimer = 0
local keyTimerMax = 0.5

function game.load()
  -- states: ready_up, countdown, fire, victory
  gameState = 'ready_up'
  p1x = 23    -- player 1 x
  p2x = 100    -- player 2 x

  -- states: idle, ready, fire, dead, disqualified
  p1_state = 'idle'
  p2_state = 'idle'
  py  = 58    -- player 1 and 2 y
  shakeTimer = 0
  shake = 20  -- shake intensity
end

function game.update(dt)
  if gameState == 'ready_up' then
    keyTimer = keyTimer + dt
    if lk.isDown(key1) and keyTimer > keyTimerMax then p1_state = 'ready' end
    if lk.isDown(key2) and keyTimer > keyTimerMax then p2_state = 'ready' end

    -- switch to countdown state
    if p1_state == 'ready' and p2_state == 'ready' then
      gameState = 'countdown'
      keyTimer = 0
    end
  elseif gameState == 'countdown' then
    keyTimer = keyTimer + dt
    clock = clock - dt
    if clock < (0 - countdownEnd) then
      gameState = 'fire'
    end

    if lk.isDown(key1) and keyTimer > keyTimerMax then
      p1_state = 'disqualified'; gameState = 'victory'
      keyTimer = 0
    end
    if lk.isDown(key2) and keyTimer > keyTimerMax then
      p2_state = 'disqualified'; gameState = 'victory'
      keyTimer = 0
    end
  elseif gameState == 'fire' then
    if lk.isDown(key1) then
      -- player 1 wins
      p1_state = 'fire'
      p2_state = 'dead'
      gameState = 'victory'
      keyTimer = 0
    elseif lk.isDown(key2) then
      -- player 2 wins
      p1_state = 'dead'
      p2_state = 'fire'
      gameState = 'victory'
      keyTimer = 0
    end
  elseif gameState == 'victory' then
    keyTimer = keyTimer + dt
    shakeTimer = shakeTimer + dt
    if shakeTimer >= .2 then shake = 0; s.gunshot:stop()
    else s.gunshot:play() end

    if lk.isDown('left') then
      choice = 1
    elseif lk.isDown('right') then
      choice = 2
    end

    if lk.isDown(key1) and keyTimer > keyTimerMax then
      if choice == 1 then state:switch('/src/game') end -- ready up screen
      if choice == 2 then state:switch('/src/title') end -- instructions
      s.select:play()
    end
  end
end

function game.draw()
  if debug then
    lg.print(gameState, 2, 95)
    lg.print(countdownEnd, 2, 80)
    lg.print(math.ceil(clock), 2, 110)

    if lk.isDown('1') then state:switch('/src/game') end
  end

  lg.draw(i.game_bg, 0, 0)

  if gameState == 'ready_up' then
    lg.print(key1 .. '/' .. key2 .. ' to ready up...', 20, 100)
  elseif gameState == 'countdown' then
    lg.print('Get ready...', 38, 100)
  elseif gameState == 'fire' then
    lg.print('FIRE!', 50, 100)
  elseif gameState == 'victory' then
    if p1_state == 'fire' then lg.print('PLAYER 1 WINS!', 28, 96)
    elseif p1_state == 'disqualified' then lg.print('PLAYER 1 DISQUALIFIED', 11, 96) end
    if p2_state == 'fire' then lg.print('PLAYER 2 WINS!', 28, 96)
    elseif p2_state == 'disqualified' then lg.print('PLAYER 2 DISQUALIFIED', 11, 96) end

    screen:setShake(shake)

    if choice == 1 then ix = 68; iy = 112 end
    if choice == 2 then ix = 90; iy = 112 end

    -- indicator
    lg.rectangle('line', ix, iy, 22, 12)
    lg.print('Restart?', 16, 110)
    lg.print('Yes', 70, 110)
    lg.print('No', 96, 110)
  end

  -- player sprites
  -- player 1
  if p1_state == 'idle' then lg.draw(i.p1_idle, p1x, py)
  elseif p1_state == 'ready' then lg.draw(i.p1_ready, p1x, py)
  elseif p1_state == 'fire' then lg.draw(i.p1_fire, p1x, py)
  elseif p1_state == 'dead' then lg.draw(i.p1_dead, p1x, py) end

  -- player 2
  if p2_state == 'idle' then lg.draw(i.p2_idle, p2x, py)
  elseif p2_state == 'ready' then lg.draw(i.p2_ready, p2x, py)
  elseif p2_state == 'fire' then lg.draw(i.p2_fire, p2x, py)
  elseif p2_state == 'dead' then lg.draw(i.p2_dead, p2x, py) end
end

function game.unload()

end

return game
