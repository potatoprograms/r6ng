local trades = {}      -- key: UserId, value: partner's UserId
local tradeReady = {}  -- key: UserId, value: bool whether player is ready

-- Helper to get player object by UserId
local Players = game:GetService("Players")
local function getPlayerByUserId(userId)
	return Players:GetPlayerByUserId(userId)
end

game.ReplicatedStorage.TradePopup.OnServerEvent:Connect(function(from, to)
	game.ReplicatedStorage.TradePopup:FireClient(to, from)
end)

local event = game.ReplicatedStorage.TradeBegin
event.OnServerEvent:Connect(function(plr1, plr2)
	-- Use UserId keys only
	trades[plr1.UserId] = plr2.UserId
	trades[plr2.UserId] = plr1.UserId

	-- Mark both as not ready yet
	tradeReady[plr1.UserId] = false
	tradeReady[plr2.UserId] = false

	event:FireClient(plr1, plr2)
	event:FireClient(plr2, plr1)
end)

game.ReplicatedStorage.TradeAdd.OnServerEvent:Connect(function(plr, partner, button)
	print(button)
	game.ReplicatedStorage.TradeAdd:FireClient(partner, button)
end)

game.ReplicatedStorage.TradeRemove.OnServerEvent:Connect(function(plr, partner, button)
	game.ReplicatedStorage.TradeRemove:FireClient(partner, button)
end)

game.ReplicatedStorage.TradeEnd.OnServerEvent:Connect(function(plr)
	local userId = plr.UserId
	local partnerId = trades[userId]
	if partnerId then
		local partner = getPlayerByUserId(partnerId)
		if partner then
			game.ReplicatedStorage.TradeEnd:FireClient(partner)
		end
		-- Clear trade data
		trades[userId] = nil
		trades[partnerId] = nil
		tradeReady[userId] = nil
		tradeReady[partnerId] = nil
	end
end)

game.ReplicatedStorage.TradeReady.OnServerEvent:Connect(function(plr)
	local userId = plr.UserId
	local partnerId = trades[userId]
	if not partnerId then
		warn("TradeReady: no trade partner for "..plr.Name)
		return
	end

	tradeReady[userId] = true
	-- Check if both ready
	if tradeReady[userId] and tradeReady[partnerId] then
		local partner = getPlayerByUserId(partnerId)
		if not partner then return end

		local plrRes = game.ReplicatedStorage.GetOffers:InvokeClient(plr)
		local partRes = game.ReplicatedStorage.GetOffers:InvokeClient(partner)
		print(plrRes, partRes)
		local plrData = workspace.PlayerData:FindFirstChild(plr.Name)
		local partData = workspace.PlayerData:FindFirstChild(partner.Name)
		if not plrData or not partData then
			warn("PlayerData missing for trade participants")
			return
		end

		-- Transfer plrRes to partner and remove from plrData
		-- Utility function to split a string by delimiter
		local function splitString(str, delimiter)
			local result = {}
			for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
				table.insert(result, match)
			end
			return result
		end

		-- Utility function to join a table by delimiter
		local function joinTable(tbl, delimiter)
			return table.concat(tbl, delimiter)
		end

		-- Remove one instance of `data` from the delimited string `str`
		local function removeData(str, data)
			local items = splitString(str, "***")
			for i, item in ipairs(items) do
				if item == data then
					table.remove(items, i)
					break
				end
			end
			return joinTable(items, "***")
		end

		-- Your original logic with the improved removal method
		for _, data in ipairs(plrRes) do
			-- Remove data from plrData.Value safely
			plrData.Value = removeData(plrData.Value, data)
			-- Append data to partData.Value with proper separator handling
			if partData.Value ~= "" then
				partData.Value = partData.Value .. "***" .. data
			else
				partData.Value = data
			end
		end

		-- Transfer partRes to plr and remove from partData
		for _, data in ipairs(partRes) do
			-- Remove data from partData.Value safely
			partData.Value = removeData(partData.Value, data)
			-- Append data to plrData.Value with proper separator handling
			if plrData.Value ~= "" then
				plrData.Value = plrData.Value .. "***" .. data
			else
				plrData.Value = data
			end
		end


		-- Clear trade states
		trades[userId] = nil
		trades[partnerId] = nil
		tradeReady[userId] = nil
		tradeReady[partnerId] = nil
		
		task.wait(.1)
		local po = require(script.Parent.Roll.PostOffice)
		local plrs = workspace.PlayerData:FindFirstChild(plr.Name).Value
		plrs = string.split(plrs, "***")
		for i, plri in ipairs(plrs) do
			po.renderUI(plri, plr)
			task.wait()
		end
		local plrs = workspace.PlayerData:FindFirstChild(partner.Name).Value
		plrs = string.split(plrs, "***")
		for i, plri in ipairs(plrs) do
			po.renderUI(plri, partner)
			task.wait()
		end
	end
end)

game.ReplicatedStorage.TradeUnready.OnServerEvent:Connect(function(plr)
	local userId = plr.UserId
	local partnerId = trades[userId]
	if partnerId then
		tradeReady[userId] = false
		tradeReady[partnerId] = false
	end
end)
