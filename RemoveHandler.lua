game.ReplicatedStorage.RemoveEvent.OnServerEvent:Connect(function(plr, dummy)
	local data = workspace.PlayerData:FindFirstChild(plr.Name)
	local dummies = string.split(data.Value, "***")
	for i, dummie in ipairs(dummies) do
		if dummie == dummy then
			table.remove(dummies, i)
			break
		end
	end
	local new = ""
	for i, dummie in ipairs(dummies) do
		if i > 1 then
			new = new .. "***"
		end
		new = new .. dummie
	end
	data.Value = new
end)
