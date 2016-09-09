module("TowerNode", package.seeall)
-- tower 显示

-- 外部调用函数
-- loadNodeRes
-- releaseNode
-- hitTowerAnimations
-- reloadNodeRes
-- getBaseTowerType
 
-- 内部函数
local changeTowerLevelRes
local createNextLevelSeed
local initCanShowTower


-- 调用其他lua


-- 内部变量表
local m_variablesTable 	= {}

-- 与塔相关值
-- local kTrunkTypeNum		= #TrunkTypeToPath	-- 塔的种类
-- local kTrunkHeight 		= 134				-- 一层的高度
-- local kTrunkFlyAir 		= 1 				-- 估计最多空中的个数
-- local kTrunkCanShow 	= 2
-- local kMaxTowerSize 	= 5

local kTrunkTypeNum		= #TrunkTypeToPath	-- 塔的种类
local kTrunkHeight 		= 134				-- 一层的高度
local kTrunkFlyAir 		= 10 				-- 估计最多空中的个数
local kTrunkCanShow 	= math.ceil(cc.Director:getInstance():getVisibleSize().height / kTrunkHeight)
local kMaxTowerSize 	= math.ceil((kTrunkCanShow + kTrunkFlyAir) / kTrunkTypeNum) * kTrunkTypeNum
-- towerblock ccb值
kTowerSubNode			= 0
kTrunkSpriteTag 		= 0
kLeftBranchSpriteTag 	= 1
kRightBranchSpriteTag 	= 2
-- 塔掉落时间
kTowerFallTime 			= 0.1


loadNodeRes = function ()
	printInfo("TowerNode loadNodeRes...")
	m_variablesTable.towerNode = cc.Node:create()

	m_variablesTable.towerNodeCollection = queueCreate(kMaxTowerSize, kTrunkCanShow + 1)

	printInfo("TowerNode loadNodeRes create towercollection")
	m_variablesTable.currentTypeID = 1
	for tmpPtr=1, kMaxTowerSize do
		local currentTowerBlockNode = nil
		local currentTowerBlockCCBTable = {}
		ccb["mTowerNode"] = currentTowerBlockCCBTable

		local towerBlockCCB = CCBuilderReaderLoad("ccb/tower_block.ccbi", CCBProxy:create(), currentTowerBlockCCBTable)
		currentTowerBlockNode = tolua.cast(towerBlockCCB, "cc.Node")

		if tmpPtr <= kTrunkCanShow then
			m_variablesTable.towerNode:addChild(currentTowerBlockNode)
			currentTowerBlockNode:setPosition(0 , kTrunkHeight * (tmpPtr - 1))
		else 
			currentTowerBlockNode:setPosition(0 , kTrunkHeight * (kTrunkCanShow - 1))
		end
		local tmpTowerNodeQueueItem = {}  -- 参看ccb结构
		tmpTowerNodeQueueItem.towerBlockNode = currentTowerBlockNode
		tmpTowerNodeQueueItem.towerBlockNodeType = 0
		tmpTowerNodeQueueItem.towerBlockAnimationManager = currentTowerBlockCCBTable["mAnimationManager"]
		queuePush(m_variablesTable.towerNodeCollection, tmpTowerNodeQueueItem)

		currentTowerBlockNode:retain()
		changeTowerLevelRes(currentTowerBlockNode:getChildByTag(kTowerSubNode))
	end
	initCanShowTower()
	return m_variablesTable.towerNode
end 

-- 设置显示的节点类型
initCanShowTower = function ()
	printInfo("TowerNode initCanShowTower")
	local towerNodeCollection = m_variablesTable.towerNodeCollection
	for tmpCollectionPtr = towerNodeCollection.first, towerNodeCollection.topDataNum - 1 do
		local tmpTowerBlockSubNode =  towerNodeCollection[tmpCollectionPtr].towerBlockNode:getChildByTag(kTowerSubNode)
		local tmpNextSeed = createNextLevelSeed(tmpCollectionPtr)
		if(tmpNextSeed == 0)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 0
		elseif(tmpNextSeed == 1)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 1
			tmpTowerBlockSubNode:getChildByTag(kLeftBranchSpriteTag):setVisible(true)
		elseif(tmpNextSeed == 2)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 2
			tmpTowerBlockSubNode:getChildByTag(kRightBranchSpriteTag):setVisible(true)
		else 
			printInfo("TowerNode initCanShowTower ERROR tmpNextSeed")
		end
	end
end 

