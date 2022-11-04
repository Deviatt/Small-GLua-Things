-- from incredible-gmod.ru with <3
-- https://github.com/Be1zebub/Small-GLua-Things/blob/master/onnetworkvarupdate.lua

hook.Add("OnEntityCreated", "OnNetworkVarUpdate", function(ent)
	if ent.dt == nil then return end

	local meta = getmetatable(ent.dt)
	local __newindex = meta.__newindex
	function meta:__newindex(name, val)
		local old = self[name]
		__newindex(self, name, val)
		if val == old then return end
		hook.Run("OnNetworkVarUpdate", ent, name, old, val)
	end

	for name, val in pairs(ent:GetNetworkVars() or {}) do
		hook.Run("OnNetworkVarUpdate", ent, name, nil, val)
	end

	local NetworkVar = ent.NetworkVar
	ent.NetworkVar = function(me, type, index, name, other)
		NetworkVar(me, type, index, name, other)
		me:NetworkVarNotify(name, function(ent, _, old, new)
			if old ~= new then
				hook.Run("OnNetworkVarUpdate", ent, name, old, new)
			end
		end)
	end
end)
