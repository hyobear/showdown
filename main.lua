-- Showdown!
-- paperleonard
-- based on a game I made in 2 hours

-- todo:
-- set up control menu (reconfig p1 button and p2 button)
-- start working on splash screen/title/game sprites

-- bugs:
-- none so far! :)

-- fixed bugs:
-- holding z causes functions tied to z to start immediately,
-- even when switching states
-- fixed by: adding a keytimer so the function would only
-- activate half a second AFTER state has switched
-- example:
--[[
	local keyTimer = 0

	function update(dt)
		keyTimer = keyTimer + dt

		if z key is pressed and keyTimer is greater than 0.5 then
			switch to game state
		end
	end

]]

-- states: splash, title, ready up, countdown, fire, victory
--									^ instructions

-- file structure/proxy function based off of headchant's boilerplate (thanks man!)
function Proxy(f)
	return setmetatable({}, {__index = function(self, k)
		local v = f(k)
		rawset(self, k, v)
		return v
	end})
end

i = Proxy(function(k) return love.graphics.newImage('img/' .. k .. '.png') end)
s = Proxy(function(k) return love.audio.newSource('sfx/' .. k .. '.wav', 'static') end)
m = Proxy(function(k) return love.audio.newSource('msc/' .. k .. '.wav', 'stream') end)
-- usage: love.graphics.draw(i.background) or s.explosion:play()

-- shortcuts
lg = love.graphics
lw = love.window
lm = love.mouse
lk = love.keyboard

-- libaries
screen = require 'lib/shack'
state = require 'lib/stager'
require 'lib/maid64'

debug = false
fullscreenFlag = false

state:switch('/src/splash')

math.randomseed(os.time())

key1 = 'z'
key2 = 'm'
lalt = lk.isDown('lalt')
ralt = lk.isDown('ralt')
enter = lk.isDown('return')
f11 = lk.isDown('f11')

function love.load()
	lw.setMode(512, 512, {fullscreen=fullscreenFlag, resizable=true, vsync=false, minwidth=128, minheight=128})
	maid64.setup(128)
	lg.setFont(lg.newFont('font.ttf', 8))
end

function love.draw()
	maid64.start()
	lg.setDefaultFilter('nearest', 'nearest', 0)
	screen:setDimensions(lg.getDimensions())
	screen:apply()
	state:draw()
	maid64.finish()
end

function love.update(dt)
	state:update(dt)
	screen:update(dt)
end

function love.resize(w, h)
	maid64.resize(w, h)
end
