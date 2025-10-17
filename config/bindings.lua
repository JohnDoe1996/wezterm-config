local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

--[[
- SUPER, CMD, WIN - these are all equivalent: on macOS the Command key, on Windows the Windows key, on Linux this can also be the Super or Hyper key. Left and right are equivalent.
- ALT, OPT, META - these are all equivalent: on macOS the Option key, on other systems the Alt or Meta key. Left and right are equivalent.
> https://wezfurlong.org/wezterm/config/keys.html#configuring-key-assignments
]]

if platform.is_mac then -- Mac系统，功能键
   mod.SUPER = 'SUPER' -- cmd
   mod.META = 'META' -- opt
   mod.SUPER_REV = 'SUPER|CTRL' -- cmd + ctrl
   mod.SUPER_SHIFT = 'SUPER|SHIFT' -- cmd + shift
   mod.SUPER_META = 'SUPER|OPT'
elseif platform.is_win or platform.is_linux then -- Win / Linux 系统， 功能键
   -- mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER = 'CTRL'
   mod.META = 'ALT'
   -- mod.SUPER_REV = 'ALT|CTRL'
   mod.SUPER_REV = 'CTRL|WIN'
   mod.SUPER_SHIFT = 'CTRL|SHIFT'
   mod.SUPER_META = 'CTRL|ALT'
end

-- stylua: ignore
local keys = {
   -- misc/useful --   
   -- -- Fn键在系统中有其他用途 所以禁用了。需要可以去掉注释
   -- { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   -- { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   -- { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   -- { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   -- { key = 'F5', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },   -- win/Linux 使用 f11 全屏显示， mac f11是系统功能键，使用cmd+ctrl+F全屏 
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },  -- 查找
   {
      key = 'u',
      mods = mod.SUPER,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.META,     action = act.SendString '\x1b\x1b\x5b\x44' },  -- 光标向左移动一个单词 0x1b 0x1b 0x5b 0x44
   { key = 'RightArrow', mods = mod.META,     action = act.SendString '\x1b\x1b\x5b\x43' },  -- 光标向右移动一个单词 0x1b 0x1b 0x5b 0x43
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },  -- 去到命令头 == home键
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },  -- 去到命令尾 == end键
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },   -- 清空命令  SUPER + 退格
   { key = 'u',          mods = 'CTRL',     action = act.SendString '\x15' },   -- 清空命令  ctrl + u

   -- copy/paste --
   { key = 'x',          mods = platform.is_mac and mod.SUPER or 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },  -- 复制
   { key = 'c',          mods = platform.is_mac and mod.SUPER or 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },  -- 复制
   { key = 'v',          mods = platform.is_mac and mod.SUPER or 'CTRLt|SHIFT',  action = act.PasteFrom('Clipboard') },  -- 粘贴

   -- tabs --
   -- tabs: spawn+close
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },  -- 新建标签 使用默认
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = platform.is_win and 'WSL:Ubuntu' or 'local' }) },  -- win系统下打开wsl 其他系统使用local
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = true }) },  -- 关闭tab
   { key = 'q',          mods = mod.SUPER, action = act.QuitApplication },  -- 退出

   -- tabs: navigation,
   -- { key = '[',          mods = 'META',     action = act.ActivateTabRelative(-1) },
   -- { key = ']',          mods = 'META',     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) }, 
   -- iterm2 的选择标签
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },  
   { key = 'RightArrow', mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   { key = '[',          mods = mod.SUPER_SHIFT,     action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_SHIFT,     action = act.MoveTabRelative(1) },
   { key = 'LeftArrow',  mods = mod.SUPER_SHIFT,     action = act.MoveTabRelative(-1) },
   { key = 'RightArrow', mods = mod.SUPER_SHIFT,     action = act.MoveTabRelative(1) },
   
   -- tab: title
   { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('manual-update-tab-title') },
   { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('reset-tab-title') },

   -- window --
   -- spawn windows
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },  -- 新建窗口

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },
   {
      key = 'b',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:toggle_focus(window)
      end)
   },

   -- panes --
   -- panes: split panes
  {
      key = 'd',
      mods = mod.SUPER,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = 'd',
      mods = mod.SUPER_SHIFT,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
  {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- fonts size
   { key = '=',     mods = mod.SUPER,     action = act.IncreaseFontSize },  -- 增大字体 =键其实即使 +键
   { key = '-',     mods = mod.SUPER,     action = act.DecreaseFontSize },  -- 减小字体
   { key = '0',     mods = mod.SUPER,     action = act.ResetFontSize },  -- 减小字体
   
   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },  -- 当前pane全屏，在按一次恢复。 iterm2中这个快捷键是全屏显示，不过我觉得这个挺好用就保留了，全屏使用 fn+F 感觉更加习惯些 （win term 默认 f11全屏)）
   { key = 'f',     mods = mod.SUPER_REV, action = act.ToggleFullScreen },  -- 增加 cmd+ctrl+F 作为全屏快捷键
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = true }) },  -- 关闭pane

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   -- iterm2 选择pane：
   { key = 'UpArrow',   mods = mod.SUPER_META, action = act.ActivatePaneDirection('Up') },
   { key = 'DownArrow', mods = mod.SUPER_META, action = act.ActivatePaneDirection('Down') },
   { key = 'LeftArrow', mods = mod.SUPER_META, action = act.ActivatePaneDirection('Left') },
   { key = 'RightArrow',mods = mod.SUPER_META, action = act.ActivatePaneDirection('Right') },
   { key = '[', mods = mod.SUPER, action = act.ActivatePaneDirection('Prev') },
   { key = ']',mods = mod.SUPER, action = act.ActivatePaneDirection('Next') },

   -- super_rev + p,之后通过数字切换pane
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ 
         alphabet = '1234567890', 
         -- mode = 'SwapWithActiveKeepFocus' 
      }),  
   },

   -- 这边不使用LEADER键
   -- -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

-- select tab  -- 使用 super+数字 选择tab, 只支持 数字1-9
for i = 1, 9 do
   table.insert(keys, {
      key = tostring(i),
      mods = mod.SUPER,
      action = act.ActivateTab(i - 1),
   })
end


-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = '=',      action = act.IncreaseFontSize },  -- +
      { key = '-',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' }, --esc键
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'UpArrow',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'DownArrow',    action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'LeftArrow',    action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'RightArrow',   action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },   --esc键
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true, -- TODO：取消所有默认快捷键
   -- leader = { key = 'Space', mods = mod.SUPER_REV }, -- 指定leader键为 super rev + 空格
   leader = { key = 'Escape', mods = mod.SUPER }, -- 指定leader键为 super + esc, 上面的方法要同时按4个键太难按了，所以改了一下
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
