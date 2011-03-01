-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

function file_exists(filename)
    local file = io.open(filename)
    if file then
        io.close(file)
        return true
    else
        return false
    end
end
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
theme_file = os.getenv("HOME") .. "/.config/awesome/theme.lua"
if not file_exists(theme_file) then
    theme_file = "/usr/share/awesome/themes/default/theme.lua"
end
beautiful.init(theme_file)

-- This is used later as the default terminal and editor to run.
terminal = "roxterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

cal_usage = {}
mytextclock:add_signal("mouse::enter", function()
    local today = os.date("%d")
    if today:sub(1,1) == '0' then
        today = today:sub(2,2)
    end
    cal_usage = naughty.notify({
        text = io.popen("cal", "r"):read("*all"):gsub("[^%d]" .. today .. "[^%d]", "<span color=\"#33FF33\">%1</span>"),
        timeout = 0,
        hover_timeout = 0.5,
        screen = mouse.screen
    })
end)
mytextclock:add_signal('mouse::leave', function () naughty.destroy(cal_usage) end)

oldtotal = 0
oldidle = 0
cpu_widget = awful.widget.graph()
cpu_widget:set_width(32)
cpu_widget:set_height(16)
cpu_widget:set_background_color('#222222')
cpu_widget:set_gradient_colors({ '#222222', '#33FF77' })

cpu_usage = {}
cpu_widget.widget:add_signal("mouse::enter", function()
    cpu_usage = naughty.notify({
        text = io.popen("top -b -n1", "r"):read("*all"),
        timeout = 0,
        hover_timeout = 0.5,
        screen = mouse.screen
    })
end)
cpu_widget.widget:add_signal('mouse::leave', function () naughty.destroy(cpu_usage) end)

function cpu_update()
    local data = io.open("/proc/stat", "r"):read():gmatch("%d+")
    local total = tonumber(data()) + tonumber(data()) + tonumber(data())
    local idle = tonumber(data())
    total = total + idle
    cpu_widget:add_value(1 - (idle - oldidle) / (total - oldtotal))
    oldtotal = total
    oldidle = idle
end
cpu_update()

function mem_total()
    local data = io.open("/proc/meminfo", "r"):read():gmatch("%S+")
    data()
    return tonumber(data())
end
memory_widget = awful.widget.graph()
memory_widget:set_width(32)
memory_widget:set_height(16)
memory_widget:set_max_value(mem_total())
memory_widget:set_background_color('#222222')
memory_widget:set_gradient_colors({ '#222222', '#3377FF' })

memory_usage = {}
memory_widget.widget:add_signal("mouse::enter", function()
    memory_usage = naughty.notify({
        text = io.popen("free", "r"):read("*all"),
        timeout = 0,
        hover_timeout = 0.5,
        screen = mouse.screen
    })
end)
memory_widget.widget:add_signal('mouse::leave', function () naughty.destroy(memory_usage) end)

function memory_update()
    memory_widget:add_value(tonumber(io.popen("free | tail -n+3 | head -n1 | sed 's/.*: *//;s/ .*//'", "r"):read()))
end
memory_update()

network_widget = awful.widget.graph()
network_widget:set_width(32)
network_widget:set_height(16)
network_widget:set_scale(true)
network_widget:set_stack(true)
network_widget:set_stack_colors({
    '#006666', '#660066', '#666600', '#0000CC', '#00CC00', '#CC0000',
    '#004488', '#008844', '#440088', '#448800', '#880044', '#884400' })
network_widget:set_background_color('#222222')
network_stat = {}
network_max = 0
for line in io.popen("cat /proc/net/dev|grep ':'"):lines() do
    local data = string.gmatch(line, "%S+")
    local iface = data()
    local recieved = tonumber(data())
    for i = 1, 7 do
        data()
    end
    local sent = tonumber(data())
    network_stat[iface] = {}
    network_stat[iface]["old_recieved"] = recieved
    network_stat[iface]["old_sent"] = sent
    network_stat[iface]["recieved"] = recieved
    network_stat[iface]["sent"] = sent
