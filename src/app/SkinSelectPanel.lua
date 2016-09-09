module("SkinSelectPanel", package.seeall)
-- 

-- 外部调用函数
-- loadPanelRes
-- showPanel
-- 

-- 内部函数
local showSelectPanelVariable
local hidePanel
local onSelectLeftButtonClick
local onSelectButtonClick
local onSelectRightButtonClick

-- 调用其他lua



-- 内部变量表
local m_variablesTable = {}
	

loadPanelRes = function ()
	printInfo("SkinSelectPanel loadPanelRes")
	m_variablesTable.localSkinNumberID = GameData.getPlayerSkinID()
	m_variablesTable.locaIsGameStart = GameData.getIsGameStart()

	m_variablesTable.skinSelectPanel = cc.Node:create()
	local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    m_variablesTable.skinSelectPanel:setPosition(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)

	m_variablesTable.mSelectManPanel = m_variablesTable.mSelectManPanel or {}
	ccb["mSelectManPanel"] = m_variablesTable.mSelectManPanel

	m_variablesTable.mSelectManPanel["onSelectLeftButtonClick"] 	= onSelectLeftButtonClick
	m_variablesTable.mSelectManPanel["onSelectButtonClick"] 		= onSelectButtonClick
	m_variablesTable.mSelectManPanel["onSelectRightButtonClick"] 	= onSelectRightButtonClick

    local  skinSelectPanelCCB  = CCBuilderReaderLoad("ccb/skin_select_panel.ccbi",CCBProxy:create(),m_variablesTable.mSelectManPanel)
    m_variablesTable.skinSelectPanel:addChild(tolua.cast(skinSelectPanelCCB,"cc.Node"))

    m_variablesTable.skinSelectPanel:setVisible(false)
	return m_variablesTable.skinSelectPanel
end

showPanel = function ()
	printInfo("SkinSelectPanel showPanel")
	m_variablesTable.skinSelectPanel:setVisible(true)

	if(m_variablesTable.localSkinNumberID == #UnlockRoleTemplate)then 
		m_variablesTable.mSelectManPanel["mSelectRightButton"]:setEnabled(false)
	end
	if(m_variablesTable.localSkinNumberID  == 1)then 
		m_variablesTable.mSelectManPanel["mSelectLeftButton"]:setEnabled(false)
	end 

	m_variablesTable.mSelectManPanel["mSelectPanelBestScore"]:removeAllChildren(true)
	m_variablesTable.mSelectManPanel["mSelectPanelBestScore"]:addChild(createNodeFromNumber(GameData.getPlayerBestScore()))
	m_variablesTable.mSelectManPanel["mSelectPanelTotalScore"]:removeAllChildren(true)
	m_variablesTable.mSelectManPanel["mSelectPanelTotalScore"]:addChild(createNodeFromNumber(GameData.getPlayerTotalScore()))
	showSelectPanelVariable()
	
    m_variablesTable.mSelectManPanel["mAnimationManager"]:runAnimationsForSequenceNamed("move_in")
end 

showSelectPanelVariable = function ()
	printInfo("SkinSelectPanel showSelectPanelVariable")
	-- remove old data
	m_variablesTable.mSelectManPanel["mSelectPanelSkinName"]:removeAllChildren(true)
	m_variablesTable.mSelectManPanel["mSelectPanelSkinName"]:addChild(cc.Sprite:create(UnlockRoleTemplate[m_variablesTable.localSkinNumberID].name))	 -- 名字
	
	m_variablesTable.mSelectManPanel["mSelectPanelUnlockScore"]:removeAllChildren(true)
	m_variablesTable.mSelectManPanel["mSelectPanelUnlockTotalScore"]:removeAllChildren(true)
	m_variablesTable.mSelectManPanel["mSelectPanelUncheckedTitle"]:setVisible(false)
	m_variablesTable.mSelectManPanel["mSelectPanelScoreTitle"]:setVisible(false)
	m_variablesTable.mSelectManPanel["mSelectPanelChopTitle"]:setVisible(false)

	if 	UnlockRoleTemplate[m_variablesTable.localSkinNumberID].score <= GameData.getPlayerBestScore() or 
		UnlockRoleTemplate[m_variablesTable.localSkinNumberID].total <= GameData.getPlayerTotalScore() then 
		m_variablesTable.mSelectManPanel["mSelectButton"]:setEnabled(true)
		m_variablesTable.mSelectManPanel["mSelectPanelUncheckedTitle"]:setVisible(true)
	else 
		m_variablesTable.mSelectManPanel["mSelectButton"]:setEnabled(false)
		m_variablesTable.mSelectManPanel["mSelectPanelUnlockScore"]:removeAllChildren(true)
		m_variablesTable.mSelectManPanel["mSelectPanelUnlockScore"]:addChild(createNodeFromNumber(UnlockRoleTemplate[m_variablesTable.localSkinNumberID].score))
		m_variablesTable.mSelectManPanel["mSelectPanelUnlockTotalScore"]:removeAllChildren(true)
		m_variablesTable.mSelectManPanel["mSelectPanelUnlockTotalScore"]:addChild(createNodeFromNumber(UnlockRoleTemplate[m_variablesTable.localSkinNumberID].total))
		m_variablesTable.mSelectManPanel["mSelectPanelScoreTitle"]:setVisible(true)
		m_variablesTable.mSelectManPanel["mSelectPanelChopTitle"]:setVisible(true)
	end 
	GamePlayPanel.changeSkinByTypeID(m_variablesTable.localSkinNumberID)
end 

hidePanel = function ()
	printInfo("ResultPanel hidePanel")
	m_variablesTable.locaIsGameStart = true
    m_variablesTable.mSelectManPanel["mAnimationManager"]:runAnimationsForSequenceNamed("move_out")
end 

onSelectLeftButtonClick = function ()
	printInfo("ResultPanel onSelectLeftButtonClick")
	if(m_variablesTable.localSkinNumberID == #UnlockRoleTemplate)then 
		m_variablesTable.mSelectManPanel["mSelectRightButton"]:setEnabled(true)
	end
	m_variablesTable.localSkinNumberID  = m_variablesTable.localSkinNumberID  - 1
	if(m_variablesTable.localSkinNumberID  == 1)then 
		m_variablesTable.mSelectManPanel["mSelectLeftButton"]:setEnabled(false)
	end 
	showSelectPanelVariable()
end 

onSelectButtonClick = function ()
	printInfo("ResultPanel onSelectButtonClick")
	GameData.setPlayerSkinID(m_variablesTable.localSkinNumberID)
	hidePanel()
	if(m_variablesTable.locaIsGameStart)then 
		ResultPanel.showPanel()
	else 
		StartPanel.showPanel()
	end 
end 

onSelectRightButtonClick = function ()
	printInfo("ResultPanel onSelectRightButtonClick")
	if(m_variablesTable.localSkinNumberID == 1)then 
		m_variablesTable.mSelectManPanel["mSelectLeftButton"]:setEnabled(true)
	end
	m_variablesTable.localSkinNumberID  = m_variablesTable.localSkinNumberID  + 1
	if(m_variablesTable.localSkinNumberID  == #UnlockRoleTemplate)then 
		m_variablesTable.mSelectManPanel["mSelectRightButton"]:setEnabled(false)
	end 
	showSelectPanelVariable()
end 



