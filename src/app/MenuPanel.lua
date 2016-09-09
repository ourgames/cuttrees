module("MenuPanel", package.seeall)
-- 显示结果的panel

-- 外部调用函数
-- loadPanelRes
-- showPanel
-- hidePanel
-- showLevel
-- setTimeBar
-- setCurrentScore
-- reloadPanelRes

-- 内部函数


-- 调用其他lua



-- 内部变量表
local m_variablesTable = {}
	

loadPanelRes = function ()
	printInfo("MenuPanel loadPanelRes")
	m_variablesTable.menuPanel = cc.Node:create()
	local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    m_variablesTable.menuPanel:setPosition(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)

	m_variablesTable.mMenuPanel = m_variablesTable.mMenuPanel or {}
	ccb["mMenuPanel"] = m_variablesTable.mMenuPanel

	m_variablesTable.mMenuPanel["onVoiceNoneButtonClick"] 	= onVoiceSwitchClick
	m_variablesTable.mMenuPanel["onVoiceButtonClick"] 	= onVoiceSwitchClick

    local  skinSelectPanelCCB  = CCBuilderReaderLoad("ccb/menu_panel.ccbi",CCBProxy:create(),m_variablesTable.mMenuPanel)
    m_variablesTable.menuPanel:addChild(tolua.cast(skinSelectPanelCCB,"cc.Node"))

	m_variablesTable.progressTimerNode=CCProgressTimer:create(cc.Sprite:create("image/menu_panel/time_bar.png"));
    m_variablesTable.progressTimerNode:setType(kCCProgressTimerTypeBar)
	m_variablesTable.progressTimerNode:setMidpoint(ccp(0, 0));  
	m_variablesTable.progressTimerNode:setBarChangeRate(ccp(1, 0));  
	m_variablesTable.progressTimerNode:setPosition(6, 0)
	m_variablesTable.progressTimerNode:setPercentage( GameData.getPlayerTime() / GameData.getTotalTime() * 100)
	m_variablesTable.mMenuPanel["mProgressTimerNode"]:addChild(m_variablesTable.progressTimerNode)  

	if(GameData.getVoiceSwitch())then 
		m_variablesTable.mMenuPanel["mVoiceNoneButton"]:setVisible(false)
		m_variablesTable.mMenuPanel["mVoiceButton"]:setVisible(true)
	else
		m_variablesTable.mMenuPanel["mVoiceButton"]:setVisible(false)
		m_variablesTable.mMenuPanel["mVoiceNoneButton"]:setVisible(true)
	end
	setCurrentScore(0)
    m_variablesTable.menuPanel:setVisible(false)

    -- 设置位置
	m_variablesTable.mMenuPanel["mMenuTopNode"]:setPosition(0, cc.Director:getInstance():getVisibleSize().height/2 - 120)
	m_variablesTable.mMenuPanel["mPlayerCurrentScore"]:setPosition(0,cc.Director:getInstance():getVisibleSize().height/4 - 60)
	return m_variablesTable.menuPanel
end

reloadPanelRes = function ()
	m_variablesTable.mMenuPanel["mPlayerCurrentScoreNode"]:removeAllChildren(true)
	m_variablesTable.mMenuPanel["mPlayerCurrentScoreNode"]:addChild(createNodeFromNumber(GameData.getPlayerScore()))
	setTimeBar(GameData.getPlayerTime())
	m_variablesTable.mMenuPanel["mLevelNode"]:removeAllChildren(true)
	m_variablesTable.mMenuPanel["mLevelNode"]:addChild(createNodeFromNumber(GameData.getPlayerLevel()))

	showPanel()
end 

setCurrentScore = function (nScoreNum)
	m_variablesTable.mMenuPanel["mPlayerCurrentScoreNode"]:removeAllChildren(true)
	m_variablesTable.mMenuPanel["mPlayerCurrentScoreNode"]:addChild(createNodeFromNumber(nScoreNum))
end 

setTimeBar = function (nTimeNum) 
	m_variablesTable.progressTimerNode:setPercentage(nTimeNum / GameData.getTotalTime() * 100)
end 

onVoiceSwitchClick = function ()
	printInfo("MenuPanel onVoiceSwitchClick")
	if(GameData.getVoiceSwitch())then 
		--关声音
		SimpleAudioEngine:sharedEngine():stopAllEffects()
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic(false);
		m_variablesTable.mMenuPanel["mVoiceButton"]:setVisible(false)
		m_variablesTable.mMenuPanel["mVoiceNoneButton"]:setVisible(true)
	else 
		--开声音
		GameData.playBackgroudMusic()
		m_variablesTable.mMenuPanel["mVoiceNoneButton"]:setVisible(false)
		m_variablesTable.mMenuPanel["mVoiceButton"]:setVisible(true)
	end
	GameData.setVoiceSwitch(not GameData.getVoiceSwitch())
end 

showPanel = function ()
	printInfo("MenuPanel showPanel")
	m_variablesTable.menuPanel:setVisible(true)
    local animationMgr = tolua.cast(m_variablesTable.mMenuPanel["mAnimationManager"],"CCBAnimationManager")
    animationMgr:runAnimationsForSequenceNamed("move_in")
end 

hidePanel = function ()
	printInfo("MenuPanel hidePanel")
    local animationMgr = tolua.cast(m_variablesTable.mMenuPanel["mAnimationManager"],"CCBAnimationManager")
    animationMgr:runAnimationsForSequenceNamed("move_out")
end

showLevel = function ()
	printInfo("MenuPanel showLevel")
	m_variablesTable.mMenuPanel["mLevelNode"]:removeAllChildren(true)
	m_variablesTable.mMenuPanel["mLevelNode"]:addChild(createNodeFromNumber(GameData.getPlayerLevel()))
    m_variablesTable.mMenuPanel["mAnimationManager"]:runAnimationsForSequenceNamed("level_in")
	local runLevelOut = function()
		m_variablesTable.mMenuPanel["mAnimationManager"]:runAnimationsForSequenceNamed("level_out")
	end
	m_variablesTable.menuPanel:runAction(CCSequence:create(CCDelayTime:create(1),CCCallFuncN:create(runLevelOut)))
end 



