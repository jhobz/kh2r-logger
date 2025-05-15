LUAGUI_NAME = 'KH2 Rando Seed Logger'
LUAGUI_AUTH = 'JHobz'
LUAGUI_DESC = 'Logs out (to a file) the path and actions a user takes during a KH2 Rando seed'

-- TODO: Make this filepath configurable
local FILEPATH = 'KH2randoseedlog.txt'

local kh2libstatus, kh2lib
local can_execute = false
local prev_location

function _OnInit()                                                         -- Runs during game initialization, only once
    kh2libstatus, kh2lib = pcall(require, 'kh2lib')                        -- Imports the KH2 Lua Library, detects game version, and populates the `kh2lib` table
    if not kh2libstatus then                                               -- Checks if there was an error loading the library
        print('ERROR (kh2r-logger): KH2-Lua-Library mod is not installed') -- Try to report as meaningful of an error as possible
        can_execute = false                                                -- Definitely can't execute if the library is missing
        return
    end

    Log('KH2 Rando Seed Logger (v0.1.1)') -- Using Log() will use an appropriate console print call per platform
    RequireKH2LibraryVersion(3)           -- Declares the minimum version of the library required by this script
    -- RequirePCGameVersion()                -- Declares that this script was only written for the PC ports of KH2 (optional)

    can_execute = kh2lib.CanExecute -- kh2lib sets this to false if any conditions declared above were not met
    if not can_execute then
        return
    end

    io.open(FILEPATH, 'w'):close()
end

-- Runs once per frame, game will wait for code to finish before proceeding to next frame
function _OnFrame()
    -- Only allows code to run if required conditions were met
    if not can_execute then
        return
    end

    local location = kh2lib.current.location
    if location ~= prev_location then
        local file = io.open(FILEPATH, 'a')
        Log(location)

        if file then
            file:write(location, '\n')
            file:close()
        end
        prev_location = location
    end
end
