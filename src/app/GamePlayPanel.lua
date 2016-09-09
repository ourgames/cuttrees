module("GamePlayPanel", package.seeall)
--游戏背景结点  放在最底层

-- 外部调用函数
-- loadPanelRes 			-- 创建panel
-- changeNodeStyle    		-- 改变背景类型
-- reloadGamePlayPanel
-- releasePanel			  	-- 释放调用ccb使用的表
-- setTapMeButtonVisible

-- skin 相关函数
-- changeSkinPosition
-- changeSkinByTypeID
-- playHitAnimation 




-- 内部函数

-- 调用其他lua
require "TowerNode"
require "SkinNode"


-- GameMainScene内部变量表
local m_variablesTable = {}
-- 宏



loadPanelRes = function ()
	printInfo("GamePlayPanel loadPanelRes")
	m_variablesTable.position = 1
	m_variablesTable.gamePlayPanel = cc.Node:create()
	m_variablesTable.gamePlayNode = cc.Node:create()
	m_variablesTable.playerOffset = 200

	local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    m_variablesTable.gamePlayPanel:setPosition(origin.x + visibleSize.width/2, origin.y + visibleSize.height/2)

	m_variablesTable.mBackgroundNode = m_variablesTable.mBackgroundNode or {}
	ccb["mBackgroundNode"] = m_variablesTable.mBackgroundNode
    local  backgroundCCB  = CCBuilderReaderLoad(BackgroundPath[math.random(3)].path, CCBProxy:create(), m_variablesTable.mBackgroundNode)
    m_variablesTable.backgroundNode = tolua.cast(backgroundCCB,"cc.Node")
    -- m_variablesTable.backgroundNode:setTag(0)
    m_variablesTable.gamePlayPanel:addChild(m_variablesTable.backgroundNode,1)
    -- 放大背景
    if nil ~= m_variablesTable.mBackgroundNode["mBackgroundScaleNode"] then
		local tmpScale = math.max(visibleSize.width/640,visibleSize.height/960)
        printInfo("backgroundScaleNode scale is " .. tmpScale)
        m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:setScale(tmpScale)
	end
    -- 添加塔
	m_variablesTable.towerNode = TowerNode.loadNodeRes()		-- mBackgroundScaleNode
    local trunkPosition = m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:convertToWorldSpace(ccp(m_variablesTable.mBackgroundNode["mTrunkPositionNode"]:getPosition()))
    m_variablesTable.gamePlayNode:addChild(m_variablesTable.towerNode)
    m_variablesTable.towerNode:setPosition(0, trunkPosition.y - visibleSize.height/2)
	-- 添加人物CCB到界面
	m_variablesTable.skinNode = SkinNode.loadNodeRes()
	local playerPosition = m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:convertToWorldSpace(ccp(m_variablesTable.mBackgroundNode["mManLeftPositionNode"]:getPosition()))
    m_variablesTable.gamePlayNode:addChild(m_variablesTable.skinNode)
    m_variablesTable.skinNode:setPosition(-m_variablesTable.playerOffset, playerPosition.y - visibleSize.height/2)
    -- m_variablesTable.gamePlayNode:setTag(0)
	m_variablesTable.gamePlayPanel:addChild(m_variablesTable.gamePlayNode,2)
	-- tapme tips
    m_variablesTable.mTapMeNode = m_variablesTable.mTapMeNode or {}
	ccb["mTapMeNode"] = m_variablesTable.mTapMeNode
    m_variablesTable.mTapMeNodeCCBNode  = tolua.cast(CCBuilderReaderLoad("ccb/background/tapme_button.ccbi",CCBProxy:create(),m_variablesTable.mTapMeNode),"cc.Node")
    m_variablesTable.mTapMeNodeCCBNode:setPosition(0, - visibleSize.height/2 + 100)
    m_variablesTable.mTapMeNodeCCBNode:setVisible(false)
    -- m_variablesTable.mTapMeNodeCCBNode:setTag(0)
    m_variablesTable.gamePlayPanel:addChild(m_variablesTable.mTapMeNodeCCBNode,3)

	return m_variablesTable.gamePlayPanel
end 

