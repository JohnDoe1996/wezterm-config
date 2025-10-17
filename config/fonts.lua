local wezterm = require('wezterm')
local platform = require('utils.platform')


-- TODO：字体大小，数字越大字体越大
local font_size = platform.is_mac and 10 or 9

-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },  --禁用这种特定字体的默认连接特性：
return {
   font = wezterm.font_with_fallback({
      { 
         family = 'JetBrains Mono', 
         weight = 'Medium', 
         harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
      },
    }), 
   font_size = font_size,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
