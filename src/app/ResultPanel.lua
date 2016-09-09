module("ResultPanel", package.seeall)
-- 显示结果的panel

-- 外部调用函数
-- loadPanelRes
-- showPanel
-- hidePanel

-- 内部函数
local onListButtonClick
local onStartButtonClick
local onSkinSelectClick

-- 调用其他lua



-- 内部变量表
local m_variablesTable = {}
	

loadPanelRes = function ()
	m_variablesTable.resultPanelNode = cc.Node:create()
	local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    m_variablesTable.resultPanelNode:setPosition(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)

	m_variablesTable.mResultPanelNode = m_variablesTable.mResultPanelNode or {}
	ccb["mResultPanelNode"] = m_variablesTable.mResultPanelNode

	m_variablesTable.mResultPanelNode["onListButtonClick"] 	= onListButtonClick
	m_variablesTable.mResultPanelNode["onStartButtonClick"] 	= onStartButtonClick
	m_variablesTable.mResultPanelNode["onSkinSelectClick"] 	= onSkinSelectClick


    local  skinSelectPanelCCB  = CCBuilderReaderLoad("ccb/result_panel.ccbi",CCBProxy:create(),m_variablesTable.mResultPanelNode)
    m_variablesTable.resultPanelNode:addChild(tolua.cast(skinSelectPanelCCB,"cc.Node"))

    m_variablesTable.resultPanelNode:setVisible(false)
	return m_variablesTable.resultPanelNode
end

showPanel = function ()
	m_variablesTable.resultPanelNode:setVisible(true)
	printInfo("ResultPanel showPanel")
	m_variablesTable.mResultPanelNode["mResultPanelScoreNode"]:removeAllChildren(true)
	m_variablesTable.mResultPanelNode["mResultPanelScoreNode"]:addChild(createNodeFromNumber(GameData.getPlayerScore()))
	m_variablesTable.mResultPanelNode["mResultPanelBestNode"]:removeAllChildren(true)
	m_variablesTable.mResultPanelNode["mResultPanelBestNode"]:addChild(createNodeFromNumber(GameData.getPlayerBestScore()))
    tolua.cast(m_variablesTable.mResultPanelNode["mAnimationManager"],"CCBAnimationManager"):runAnimationsForSequenceNamed("move_in")
end 


hidePanel = function ()
	printInfo("ResultPanel hidePanel")
    tolua.cast(m_variablesTable.mResultPanelNode["mAnimationManager"],"CCBAnimationManager"):runAnimationsForSequenceNamed("move_out")
end 

onListButtonClick = function ()
	printInfo("ResultPanel onListButtonClick")
	-- 显示排名面板（未实现）

end 

onStartButtonClick = function ()
	printInfo("ResultPanel onStartButtonClick")
	GameData.reinitGolbelData()
	GamePlayPanel.reloadGamePlayPanel()
	MenuPanel.reloadPanelRes()
	hidePanel()
	GamePlayPanel.setTapMeButtonVisible(true)
    if(GameData.getVoiceSwitch())then
		GameData.playBackgroudMusic()
	end
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
end 

onSkinSelectClick = function ()
	printInfo("ResultPanel onSkinSelectClick")
	hidePanel()
	SkinSelectPanel.showPanel()
end 

