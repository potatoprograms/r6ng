local event = game:GetService("ReplicatedStorage"):WaitForChild("Dialog"):WaitForChild("ClientDialog")
local ui = script.Parent
local text = ui.Dialog
local name = ui.NameText
local icon = ui.Icon -- this is the ViewportFrame

local function typeText(textString: string)
	text.Text = ""
	local characters = {}

	for i = 1, #textString do
		table.insert(characters, textString:sub(i, i))
	end

	for _, char in characters do
		text.Text = text.Text .. char
		task.wait(0.1)
	end
end

local function updateViewport(dummy)
	icon:ClearAllChildren()

	local clone = dummy:Clone()
	clone.Parent = icon

	-- Set primary part to HumanoidRootPart or Torso
	local primary = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso")
	if not primary then return end
	clone.PrimaryPart = primary

	-- Force dummy to face -Z (which we will assume is the direction the camera looks from)
	clone:SetPrimaryPartCFrame(CFrame.Angles(0, math.rad(180), 0)) -- turn 180 degrees

	-- Create camera
	local cam = Instance.new("Camera")
	cam.Name = "ViewportCam"
	cam.Parent = icon
	icon.CurrentCamera = cam

	-- Get head position
	local head = clone:FindFirstChild("Head")
	if head then
		local headPos = head.Position
		local camOffset = Vector3.new(0, 0, 4) -- camera sits 4 studs in front of the face
		cam.CFrame = CFrame.new(headPos + camOffset, headPos)
	end
end

local function loadOptions(options, partner)
	local option = ui.Options
	text.Visible = false
	option.Visible = true
	for _, c in ipairs(option:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	for i, opt in ipairs(options) do
		local clone = game:GetService("ReplicatedStorage"):WaitForChild("Dialog"):WaitForChild("TextButton"):Clone()
		clone.Text = opt
		clone.Name = opt
		clone.Size = UDim2.new(1,0,(1 / #options), 0)
		clone.Parent = option
		clone.Activated:Connect(function()
			game:GetService("ReplicatedStorage"):WaitForChild("Dialog"):WaitForChild("ClientDialog"):FireServer(clone.Text, partner)
			option.Visible = false
			ui.Visible = false
			game.Players.LocalPlayer.PlayerGui.ScreenGui.Roll.Visible = false
		end)
	end
end
event.OnClientEvent:Connect(function(dialog, partner, options)
	ui.Visible = true
	game.Players.LocalPlayer.PlayerGui.ScreenGui.Roll.Visible = false
	text.Visible = true
	ui.Options.Visible =false
	name.Text = partner.Name
	updateViewport(partner)
	game.Players.LocalPlayer.PlayerGui.Typing.Playing = true
	typeText(dialog)
	game.Players.LocalPlayer.PlayerGui.Typing.Playing = false
	task.wait(1.67)
	loadOptions(options, partner)
end)
