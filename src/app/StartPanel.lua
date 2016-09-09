module("StartPanel", package.seeall)
-- 开始界面panel

-- 外部调用函数
-- loadPanelRes
-- showPanel


-- 内部函数
local hidePanel
local onListButtonClick
local onStartButtonClick
local onSkinSelectClick

-- 调用其他lua



-- 内部变量表
local m_variablesTable = {}


loadPanelRes = function ()
	printInfo("StartPanel loadPanelRes")
	m_variablesTable.skinSelectPanel = cc.Node:create()
	local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    m_variablesTable.skinSelectPanel:setPosition(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)

	m_variablesTable.mStartPanelNode = m_variablesTable.mStartPanelNode or {}
	ccb["mStartPanelNode"] = m_variablesTable.mStartPanelNode

	m_variablesTable.mStartPanelNode["onListButtonClick"] 	= onListButtonClick
	m_variablesTable.mStartPanelNode["onStartButtonClick"] 	= onStartButtonClick
	m_variablesTable.mStartPanelNode["onSkinSelectClick"] 	= onSkinSelectClick


    local  skinSelectPanelCCB  = CCBuilderReaderLoad("ccb/start_panel.ccbi",CCBProxy:create(),m_variablesTable.mStartPanelNode)
    m_variablesTable.skinSelectPanel:addChild(tolua.cast(skinSelectPanelCCB,"cc.Node"))

    showPanel()
	return m_variablesTable.skinSelectPanel
end

showPanel = function ()
	printInfo("StartPanel showPanel")
    m_variablesTable.mStartPanelNode["mAnimationManager"]:runAnimationsForSequenceNamed("move_in")
end 

hidePanel = function ()
	printInfo("StartPanel hidePanel")
    m_variablesTable.mStartPanelNode["mAnimationManager"]:runAnimationsForSequenceNamed("move_out")
end 


onListButtonClick = function ()
	printInfo("StartPanel onListButtonClick")
	-- 显示排名面板（未实现）

end 

onStartButtonClick = function ()
	printInfo("StartPanel onStartButtonClick")
	MenuPanel.showPanel()
	GameData.setIsTouchable (true)
	hidePanel()
    if(GameData.getVoiceSwitch())then
		GameData.playBackgroudMusic()
	end
	GamePlayPanel.setTapMeButtonVisible(true)
end 

onSkinSelectClick = function ()
	printInfo("StartPanel onSkinSelectClick")
	hidePanel()
	SkinSelectPanel.showPanel()
end 

