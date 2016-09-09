

-- 时间算子
math.randomseed(tostring(os.time()):reverse())

-- 
-- 点击左右屏幕
g_touchScreenLeft = 1 	 
g_touchScreenRight = 2 	


g_beatEffectPath 	= "beat.wav"
g_manDieEffectPath 	= "die.wav"
g_bgMusicPath 		= "background.mp3"

g_offsetPlayer = 200
-- 广告显示时间间隔
kADTimeInterval = 40

g_targetPlatform = CCApplication:sharedApplication():getTargetPlatform()


createNodeFromNumber = function(number)
	local showNumberNode = cc.Node:create()

	local tmpNumSpriteTable = {}
	local tmpNumForTest = 10
	local tmpSprite =nil
	repeat
		tmpSprite = cc.Sprite:create("image/number_" .. number%10 .. ".png")
		showNumberNode:addChild(tmpSprite)
	    tmpNumSpriteTable[#tmpNumSpriteTable + 1] = tmpSprite
	    number = math.floor(number / 10)
	until number == 0;

	local charWidth = 56			--- 字符宽度
	local spaceWidth = 4 			-- 字符间隔
	-- 相对于原点右偏 (倒序放置数字)
	local startX = (#tmpNumSpriteTable*charWidth + (#tmpNumSpriteTable - 1)*spaceWidth)*0.5 - charWidth*0.5
	for currentPtr = 1,#tmpNumSpriteTable do
		tmpNumSpriteTable[currentPtr]:setPosition( startX - (currentPtr-1)*(spaceWidth + charWidth),0)
	end
	return showNumberNode
end








