module("LuaJavaBridge", package.seeall)

local checkArguments = function (args, sig)
    if type(args) ~= "table" then
        local tempArgs = args 
        args = { tempArgs } 
    end
    if sig then return args, sig end

    sig = {"("}
    for i, v in ipairs(args) do
        local t = type(v)
        if t == "number" then
            sig[#sig + 1] = "F"
        elseif t == "boolean" then
            sig[#sig + 1] = "Z"
        elseif t == "function" then
            sig[#sig + 1] = "I"
        else
            sig[#sig + 1] = "Ljava/lang/String;"
        end
    end
    sig[#sig + 1] = ")V"
    return args, table.concat(sig)
end

callStaticMethod = function (className, methodName, args, sig)
	if CCLuaJavaBridge ~= nil then
        local callJavaStaticMethod = CCLuaJavaBridge.callStaticMethod
        local args, sig = checkArguments(args, sig)
        return callJavaStaticMethod(className, methodName, args, sig)
	else
        printInfo("-------------------CCLuaJavaBridge is a nil !!-------------------")
   	end
end

-- require"LuaJavaBridge.lua"
-- local CLASS_NAME = "com/lexgame/TowerWrencker/AdMobBridge"
-- local args = {}
-- local sig = "(Ljava/lang/String;IF)Z"

-- local ok, ret = luaj.callStaticMethod(CLASS_NAME, "IsPageAdReady", args, sig)

-- if not ok then
--     print("luaj error:", ret)
-- else
--     print("ret:", ret) -- 输出 ret: 5
-- end

