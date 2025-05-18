script.Parent.Activated:Connect(function()
	local mini = script.Parent.Parent.Selected.Value
	if mini then
		local dummy = mini.Dummy.Value
		game:GetService("ReplicatedStorage"):WaitForChild("EquipDummy"):FireServer(dummy)
		game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Visible = false
	end
end)
