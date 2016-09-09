module("GameMainScene", package.seeall)
--游戏主Scene函数

-- 外部调用函数
-- loadScene

-- 内部函数
local dealWithTouch
local initGolbelData
local gameMainUpdate
local playerStun

-- 调用其他lua
require "Globel"
require "DataTemplate"
require "GameData"
require "LuaJavaBridge"

require "GamePlayPanel"
require "MenuPanel"
require "StartPanel"
require "ResultPanel"
require "SkinSelectPanel"



-- 内部变量表
local m_variablesTable = {}

loadScene = function ()
	printInfo("GameMainScene loadScene...")
	-- if(kTargetAndroid ==  g_targetPlatform)then 
	-- 	printInfo("Android Platform") 
	-- 	local CLASS_NAME = "com/LeXGame/TowerWrecker/AdMobBridge"
	-- 	LuaJavaBridge.callStaticMethod(CLASS_NAME, "RefreshBannar")
	-- elseif(g_targetPlatform == kTargetIphone or
	-- 	g_targetPlatform == kTargetIpad)then 
	-- 	printInfo("ios platform...")
	-- 	local luaoc = require"luaoc.lua"
	-- 	local CLASS_NAME = "AdmobAdBridge"
	-- 	luaoc.callStaticMethod(CLASS_NAME, "RefreshBannar")
	-- else
	-- 	printInfo("other platform...")
	-- end 

	GameData.initGolbelData()
	local gameMainScene = cc.Scene:create()
 	gameMainScene:addChild(GamePlayPanel.loadPanelRes())
	gameMainScene:addChild(MenuPanel.loadPanelRes())
	gameMainScene:addChild(StartPanel.loadPanelRes())
	gameMainScene:addChild(ResultPanel.loadPanelRes())
	gameMainScene:addChild(SkinSelectPanel.loadPanelRes())

	local touchLayer = cc.Layer:create()
	touchLayer:setTouchEnabled(true)
	touchLayer:registerScriptTouchHandler(dealWithTouch)
	gameMainScene:addChild(touchLayer)
	return gameMainScene
end

-- 处理屏幕点击事件,判断左右点击
dealWithTouch = function (eventType, x, y)
	printInfo("GameMainScene dealWithTouch...")
	local tmpWinMidX = cc.Director:getInstance():getVisibleOrigin().x + cc.Director:getInstance():getVisibleSize().width/2
	if(not GameData.getIsTouchable())then  -- 不可以点touchlayer 就不响应
		printInfo("GameMainScene cant touch...")
		return false
	end
	if(not GameData.getGameTimerIsStart())then
		GameData.setGameTimerIsStart(true)
		GameData.setGamePlaySchedulerEntry(cc.Director:getInstance():getScheduler():scheduleScriptFunc(gameMainUpdate, 0.03, false))
		GamePlayPanel.setTapMeButtonVisible(false)
	end
	if eventType == "began" then
		if(x < tmpWinMidX)then 
    		printInfo("GameMainScene dealWithTouch left...")
    		if(GamePlayPanel.playHitAnimation(g_touchScreenLeft) == true)then 
    			playerStunGameOver()
    		end
    	else
    		printInfo("GameMainScene dealWithTouch right...")
    		if(GamePlayPanel.playHitAnimation(g_touchScreenRight) == true)then 
    			playerStunGameOver()
    		end
    	end
		return false
    end
end

gameMainUpdate = function (dt) 
	GameData.setAdShowTimer( GameData.getAdShowTimer() + dt)
	
	local showPlayerLevel = math.floor(GameData.getPlayerScore() / GameConstants.LevelUpScore)
	if(showPlayerLevel ~= 0 and GameData.getPlayerScore() ~= 0 and GameData.getPlayerLevel() < showPlayerLevel)then   
		GameData.setPlayerLevel(showPlayerLevel)
		MenuPanel.showLevel()
	end
	GameData.setTimeDecTmp( GameData.getTimeDecTmp() + dt)
	if(GameData.getTimeDecTmp() > GameConstants.LossHpTime)then
		GameData.setPlayerTime(GameData.getPlayerTime() - HpChangeTemplate[GameData.getPlayerLevel()+ 1].hitlossHp)
		GameData.setTimeDecTmp(0)
	end
	if(GameData.getPlayerTime() < 1)then 
		GameData.setPlayerTime(0)
		playerStunGameOver()
	elseif(GameData.getPlayerTime()  > GameData.getTotalTime()  - 1)then
		GameData.setPlayerTime(GameData.getTotalTime())
	end
	MenuPanel.setTimeBar(GameData.getPlayerTime())
end

playerStunGameOver = function ()
	printInfo("GameMainScene playerStun...")
	GameData.setPlayerTotalScore(GameData.getPlayerTotalScore() + GameData.getPlayerScore())
	CCUserDefault:sharedUserDefault():setStringForKey("totalScore",tostring(GameData.getPlayerTotalScore() ))
	if(GameData.getPlayerBestScore() < GameData.getPlayerScore())then 
		CCUserDefault:sharedUserDefault():setStringForKey("bestScore", tostring(GameData.getPlayerScore()))
		GameData.setPlayerBestScore(GameData.getPlayerScore())
	end
	CCUserDefault:sharedUserDefault():setStringForKey("timbermanid", tostring(GameData.getPlayerSkinID()))
	CCUserDefault:sharedUserDefault():setStringForKey("voiceSetting", tostring(GameData.getVoiceSwitch()))
	CCUserDefault:sharedUserDefault():flush()

	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(GameData.getGamePlaySchedulerEntry())
	GameData.setGameTimerIsStart(false)
	GameData.setIsTouchable(false)

	ResultPanel.showPanel()
	MenuPanel.hidePanel()
    SimpleAudioEngine:sharedEngine():stopBackgroundMusic(false)

	if(GameData.getAdShowTimer() > kADTimeInterval)then
		if(kTargetAndroid ==  g_targetPlatform)then 
			printInfo("Android Platform")
			local CLASS_NAME = "com/LeXGame/TowerWrecker/AdMobBridge"
			LuaJavaBridge.callStaticMethod(CLASS_NAME, "CreatePageAd")
		elseif(g_targetPlatform == kTargetIphone or
			g_targetPlatform == kTargetIpad)then 
			printInfo("ios platform...")
			local luaoc = require"luaoc.lua"
			local CLASS_NAME = "AdmobAdBridge"
			luaoc.callStaticMethod(CLASS_NAME, "CreatePageAd")
		else
			printInfo("other platform...")

		end 
		GameData.setAdShowTimer(0)
	end 
end
