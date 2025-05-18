local data = workspace.PlayerData
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("Inventory")
local po = require(script.Parent.Roll.PostOffice)
game.Players.PlayerAdded:Connect(function(plr)
	local val
	if not data:FindFirstChild(plr.Name) then
		val = Instance.new("StringValue")
		val.Name = plr.Name
		val.Parent = data
	else
		val = data:FindFirstChild(plr.Name)
	end
	local saved = ds:GetAsync(plr.UserId)
	if saved then
		val.Value = saved
		print(saved)
		local dummies = string.split(saved, "***")
		for i, dummy in ipairs(dummies) do
			po.renderUI(dummy, plr)
			task.wait()
		end
	end
	local arests = Instance.new("IntValue")
	arests.Name = plr.Name
	arests.Parent = workspace.Arests
	local arests = Instance.new("BoolValue")
	arests.Name = plr.Name
	arests.Parent = workspace.HasRobbed
end)
game.Players.PlayerRemoving:Connect(function(plr)
	local val = data:FindFirstChild(plr.Name)
	ds:SetAsync(plr.UserId, val.Value)
end)
