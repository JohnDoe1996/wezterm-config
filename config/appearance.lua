local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local colors = require('colors.custom')
local platform = require('utils.platform')

local bg_source = { Color = colors.background }
if wezterm.GLOBAL and wezterm.GLOBAL.background then  --如果有背景图片, 使用背景图片
   bg_source = { File = wezterm.GLOBAL.background }
end


return {
   term = "xterm-256color",
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),

   -- color scheme
   color_scheme = "iTerm2 Tango Dark",  -- TODO: https://github.com/wez/wezterm/blob/main/config/src/scheme_data.rs
   colors = colors,

   -- background
   win32_system_backdrop = "Acrylic",
   background = {
      {
         source = bg_source,
         horizontal_align = 'Center',
         height = '100%',
         width = '100%',
         -- vertical_offset = '-10%',
         -- horizontal_offset = '-10%',
         opacity = 0.85, -- TODO: 背景透明度
      },
   },

   -- scrollbar 
   enable_scroll_bar = true,
   min_scroll_bar_height = "2cell",

   -- tab bar
   enable_tab_bar = true, -- 启用标签栏
   -- tab_bar_at_bottom = true,  -- 标签栏放置在底部
   hide_tab_bar_if_only_one_tab = false, -- platform.is_mac,  --  mac只有一个tab时候隐藏标签
   -- use_fancy_tab_bar = false,
   -- tab_max_width = 25,
   tab_max_width = 50,
   show_tab_index_in_tab_bar = true,  -- 不显示标签序号  
   switch_to_last_active_tab_when_closing_tab = true,

   -- cursor 光标设置
   default_cursor_style = "BlinkingBlock",
   cursor_blink_ease_in = "Constant",
   cursor_blink_ease_out = "Constant",
   cursor_blink_rate = 700,

   -- window
   adjust_window_size_when_changing_font_size = false,
   window_decorations = "INTEGRATED_BUTTONS|RESIZE",  -- 隐藏窗口
   -- integrated_title_button_style = "Windows",   -- 按键样式
   -- integrated_title_button_color = "auto",   -- 按键颜色
   -- integrated_title_button_alignment = "Right",  -- 按键位置
   initial_cols = 100,  --初始列数
   initial_rows = 25,  -- 初始行数
   window_padding = {
     left = 3,
     right = 7,
     top = 3,
     bottom = 1,
   },
   window_close_confirmation = 'AlwaysPrompt',
   window_frame = {
      -- active_titlebar_fg = "#0F2536",  
      -- inactive_titlebar_bg = "#0F2536",  -- 标签背景色
      -- active_titlebar_bg = '#090909', -- 正在使用的标签的色
      -- font = fonts.font_size,
      font_size = platform.is_mac and 12 or 10,
      -- inactive_titlebar_bg = '#353535',
      -- active_titlebar_bg = '#2b2042',
      -- inactive_titlebar_fg = '#cccccc',
      -- active_titlebar_fg = '#ffffff',
      -- inactive_titlebar_border_bottom = '#2b2042',
      -- active_titlebar_border_bottom = '#2b2042',
      -- button_fg = '#cccccc',
      -- button_bg = '#2b2042',
      -- button_hover_fg = '#ffffff',
      -- button_hover_bg = '#3b3052',

   },
   -- 不是激活状态的pane颜色设置
   inactive_pane_hsb = {
      hue=1,  --色相
      saturation = 0.9,  -- 饱和度
      brightness = 0.7,  -- 亮度
   },

}
