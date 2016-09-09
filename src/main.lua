
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("src/app")
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("res/audio")
cc.FileUtils:getInstance():addSearchPath("res/ccb")
cc.FileUtils:getInstance():addSearchPath("res/image")

require "config"
require "cocos.init"

local function main()
    require "GameMainScene"
    cc.Director:getInstance():runWithScene(GameMainScene:loadScene())
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