reloadNodeRes = function ()
	printInfo("TowerNode reloadNodeRes")
	local towerNodeCollection = m_variablesTable.towerNodeCollection
	for tmpCollectionPtr = towerNodeCollection.first, towerNodeCollection.topDataNum - 1 do
		local tmpTowerBlockSubNode =  towerNodeCollection[tmpCollectionPtr].towerBlockNode:getChildByTag(kTowerSubNode)
		tmpTowerBlockSubNode:getChildByTag(kLeftBranchSpriteTag):setVisible(false)
		tmpTowerBlockSubNode:getChildByTag(kRightBranchSpriteTag):setVisible(false)
		local tmpNextSeed = createNextLevelSeed(tmpCollectionPtr)
		if(tmpNextSeed == 0)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 0
		elseif(tmpNextSeed == 1)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 1
			tmpTowerBlockSubNode:getChildByTag(kLeftBranchSpriteTag):setVisible(true)
		elseif(tmpNextSeed == 2)then 
			towerNodeCollection[tmpCollectionPtr].towerBlockNodeType = 2
			tmpTowerBlockSubNode:getChildByTag(kRightBranchSpriteTag):setVisible(true)
		else 
			printInfo("TowerNode reloadNodeRes ERROR")
		end
	end
end 

getBaseTowerType = function ()
	return queueFront(m_variablesTable.towerNodeCollection).towerBlockNodeType
end

hitTowerAnimations = function (touchLeftorRight)
	printInfo("TowerNode hitTowerAnimations")
	local towerNodeCollection = m_variablesTable.towerNodeCollection
	-- tower set position
	for tmpCollectionPtr=m_variablesTable.towerNodeCollection.first, m_variablesTable.towerNodeCollection.topDataNum do
		m_variablesTable.towerNodeCollection[tmpCollectionPtr].towerBlockNode:stopAllActions()
		m_variablesTable.towerNodeCollection[tmpCollectionPtr].towerBlockNode:setPosition(0, (tmpCollectionPtr-m_variablesTable.towerNodeCollection.first) * kTrunkHeight)
	end
	queueFront(towerNodeCollection).towerBlockNode:setZOrder(towerNodeCollection.topDataNum)
	if( g_touchScreenRight == touchLeftorRight)then
		queueFront(towerNodeCollection).towerBlockAnimationManager:runAnimationsForSequenceNamed("tower_left_fly")
	elseif(g_touchScreenLeft == touchLeftorRight)then
		queueFront(towerNodeCollection).towerBlockAnimationManager:runAnimationsForSequenceNamed("tower_right_fly")
	else 
		printInfo("TowerNode hitTowerAnimations ERROR touchLeftorRight")
	end
	local runRmoveNodeAction = function(sender)
		sender:removeFromParentAndCleanup(false)
 	end
	queueFront(towerNodeCollection).towerBlockNode:runAction(CCSequence:create(CCDelayTime:create(0.5), CCCallFuncN:create(runRmoveNodeAction)))
	
	local tmpTopTowerNode = queueTopData(towerNodeCollection).towerBlockNode
	m_variablesTable.towerNode:addChild(tmpTopTowerNode)
	tmpTopTowerNode:getChildByTag(kTowerSubNode):getChildByTag(kLeftBranchSpriteTag):setVisible(false)
	tmpTopTowerNode:getChildByTag(kTowerSubNode):getChildByTag(kRightBranchSpriteTag):setVisible(false)
	local tmpNextSeed = createNextLevelSeed(towerNodeCollection.topDataNum)
	if(tmpNextSeed == 0)then 
		queueTopData(towerNodeCollection).towerBlockNodeType = 0
	elseif(tmpNextSeed == 1)then 
		queueTopData(towerNodeCollection).towerBlockNodeType = 1
		tmpTopTowerNode:getChildByTag(kTowerSubNode):getChildByTag(kLeftBranchSpriteTag):setVisible(true)
	elseif(tmpNextSeed == 2)then 
		queueTopData(towerNodeCollection).towerBlockNodeType = 2
		tmpTopTowerNode:getChildByTag(kTowerSubNode):getChildByTag(kRightBranchSpriteTag):setVisible(true)
	else 
		printInfo("TowerNode hitTowerAnimations ERROR tmpNextSeed")
	end
	tmpTopTowerNode:setZOrder(towerNodeCollection.topDataNum)  -- z-index
	queueTopData(towerNodeCollection).towerBlockAnimationManager:runAnimationsForSequenceNamed("tower_stand")
	queuePop(towerNodeCollection)
	-- -- tower fall down
	for tmpCollectionPtr = towerNodeCollection.first, towerNodeCollection.topDataNum - 1 do
		m_variablesTable.towerNodeCollection[tmpCollectionPtr].towerBlockNode:runAction(CCMoveBy:create(kTowerFallTime, ccp(0, - kTrunkHeight)))
	end