-- 删除原有背景界面，添加新的随机背景界面
changePanelStyle = function ()
	printInfo("GamePlayPanel changePanelStyle")
	m_variablesTable.backgroundNode:removeFromParentAndCleanup(true)

	m_variablesTable.mBackgroundNode = m_variablesTable.mBackgroundNode or {}
	ccb["mBackgroundNode"] = m_variablesTable.mBackgroundNode
    local  backgroundCCB  = CCBuilderReaderLoad(BackgroundPath[math.random(3)].path, CCBProxy:create(), m_variablesTable.mBackgroundNode)
    m_variablesTable.backgroundNode = tolua.cast(backgroundCCB,"cc.Node")
    -- m_variablesTable.backgroundNode:setTag(0)
    m_variablesTable.gamePlayPanel:addChild(m_variablesTable.backgroundNode,1)
    -- 放大背景
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    if nil ~= m_variablesTable.mBackgroundNode["mBackgroundScaleNode"] then
		local tmpScale = math.max(visibleSize.width/640,visibleSize.height/960)
        printInfo("backgroundScaleNode scale is " .. tmpScale)
        m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:setScale(tmpScale)
	end
	local trunkPosition = m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:convertToWorldSpace(ccp(m_variablesTable.mBackgroundNode["mTrunkPositionNode"]:getPosition()))
	m_variablesTable.towerNode:setPosition(0, trunkPosition.y - visibleSize.height/2)
	m_variablesTable.position = g_touchScreenLeft
	SkinNode.setLeftorRightStyle(g_touchScreenLeft)
	local playerPosition = m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:convertToWorldSpace(ccp(m_variablesTable.mBackgroundNode["mManLeftPositionNode"]:getPosition()))
	m_variablesTable.skinNode:setPosition(-m_variablesTable.playerOffset, playerPosition.y - visibleSize.height/2)
end


changeSkinByTypeID = function (skinNumberID)
	printInfo("GamePlayPanel changeSkinByTypeID")
	-- set position to left
	changeSkinPosition(g_touchScreenLeft)
	SkinNode.changeNodeStyle(skinNumberID)
end

changeSkinPosition = function (touchLeftorRight)
	printInfo("GamePlayPanel changeSkinPosition")
	if(m_variablesTable.position == touchLeftorRight)then 
		return
	end
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	m_variablesTable.position = touchLeftorRight
	local playerPosition = m_variablesTable.mBackgroundNode["mBackgroundScaleNode"]:convertToWorldSpace(ccp(m_variablesTable.mBackgroundNode["mManLeftPositionNode"]:getPosition()))
	if(g_touchScreenLeft == touchLeftorRight)then
		-- 添加人物CCB到界面
	    m_variablesTable.skinNode:setPosition(-m_variablesTable.playerOffset, playerPosition.y - visibleSize.height/2)
	elseif(g_touchScreenRight == touchLeftorRight)then
		m_variablesTable.skinNode:setPosition(m_variablesTable.playerOffset, playerPosition.y - visibleSize.height/2)
	else 
		printInfo("GamePlayPanel changeSkinPosition ERROR")
	end
	SkinNode.setLeftorRightStyle(touchLeftorRight)
end 

-- 返回是否撞树
playHitAnimation = function (touchLeftorRight)
	printInfo("GamePlayPanel playHitAnimation...")
	changeSkinPosition(touchLeftorRight)
	if(TowerNode.getBaseTowerType() == touchLeftorRight)then 
		playStunAnimation()
		return true
	end 
	-- 一系列动作
	SkinNode.showHitAnimation()
	TowerNode.hitTowerAnimations(touchLeftorRight)
	if(GameData.getVoiceSwitch())then
		GameData.playCutTreeEffect()
	end
	-- 数据与显示的相关变化
	GameData.setPlayerScore(GameData.getPlayerScore() + GameConstants.HitScore)
	GameData.setPlayerTime(GameData.getPlayerTime() + GameConstants.HitAddHp)
	MenuPanel.setCurrentScore(GameData.getPlayerScore())
	MenuPanel.setTimeBar(GameData.getPlayerTime())

	if(TowerNode.getBaseTowerType() == touchLeftorRight)then
		playStunAnimation() 
		return true
	end
	-- 播完击打后播放人stand动画
	local runStandAction = function()
		SkinNode.showStandAnimation()
 	end
	m_variablesTable.skinNode:runAction(CCSequence:create(CCDelayTime:create(0.09), CCCallFuncN:create(runStandAction)))
	return false
end 

playStunAnimation = function ()
	printInfo("GamePlayPanel playStunAnimation...")
	SkinNode.showStunAnimation()
	if(GameData.getVoiceSwitch())then
		GameData.playpManDieEffectPath()
	end
end

reloadGamePlayPanel = function ()
	printInfo("GamePlayPanel reloadTowerNode")
	changePanelStyle()
    TowerNode.reloadNodeRes()
    SkinNode.showStandAnimation()
end

setTapMeButtonVisible = function (bool_var)
	m_variablesTable.mTapMeNodeCCBNode:setVisible(bool_var)
end

releasePanel = function ()
	printInfo("GamePlayPanel releasePanel")
	TowerNode.releaseNode()
	if(nil ~= m_variablesTable.mBackgroundNode)then
		m_variablesTable.gamePlayPanel:removeAllChildren(true)
	 	m_variablesTable.mBackgroundNode = nil
	end
end













