local rs = game:GetService("ReplicatedStorage")
local buttonClone = rs:WaitForChild("TextButton")
local event = rs:WaitForChild("Cam")
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui.ScreenGui
local inven = gui.Inventory
local addTo = inven.Spaces.Items

-- Function to pack the dummy data into a string
local function pack(dummy)
	local head = dummy.Head
	local torso = dummy.Torso
	local la = dummy["Left Arm"]
	local ra = dummy["Right Arm"]
	local ll = dummy["Left Leg"]
	local rl = dummy["Right Leg"]
	local parts = {head, torso, la, ra, ll, rl}
	local res = ""
	for _, part in ipairs(parts) do
		if res ~= "" then
			res = res .. "##"
		end
		res = res..part.BrickColor.Name.."!"..part.Material.Name
	end
	res = res.."##"..head.face.Texture
	res = res.."##"..head.BillboardGui.ImageLabel.Image
	if head:FindFirstChildOfClass("Highlight") then
		res = res.."##".."Highlight!" .. BrickColor.new(head:FindFirstChildOfClass("Highlight").FillColor).Name
	elseif head:FindFirstChildOfClass("SelectionBox") then
		res = res.."##".."Selection!" .. BrickColor.new(head:FindFirstChildOfClass("SelectionBox").Color3).Name
	elseif head:FindFirstChildOfClass("ParticleEmitter") then
		local particle = head:FindFirstChildOfClass("ParticleEmitter")
		local color3 = particle.Color.Keypoints[1].Value
		res = res.."##".."Particle!" .. BrickColor.new(color3).Name
	else
		res = res.."##".."None"
	end
	res = res.."##"..dummy:FindFirstChild("GlobalId").Value
	res = res.."##"..dummy.Name
	if head:FindFirstChildOfClass("Fire") then
		res = res.."##".. BrickColor.new(head:FindFirstChildOfClass("Fire").Color).Name
	else
		res = res .. "##none"
	end
	local song = head:FindFirstChildOfClass("Sound")
	if song.PlaybackSpeed == .75 then
		res = res .. "##Slow " .. song.Name
	elseif song.PlaybackSpeed == 1.25 then
		res = res .. "##Fast " .. song.Name
	else
		res = res .. "##" .. song.Name
	end
	return res
end
local function render(data, owner)
	data = string.split(data, "##")
	local dummy = game.ReplicatedStorage.Dummy:Clone()
	local order = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	for i, v in ipairs(data) do
		if i < 7 then
			local part = dummy:FindFirstChild(order[i])
			local properties = string.split(v, "!")
			part.BrickColor = BrickColor.new(properties[1])
			part.Material = Enum.Material[properties[2]]
		else
			if i == 7 then
				dummy.Head.face.Texture = v
			end
			if i == 8 then
				dummy.Head.BillboardGui.ImageLabel.Image = v
				if v ~= "rbxassetid://0" then
					dummy.Head.BillboardGui.ImageLabel.Visible = true
				end
			end
			if i == 9 then
				local props = string.split(v, "!")
				if props[1] == "Highlight" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local highlight = Instance.new("Highlight")
							highlight.FillColor = color.Color
							highlight.Parent = c
						end
					end
				elseif props[1] == "Particle" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local particle = game.ReplicatedStorage.ParticleEmitter:Clone()
							particle.Parent = c
							particle.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, color.Color),
								ColorSequenceKeypoint.new(1, color.Color)
							})
						end
					end
				elseif props[1] == "Selection" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local selectionBox = Instance.new("SelectionBox")
							selectionBox.Adornee = c
							selectionBox.Parent = c
							selectionBox.Color3 = color.Color
						end
					end
				end
			end
			if i == 10 then
				dummy.GlobalId.Value = v
			end
			if i==11 then
				dummy.Name = v
			end
			if i==12 then
				if v ~= "none" then
					local color = BrickColor.new(v).Color
					local fire = Instance.new("Fire")
					fire.Parent = dummy.Head
					fire.Color = color
				end
			end
			if i==13 then
				if string.split(v, " ")[1] == "Slow" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Slow ", ""))
					song = song:Clone()
					song.PlaybackSpeed = .75
					song.Parent = dummy.Head
				elseif string.split(v, " ")[1] == "Fast" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Fast ", ""))
					song = song:Clone()
					song.PlaybackSpeed = 1.25
					song.Parent = dummy.Head
				else
					local songs = workspace.Songs
					local song = songs:FindFirstChild(v)
					song = song:Clone()
					song.Parent = dummy.Head
				end
			end
			if i==14 then
				local songs = workspace.Anims
				local song = songs:FindFirstChild(v)
				song = song:Clone()
				song.Parent = dummy
			end
		end
	end
	dummy.Owner.Value = owner
	--game.ReplicatedStorage.Cam:FireAllClients(dummy)
	return dummy
end
-- Event listener for receiving the dummy and adding the button to the inventory
event.OnClientEvent:Connect(function(dummy)
	local dummyInstance = render(dummy)
	local button = buttonClone:Clone()
	button.Text = dummyInstance.Name
	button.Dummy.Value = dummy
	button.Parent = addTo
	button.BackgroundColor = BrickColor.new(string.split(dummy, "!")[1])
	button.Activated:Connect(function()
		local viewportFrame = plr.PlayerGui.ScreenGui.Inventory.Spaces.View.ViewportFrame
		if viewportFrame:FindFirstChildOfClass("Camera") then
			viewportFrame:FindFirstChildOfClass("Camera"):Destroy()
			viewportFrame.Mini.Value:Destroy()
		end
		local renderDummy = render(button.Dummy.Value)

		plr.PlayerGui.ScreenGui.Inventory.Spaces.View.Selected.Value = button
		renderDummy.Parent = workspace
		renderDummy:PivotTo(workspace:WaitForChild("ViewportDummy"):WaitForChild("HumanoidRootPart").CFrame)
		local cam = Instance.new("Camera")
		viewportFrame.CurrentCamera = cam
		cam.Parent = viewportFrame

		-- Clone dummy into viewport
		local mini = renderDummy:Clone()
		viewportFrame.Mini.Value = mini
		mini.Parent = viewportFrame

		-- Ensure PrimaryPart is set
		if not mini.PrimaryPart then
			mini.PrimaryPart = mini:FindFirstChild("Torso") or mini:FindFirstChild("HumanoidRootPart") or mini:FindFirstChild("Head")
		end

		-- Move dummy to origin
		local origin = Vector3.new(0, 0, 0)
		mini:SetPrimaryPartCFrame(CFrame.new(origin))

		-- Camera positioning
		local target = origin + Vector3.new(0, 1.5, 0) -- focus on torso/head
		local zoomDistance = 5 -- smaller = closer = bigger dummy
		local camPosition = target + Vector3.new(0, 1, -zoomDistance)

		cam.CFrame = CFrame.new(camPosition, target)
		renderDummy:Destroy()
	end)
	game:GetService("ReplicatedStorage"):WaitForChild("Favorite").OnClientEvent:Connect(function(dummy, new)
		if button.Dummy.Value == dummy then
			button.Dummy.Value = new
			button.LayoutOrder = 0
		end
	end)
end)