end 

changeTowerLevelRes = function (towerLevelNode)
	printInfo("TowerNode changeTowerLevelRes...")
	local tmpTrunkResName = nil
	local tmpBranchResName = nil
	if m_variablesTable.currentTypeID > 0 and m_variablesTable.currentTypeID <= kTrunkTypeNum then 
		tmpTrunkResName = TrunkTypeToPath[m_variablesTable.currentTypeID].trunkpath
		tmpBranchResName = TrunkTypeToPath[m_variablesTable.currentTypeID].branchPath
	else
		printInfo("TowerNode changeTowerLevelRes ERROR currentTypeID")
		printInfo("currentTypeID must between 1 and kTrunkTypeNum...")
	end

	local tmpLeftBranchSpriteFrame = cc.SpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tmpBranchResName)
	towerLevelNode:getChildByTag(kLeftBranchSpriteTag):setSpriteFrame(tmpLeftBranchSpriteFrame)
	towerLevelNode:getChildByTag(kLeftBranchSpriteTag):setVisible(false)
	local tmpRightBranchSpriteFrame = cc.SpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tmpBranchResName)
	towerLevelNode:getChildByTag(kRightBranchSpriteTag):setSpriteFrame(tmpRightBranchSpriteFrame)
	towerLevelNode:getChildByTag(kRightBranchSpriteTag):setVisible(false)
	local tmpTrunkSpriteFrame = cc.SpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tmpTrunkResName)
	towerLevelNode:getChildByTag(kTrunkSpriteTag):setSpriteFrame(tmpTrunkSpriteFrame)

	m_variablesTable.currentTypeID = m_variablesTable.currentTypeID + 1
	if m_variablesTable.currentTypeID > kTrunkTypeNum then 
		m_variablesTable.currentTypeID = 1
	end 
end

releaseNode = function ()
	printInfo("TowerNode releasePanel")
	for tmpCollectionPtr=m_variablesTable.towerNodeCollection.first, m_variablesTable.towerNodeCollection.last do
		m_variablesTable.towerNodeCollection[tmpCollectionPtr].towerBlockNode:release()
	end
end

-- 实现自定义生成种子
createNextLevelSeed = function (currentNodePtr)
	printInfo("TowerNode createNextLevelSeed")
	local towerNodeCollection = m_variablesTable.towerNodeCollection
	if  currentNodePtr - towerNodeCollection.first> 2 then
		local tmpType1 = towerNodeCollection[currentNodePtr - 1].towerBlockNodeType
		local tmpType2 = towerNodeCollection[currentNodePtr - 2].towerBlockNodeType

		if tmpType1 == tmpType2 and tmpType1 ~= 0 then 
			local tmpSeed = math.random(60)  > 10
			if(tmpSeed)then 
				return 0
			else
				return tmpType1
			end
		elseif tmpType1 == 0  and tmpType2 == 1 then
			local tmpSeed = math.random(60)  > 10
			if(tmpSeed)then 
				return 2
			else
				return 1
			end
		elseif tmpType1 == 0  and tmpType2 == 2 then
			local tmpSeed = math.random(60)  > 10
			if(tmpSeed)then 
				return 1
			else
				return 2
			end
		elseif tmpType1 == 0   and  tmpType2 == 0  then
			local tmpSeed = math.random(100) %4  > 2
			if(tmpSeed)then 
				return 1
			else
				return 2
			end
		elseif tmpType2 == 0 and  tmpType1 ~= 0 then 
			local tmpSeed = math.random(60)  > 30
			if(tmpSeed)then 
				return tmpType1
			else
				return 0
			end
		end
	else 
		return 0
	end
	return 0
end

-- 循环队列
queueCreate = function ( nMaxSize, nTopDataNum)
	return { first = 1, last = 0, maxsize = nMaxSize, topDataNum = nTopDataNum, }
end

queuePush = function ( Q, value )
	local last = Q.last + 1
	Q.last = last
	Q[last] = value
end

queueFront = function (Q)
	return Q[Q.first]
end

queuePop = function (Q)
	local value = Q[Q.first]
	Q[Q.first] = nil
	Q.first = Q.first + 1
	queuePush(Q, value)
	Q.topDataNum = Q.topDataNum + 1
end

queueTopData = function (Q)
	return Q[Q.topDataNum]
end


