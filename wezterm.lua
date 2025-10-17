local Config = require('config')

require('utils.backdrops')
   :set_files()
   -- :set_focus('#000000')
   :random()

-- require('events.right-status').setup()  -- 右边状态栏
-- require('events.left-status').setup() -- 左边状态栏？好像没什么用
require('events.tab-title').setup() --  选项卡
require('events.new-tab-button').setup() -- 新建选项卡按键 

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
