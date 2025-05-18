local office = {}
function office.pack(dummy)
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
	local anim = dummy:FindFirstChildOfClass("Animation")
	res = res .. "##" .. anim.Name
	return res
end

function office.render(data, owner)
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
	dummy.Parent = workspace
	dummy.Owner.Value = owner
	dummy:PivotTo(workspace.ViewportDummy.HumanoidRootPart.CFrame)
	--game.ReplicatedStorage.Cam:FireAllClients(dummy)
	return dummy
end

function office.renderUI(data:string, owner:Player)
	if data == "" then return end
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
	dummy:PivotTo(workspace.ViewportDummy.HumanoidRootPart.CFrame)
	dummy.Owner.Value = owner
	game.ReplicatedStorage.Cam:FireClient(owner, office.pack(dummy))
	return dummy
end
function office.renderAsChar(data, owner:Player)
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
	local char = owner.Character
	for _, animTrack in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
		animTrack:Stop()
	end

	-- Option 2: Reset Motor6Ds
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("Motor6D") then
			part.Transform = CFrame.new() -- resets the pose
		end
	end

	-- Option 3: Remove pose welds
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Weld") and child.Name == "PoseWeld" then
			child:Destroy()
		end
	end
	char.Humanoid.WalkSpeed = 16
	char.Humanoid.JumpHeight = 7.2
	if char then
		for _, c in ipairs(char:GetDescendants()) do
			if c:IsA("Accessory") or c:IsA("Clothing") or c:IsA("BodyColors") or c:IsA("Sound") or c:IsA("Animation") or c:IsA("MeshPart") or c:IsA("BillboardGui") then
				c:Destroy()
			end
		end
		local humdesc= char.Humanoid.HumanoidDescription
		for _, c in ipairs(dummy:GetChildren()) do
			if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
				local part = char:FindFirstChild(c.Name)
				--part.BrickColor = c.BrickColor
				humdesc[string.gsub(c.Name, " ", "") .. "Color"] = c.BrickColor.Color
				part.Material = c.Material
			end
		end
		char.Humanoid:ApplyDescription(humdesc)
		local face = dummy.Head.face.Texture
		local charFace = char.Head:FindFirstChildOfClass("Decal") or Instance.new("Decal")
		charFace.Name = "face"
		charFace.Texture = face
		local bgui = dummy.Head.BillboardGui:Clone()
		bgui.Parent = char.Head
		if dummy.Head:FindFirstChildOfClass("SelectionBox") then
			local box = dummy.Head:FindFirstChildOfClass("SelectionBox")
			for _, c in ipairs(char:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					local clone = box:Clone()
					clone.Parent = c
					clone.Adornee = c
				end
			end
		end
		if dummy.Head:FindFirstChildOfClass("Highlight") then
			local box = dummy.Head:FindFirstChildOfClass("Highlight")
			for _, c in ipairs(char:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					box:Clone().Parent = c
				end
			end
		end
		if dummy.Head:FindFirstChildOfClass("ParticleEmitter") then
			local box = dummy.Head:FindFirstChildOfClass("ParticleEmitter")
			for _, c in ipairs(char:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					local clone = box:Clone()
					clone.Parent = c
					--clone.Adornee = c
				end
			end
		end
		if dummy.Head:FindFirstChildOfClass("Fire") then
			local fire = dummy.Head.Fire:Clone()
			fire.Parent = char.Head
		end
		local song = dummy.Head:FindFirstChildOfClass("Sound")
		song = song:Clone()
		local anim = dummy:FindFirstChildOfClass("Animation")
		anim = anim:Clone()
		anim.Parent = char
		song.Parent = char.Head
	end
	
	return dummy
end

return office
