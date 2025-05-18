local plr = game.Players.LocalPlayer
local inven = plr.PlayerGui.ScreenGui.Inventory
local renameGui = plr.PlayerGui.ScreenGui.Rename
local renameButton = renameGui.TextButton
local selected = plr.PlayerGui.ScreenGui.Inventory.Spaces.View.Selected
local conn
local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("RenameEvent")
script.Parent.Activated:Connect(function()
	inven.Visible = false
	renameGui.Visible = true
	
	conn = renameButton.Activated:Connect(function()
		local text = renameGui.TextBox.Text
		text = string.gsub(text, "!", "")
		text = string.gsub(text, "##", "")
		text = string.gsub(text, "***", "")
		if text == "" then
			text = "Dummy"
		end
		renameGui.TextBox.Text = ""
		inven.Visible = true
		renameGui.Visible = false
		event:FireServer(selected.Value.Dummy.Value, text)
		conn:Disconnect()
	end)
	event.OnClientEvent:Connect(function(original, altered, name)
		local buttons = inven.Spaces.Items:GetChildren()
		for _, button in ipairs(buttons) do
			if not button:IsA("TextButton") then continue end
			if button.Dummy.Value == original then
				button.Dummy.Value = altered
				button.Text = name
				break
			end
		end
		plr.PlayerGui.ScreenGui.Inventory.Spaces.View.TextLabel.Text = name
	end)
end)
