module("GameData", package.seeall)

-- initGolbelData
-- playCutTreeEffect
-- playpManDieEffectPath
-- playBackgroudMusic

-- 内部变量表
local m_variablesTable = {}

initGolbelData = function () 
	printInfo("GameMainScene initGolbelData")
	m_variablesTable.m_bgMusic = CCFileUtils:sharedFileUtils():fullPathForFilename(g_bgMusicPath)
	SimpleAudioEngine:getInstance():preloadMusic(m_variablesTable.m_bgMusic)
	m_variablesTable.m_beatEffect = CCFileUtils:sharedFileUtils():fullPathForFilename(g_beatEffectPath)
	SimpleAudioEngine:getInstance():preloadEffect(m_variablesTable.m_beatEffect)
	m_variablesTable.m_dieEffect = CCFileUtils:sharedFileUtils():fullPathForFilename(g_manDieEffectPath)
	SimpleAudioEngine:getInstance():preloadEffect(m_variablesTable.m_dieEffect)
    
    m_variablesTable.playerScore = 0
	m_variablesTable.playerLevel = 0

	m_variablesTable.playerBestScore = CCUserDefault:getInstance():getStringForKey("bestScore")
	if(m_variablesTable.playerBestScore  == "")then
		m_variablesTable.playerBestScore  = 0 
	else 
		m_variablesTable.playerBestScore  = tonumber(m_variablesTable.playerBestScore) 
	end
	m_variablesTable.playerTotalScore = CCUserDefault:getInstance():getStringForKey("totalScore")
	if(m_variablesTable.playerTotalScore == "")then 
		m_variablesTable.playerTotalScore = 0 
	else 
		m_variablesTable.playerTotalScore = tonumber(m_variablesTable.playerTotalScore) 
	end
	m_variablesTable.playerSkinID = CCUserDefault:getInstance():getStringForKey("timbermanid")
	if(m_variablesTable.playerSkinID == "")then 
		m_variablesTable.playerSkinID = 1 
	else 
		m_variablesTable.playerSkinID = tonumber(m_variablesTable.playerSkinID) 
	end
	m_variablesTable.voiceSwitch = CCUserDefault:getInstance():getStringForKey("voiceSetting")
	if(m_variablesTable.voiceSwitch == "")then 
		m_variablesTable.voiceSwitch = true
	elseif(m_variablesTable.voiceSwitch == "false")then
		m_variablesTable.voiceSwitch =  false
	else 
		m_variablesTable.voiceSwitch =  true
	end

	m_variablesTable.playerTime = GameConstants.FormatHp
	m_variablesTable.totalTime = GameConstants.MaxHp

	m_variablesTable.gamePlaySchedulerEntry = nil
	m_variablesTable.gameTimerIsStart = false
	m_variablesTable.isGameStart = false  -- 是否点击了开始panel上的开始按钮
	m_variablesTable.isTouchable = false

	m_variablesTable.timeDecTmp = 0 		--	update计算是否掉血条
	m_variablesTable.adShowTimer = 0 		-- 	显示的时间间隔

	-- m_variablesTable.trunkHeight = 0
	-- m_variablesTable.playerStandHeight = 0
end 

reinitGolbelData = function () 
	printInfo("GameMainScene reinitGolbelData")
	m_variablesTable.playerScore = 0
	m_variablesTable.playerLevel = 0
	m_variablesTable.playerTime = GameConstants.FormatHp
	m_variablesTable.totalTime = GameConstants.MaxHp
	m_variablesTable.gameTimerIsStart = false
	m_variablesTable.isTouchable = true
	m_variablesTable.gamePlaySchedulerEntry = nil
	m_variablesTable.timeDecTmp = 0
end

-- getTrunkHeight = function () 
-- 	return m_variablesTable.trunkHeight
-- end 
-- setTrunkHeight = function (trunkHeight) 
-- 	m_variablesTable.trunkHeight= trunkHeight
-- end 

getPlayerStandHeight = function () 
	return m_variablesTable.playerStandHeight
end 
setPlayerStandHeight = function (playerStandHeight) 
	m_variablesTable.playerStandHeight= playerStandHeight
end 

getAdShowTimer = function () 
	return m_variablesTable.adShowTimer
end 
setAdShowTimer = function (adShowTimer) 
	m_variablesTable.adShowTimer= adShowTimer
end 

getTimeDecTmp = function () 
	return m_variablesTable.timeDecTmp
end 
setTimeDecTmp = function (timeDecTmp) 
	m_variablesTable.timeDecTmp= timeDecTmp
end 

getPlayerLevel = function () 
	return m_variablesTable.playerLevel
end 
setPlayerLevel = function (playerLevel) 
	m_variablesTable.playerLevel= playerLevel
end 

getGamePlaySchedulerEntry = function () 
	return m_variablesTable.gamePlaySchedulerEntry
end 
setGamePlaySchedulerEntry = function (gamePlaySchedulerEntry) 
	m_variablesTable.gamePlaySchedulerEntry= gamePlaySchedulerEntry
end 

getGameTimerIsStart = function () 
	return m_variablesTable.gameTimerIsStart
end 
setGameTimerIsStart = function (gameTimerIsStart) 
	m_variablesTable.gameTimerIsStart= gameTimerIsStart
end 

getIsGameStart = function () 
	return m_variablesTable.isGameStart
end 
setIsGameStart = function (isGameStart) 
	m_variablesTable.isGameStart= isGameStart
end 


getPlayerScore = function () 
	return m_variablesTable.playerScore
end 
setPlayerScore = function (playerScore) 
	m_variablesTable.playerScore = playerScore
end 

getPlayerBestScore = function () 
	return m_variablesTable.playerBestScore
end 
setPlayerBestScore = function (playerBestScore) 
	m_variablesTable.playerBestScore= playerBestScore
end 

getPlayerTotalScore = function () 
	return m_variablesTable.playerTotalScore
end 
setPlayerTotalScore = function (playerTotalScore) 
	m_variablesTable.playerTotalScore= playerTotalScore
end 

getPlayerSkinID = function () 
	return m_variablesTable.playerSkinID
end 
setPlayerSkinID = function (playerSkinID) 
	m_variablesTable.playerSkinID= playerSkinID
end 

getIsTouchable = function () 
	return m_variablesTable.isTouchable
end 
setIsTouchable = function (isTouchable) 
	m_variablesTable.isTouchable= isTouchable
end 

getPlayerTime = function () 
	return m_variablesTable.playerTime
end 
setPlayerTime = function (playerTime) 
	m_variablesTable.playerTime= playerTime
end 

getTotalTime = function () 
	return m_variablesTable.totalTime
end 
setTotalTime = function (totalTime) 
	m_variablesTable.totalTime= totalTime
end 

getVoiceSwitch = function () 
	return m_variablesTable.voiceSwitch
end 
setVoiceSwitch = function (voiceSwitch) 
	m_variablesTable.voiceSwitch= voiceSwitch
end 


playCutTreeEffect = function()
    SimpleAudioEngine:getInstance():playEffect(m_variablesTable.m_beatEffect)
end
playpManDieEffectPath = function()
	SimpleAudioEngine:getInstance():playEffect(m_variablesTable.m_dieEffect)
end
playBackgroudMusic = function()
	SimpleAudioEngine:getInstance():playBackgroundMusic(m_variablesTable.m_bgMusic,true)
    SimpleAudioEngine:getInstance():setBackgroundMusicVolume(0.5);
end

