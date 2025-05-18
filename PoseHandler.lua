local uis = game:GetService("UserInputService")



uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.P then
		local sound = game.Players.LocalPlayer.Character.Head:FindFirstChildOfClass("Sound")
		if sound and sound.Playing == false then
			game:GetService("ReplicatedStorage"):WaitForChild("PlaySound"):FireServer()
		elseif sound and sound.Playing == true then
			game:GetService("ReplicatedStorage"):WaitForChild("StopSound"):FireServer()
		end
	end
end)
