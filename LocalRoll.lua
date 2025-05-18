local rs = game:GetService("ReplicatedStorage")
local buttonClone = rs:WaitForChild("TextButton")
local event = rs:WaitForChild("Rolled")
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui.ScreenGui
local inven = gui.Inventory
local addTo = inven.Spaces.Items

local function odds(dummy)
	local odds = 1
	local colorsum = 21944
	local charmsum = 0 --multiply by 500 at the end
	local facesum = 0
	local auraodds = 3000
	local matodds = 960
	local fireodds = 342
	local songsum = 0
	local animsum = 0
	for _, c in ipairs(workspace:WaitForChild("Charms"):GetChildren()) do
		charmsum += c.Value.Value
	end
	charmsum *= 300
	for _, c in ipairs(workspace:WaitForChild("Faces"):GetChildren()) do
		facesum += c.Value.Value
	end
	facesum -= workspace:WaitForChild("Faces"):WaitForChild("Default").Value.Value
	for _, c in ipairs(workspace:WaitForChild("Songs"):GetChildren()) do
		songsum += c.Value.Value
	end
	for _, c in ipairs(workspace:WaitForChild("Anims"):GetChildren()) do
		animsum += c.Value.Value
	end
	local data = string.split(dummy, "##")
	for i, v in ipairs(data) do
		if i < 7 then
			local props = string.split(v, "!")
			local color = BrickColor.new(props[1]).Number
			odds *= (colorsum / color)
			if props[2] ~= "Plastic" then
				odds *= matodds
			end
		else
			if i==7 then
				if v ~= workspace:WaitForChild("Faces"):WaitForChild("Default").Texture then
					odds *= (facesum / #workspace:WaitForChild("Faces"):GetChildren())
				end
			end
			if i==8 then
				if v ~= "rbxassetid://0" then
					local charm = 1
					local charms = workspace:WaitForChild("Charms")
					for _, d in ipairs(charms:GetChildren()) do
						if d.Texture == v then
							charm = d
							break
						end
					end
					odds *= (charmsum / charm.Value.Value)
				end
			end
			if i==9 then
				if v ~= "None" then
					local props = string.split(v, "!")
					local color = BrickColor.new(props[2]).Number
					odds *= (colorsum / color)
					odds *= auraodds
				end
			end
			if i==12 then
				if v ~= "none" then
					local color = BrickColor.new(v).Number
					odds *= (colorsum / color)
					odds *= fireodds
				end
			end
			if i == 13 then
				if string.split(v, " ")[1] == "Slow" then
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(string.gsub(v, "Slow ", ""))
					odds *= (songsum / song.Value.Value) * (622 * 2)
				elseif string.split(v, " ")[1] == "Fast" then
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(string.gsub(v, "Fast ", ""))
					odds *= (songsum / song.Value.Value) * (622 * 2)
				else
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(v)
					odds *= (songsum / song.Value.Value)
				end
			end
			if i == 14 then
				local song = workspace:WaitForChild("Anims"):FindFirstChild(v)
				odds *= (animsum / song.Value.Value)
			end
		end
	end
	return math.round(odds)
end
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
	local TweenService = game:GetService("TweenService")
	local player = game.Players.LocalPlayer
	local uis = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("RolledAnim")
	player.PlayerGui.Open:Play()
	-- Reset and show UI
	uis.Rotation = 0
	uis.Visible = true

	-- Create a tweening function
	local function tweenRotation(object, targetRotation, duration)
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local goal = { Rotation = targetRotation }
		local tween = TweenService:Create(object, tweenInfo, goal)
		tween:Play()
		tween.Completed:Wait()
	end

	-- Smooth wiggle animation
	tweenRotation(uis, -20, 0.2)
	tweenRotation(uis, 20, 0.3)
	tweenRotation(uis, -15, 0.3)
	tweenRotation(uis, 15, 0.2)
	tweenRotation(uis, -5, 0.1)
	tweenRotation(uis, 0, 0.1)

	-- Flash ImageLabel
	uis.ImageLabel.Visible = true
	task.wait(0.3)
	uis.ImageLabel.Visible = false
	uis.Visible = false

	script.Parent.Visible = true
	local dummyInstance = render(dummy)
		local viewportFrame = script.Parent.Viewport
		if viewportFrame:FindFirstChildOfClass("Camera") then
			viewportFrame:FindFirstChildOfClass("Camera"):Destroy()
		end
		local renderDummy = render(dummy)

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
		script.Parent.Dummy.Text = renderDummy.Name
		script.Parent.Odds.Text = "1/" .. odds(dummy)
		renderDummy:Destroy()
		task.wait(2)
		mini:Destroy()
		script.Parent.Visible = false
end)
