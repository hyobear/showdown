function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.version = "0.10.1"                -- The LÖVE version this game was made for (string)
    t.console = false                  -- Attach a console (boolean, Windows only)

    t.window.title = "SHOWDOWN"        -- The window title (string)
    t.window.icon = '/icon.png'                -- Filepath to an image to use as the window's icon (string)
    t.window.width = 128            -- The window width (number)
    t.window.height = 128       -- The window height (number)
end