end
network_timeout = 10
network_scale = network_timeout * 1024
function network_update ()
    for line in io.popen("cat /proc/net/dev|grep ':'|grep -vE '.*:([ ]+0){16}'", "r"):lines() do
        local data = string.gmatch(line, "%S+")
        local iface = data()
        local recieved = tonumber(data())
        for i = 1, 7 do
            data()
        end
        local sent = tonumber(data())
        network_stat[iface]["old_recieved"] = network_stat[iface]["recieved"]
        network_stat[iface]["old_sent"] = network_stat[iface]["sent"]
        network_stat[iface]["recieved"] = recieved
        network_stat[iface]["sent"] = sent
    end
    local group = 0
    local total = 0
    for iface, data in pairs(network_stat) do
        group = group + 1
        local recieved = data["recieved"] - data["old_recieved"]
        total = total + recieved
        network_widget:add_value(recieved, group)
    end
    if total > network_max then
        network_max = total
        network_widget:set_max_value(network_max)
    end
end
network_update()

network_usage = {}
network_widget.widget:add_signal("mouse::enter", function()
    local text = ' '
    for iface, data in pairs(network_stat) do
        if data["sent"] + data["recieved"] > 0 then
            text = text .. iface .. " <span color=\"#CC7777\">⇓"
                .. string.format("%.1f",
                    (data["recieved"] - data["old_recieved"]) / network_scale)
                .. " KB/s</span>  <span color=\"#77CC77\">"
                .. string.format("%.1f",
                    (data["sent"] - data["old_sent"]) / network_scale)
                .. " KB/s⇑</span> "
        end
    end
    network_usage = naughty.notify({
        text = text,
        timeout = 0,
        hover_timeout = 0.5,
        screen = mouse.screen
    })
end)
network_widget.widget:add_signal('mouse::leave', function () naughty.destroy(network_usage) end)

io_widget = awful.widget.graph()
io_widget:set_width(32)
io_widget:set_height(16)
io_widget:set_scale(true)
io_widget:set_stack(true)
io_widget:set_stack_colors({'#CC8800', '#CC0088' })
io_widget:set_background_color('#222222')
io_stat = {}
function io_init()
    local line = io.popen('cat /proc/diskstats | grep " sda " | sed -E "s/^.*sda [0-9]+ [0-9]+ [0-9]+ //"'):read()
    local data = string.gmatch(line, "%S+")
    local read = tonumber(data())
    for i = 1, 3 do
        data()
    end
    local write = tonumber(data())
    io_stat["old_read"] = read
    io_stat["old_write"] = write
    io_stat["read"] = read
    io_stat["write"] = write
end

io_max = 0
function io_update ()
    local line = io.popen('cat /proc/diskstats | grep " sda " | sed -E "s/^.*sda [0-9]+ [0-9]+ [0-9]+ //"'):read()
    local data = string.gmatch(line, "%S+")
    local read = tonumber(data())
    for i = 1, 3 do
        data()
    end
    local write = tonumber(data())
    io_stat["old_read"] = io_stat["read"]
    io_stat["old_write"] = io_stat["write"]
    io_stat["read"] = read
    io_stat["write"] = write
    local total = io_stat["read"] - io_stat["old_read"]
    local written = io_stat["write"] - io_stat["old_write"]
    io_widget:add_value(written, 1)
    io_widget:add_value(total, 2)
    total = total + written
    if total > io_max then
        io_max = total
        io_widget:set_max_value(io_max)
    end
end
io_init()
io_update()

network_timer = timer({ timeout = network_timeout })
network_timer:add_signal("timeout", function()
    network_update()
    memory_update()
    cpu_update()
    io_update()
end)
network_timer:start()

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "16", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        memory_widget.widget,
        cpu_widget.widget,
        network_widget.widget,
        io_widget.widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey }, "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Dia" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "luakit" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Transmission" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Evince" },
      properties = { tag = tags[1][9] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

awful.tag.setproperty(tags[1][1], "nmaster", 2)
awful.tag.setproperty(tags[1][1], "mwfact", 0.2)
awful.tag.setproperty(tags[1][1], "icon_only", true)
awful.tag.seticon("/usr/share/icons/hicolor/16x16/apps/pidgin.png", tags[1][1])
awful.tag.setproperty(tags[1][2], "icon_only", true)
awful.tag.seticon("/usr/share/pixmaps/firefox-icon.png", tags[1][2])
awful.tag.setproperty(tags[1][9], "icon_only", true)
awful.tag.seticon("/usr/share/icons/hicolor/16x16/apps/evince.png", tags[1][9])

function run_once(prg)
    if not prg then
        do return nil end
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

run_once("firefox")
run_once("thunderbird")
-- Sometimes you want to start X session without automatic connect to IMs
if not os.getenv("NOIM") then
    run_once("pidgin")
    awful.util.spawn_with_shell("pgrep -f -u $USER -x ./skype || (skype)")
end

