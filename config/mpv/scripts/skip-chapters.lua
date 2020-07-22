local utils = require("mp.utils")

local opt = {
    skip_chapters = true,    -- true(yes in conf file) to enable, false(no in conf file) to disable
    show_message = true,    -- true(yes in conf file) to show skip message, false(no in conf file) to hide

    -- pattens for matching chapters name to skip
    patterns = {
        "OP","[Oo]pening$", "^[Oo]pening:", "[Oo]pening [Cc]redits", "^片头曲",
        "ED","[Ee]nding$", "^[Ee]nding:", "[Ee]nding [Cc]redits", "^片尾曲",
        "[Pp]review$",
    },
}

(require 'mp.options').read_options(opt, "skip-chapters")
opt.patterns = utils.parse_json(opt.patterns)

local enabled = opt.enable_skip_chapters
local last_chapter = -1

local function reset_last_chapter()
    last_chapter = -1
end

local function jump_chapter(count)
    mp.command("no-osd add chapter " .. count)
    if count < 0 then
        mp.command("no-osd seek -0.5")
    end
end

function check_chapter(_, chapter)
    if not enabled then
        return
    end
    if not chapter then
        return
    end
    local c_chapter = mp.get_property_number("chapter")
    for _, p in pairs(opt.patterns) do
        if string.match(chapter, p) then
            print("Skipping chapter: " .. chapter)
            if opt.show_message then
                mp.osd_message("Skipping chapter: " .. chapter)
            end
            if last_chapter < c_chapter then
                jump_chapter(1)
            elseif last_chapter > c_chapter then
                if c_chapter == 0 then
                    jump_chapter(1)
                else
                    jump_chapter(-1)
                end
            end
            break
        end
    end
    last_chapter = c_chapter
end

function toggle_skipchapters()
    enabled = not enabled
    if enabled then
        mp.osd_message("skip chapter is enabled")
    else
        mp.osd_message("skip chapter is disabled")
    end
end

mp.register_event("end-file", reset_last_chapter)
mp.observe_property("chapter-metadata/by-key/title", "string", check_chapter)

-- add key binding for toggle skipchapters in ~~/input.conf
-- examples: alt+c script-binding toggle-skipchapters
mp.add_key_binding(nil, "toggle-skipchapters", toggle_skipchapters)

