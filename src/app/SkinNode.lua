module("SkinNode", package.seeall)
-- 人物皮肤Node

-- 外部调用函数
-- loadNodeRes
-- setLeftorRightStyle
-- showStandAnimation
-- showHitAnimation
-- showStunAnimation
-- changeNodeStyle
-- releaseNode	

-- 内部函数


-- 调用其他lua



-- 内部变量表
local m_variablesTable = {}

-- 宏


loadNodeRes = function ()
	printInfo("SkinNode loadNodeRes...")
	m_variablesTable.skinNode = cc.Node:create()

	m_variablesTable.mSkinCollectionNode = m_variablesTable.mSkinCollectionNode or {}
	ccb["mSkinCollectionNode"] = m_variablesTable.mSkinCollectionNode
    local  SkinNodeCCB  = CCBuilderReaderLoad(UnlockRoleTemplate[GameData.getPlayerSkinID()].ccbipath, CCBProxy:create(), m_variablesTable.mSkinCollectionNode)
    m_variablesTable.skinNode:addChild(tolua.cast(SkinNodeCCB,"cc.Node"))

    showStandAnimation()

	return m_variablesTable.skinNode
end

setLeftorRightStyle = function (leftorRight)
	printInfo("SkinNode setLeftorRight...")
	if(g_touchScreenLeft == leftorRight)then 
		m_variablesTable.mSkinCollectionNode["mSkinManSprite"]:setFlipX(false)
	elseif(g_touchScreenRight == leftorRight)then 
		m_variablesTable.mSkinCollectionNode["mSkinManSprite"]:setFlipX(true)
	else 
		printInfo("SkinNode setLeftorRight ERROR")
	end
end 

showStandAnimation = function ()
	printInfo("SkinNode showStandAnimation...")
    m_variablesTable.mSkinCollectionNode["mStunSprite"]:setVisible(false)
	m_variablesTable.mSkinCollectionNode["mAnimationManager"]:runAnimationsForSequenceNamed("skin_stand")
end

showHitAnimation = function ()
	printInfo("SkinNode showHitAnimation...")
	m_variablesTable.mSkinCollectionNode["mStunSprite"]:setVisible(false)
	m_variablesTable.mSkinCollectionNode["mAnimationManager"]:runAnimationsForSequenceNamed("skin_hit")
end 

showStunAnimation = function ()
	printInfo("SkinNode showStunAnimation...")
	m_variablesTable.skinNode:stopAllActions()
    m_variablesTable.mSkinCollectionNode["mStunSprite"]:setVisible(true)
	m_variablesTable.mSkinCollectionNode["mAnimationManager"]:runAnimationsForSequenceNamed("skin_stun")
end

changeNodeStyle = function (skinNumberID)
	printInfo("SkinNode changeNodeStyle")
	if(nil ~= m_variablesTable.mSkinCollectionNode)then
		m_variablesTable.skinNode:removeAllChildren(true)
 		m_variablesTable.mSkinCollectionNode = nil
		ccb["mSkinCollectionNode"] = nil
	end

	m_variablesTable.mSkinCollectionNode = m_variablesTable.mSkinCollectionNode or {}
	ccb["mSkinCollectionNode"] = m_variablesTable.mSkinCollectionNode
    local  SkinNodeCCB  = CCBuilderReaderLoad(UnlockRoleTemplate[skinNumberID].ccbipath, CCBProxy:create(), m_variablesTable.mSkinCollectionNode)
    m_variablesTable.skinNode:addChild(tolua.cast(SkinNodeCCB,"cc.Node"))

    showStandAnimation()
end






