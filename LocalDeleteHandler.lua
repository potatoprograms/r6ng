script.Parent.Activated:Connect(function()
	local mini = script.Parent.Parent.Selected.Value
	if mini then
		local dummy = mini.Dummy.Value
		mini:Destroy()
		game:GetService("ReplicatedStorage"):WaitForChild("RemoveEvent"):FireServer(dummy)
		script.Parent.Parent.TextLabel.Text = "Dummy"
		script.Parent.Parent.Selected.Value = nil
		local cam = script.Parent.Parent.ViewportFrame:FindFirstChildOfClass("Camera")
		if cam then
			cam:Destroy()
			script.Parent.Parent.ViewportFrame.Mini.Value:Destroy()
		end
	end
end)
