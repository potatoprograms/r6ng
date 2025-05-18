local random = {}
local po = require(script.Parent.PostOffice)
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("Ids")
local charmodds = 300
local auraodds = 1000
local fire = 342
function random.GetBrickColorIds()
	local goal = 208
	local colors = {}
	repeat
		table.insert(colors, goal)
		goal -= 1
	until goal == 0
	return colors
end
function random.GetBrickColorsDict()
	local colors = random.GetBrickColorIds()
	local colours = {}
	for _, c in ipairs(colors) do
		colours[BrickColor.new(c).Name] = c
	end
	return colours
end
function random.GetBrickColors()
	local colors = random.GetBrickColorIds()
	local colours = {}
	for _, c in ipairs(colors) do
		table.insert(colours, BrickColor.new(c))
	end
	return colours
end
local colorsDict = random.GetBrickColorsDict()
local colors = random.GetBrickColors()
local choices = {}
for _, c in ipairs(colors) do
	local prob = colorsDict[c.Name]
	for i=1, prob do
		table.insert(choices, c)
	end
end
function random.BrickColor()
	return choices[math.random(1, #choices)]
end
function random.Material()
	local allMaterials = {}

	for _, material in pairs(Enum.Material:GetEnumItems()) do
		if material.Name ~= "Plastic" and material.Name ~= "SmoothPlastic" then
			table.insert(allMaterials, material)
		end
	end
	
	return allMaterials[math.random(1, #allMaterials)]
end
function random.Limbs()
	local limbs = {Head = nil, Torso = nil, LeftArm = nil, RightArm = nil, LeftLeg = nil, RightLeg = nil}
	local corr = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
	for _, c in corr do
		limbs[c] = random.BrickColor()
	end
	return limbs
end
function random.Face()
	local faces = {}
	for _, c in ipairs(workspace.Faces:GetChildren()) do
		for i=1, c.Value.Value do
			table.insert(faces, c.Texture)
		end
	end
	return faces[math.random(1, #faces)]
end
local images = {}
for _, c in ipairs(workspace.Charms:GetChildren()) do
	images[tostring(c.Texture)] = c.Value.Value
end
function random.Billboard()

	local choices = {}
	for id, weight in pairs(images) do
		for _ = 1, weight do
			table.insert(choices, id)
		end
	end

	return choices[math.random(1, #choices)]
end
function random.AuraColor()
	local color = random.BrickColor()
	color = color.Color
	return color
end
local songs = {}
for _, c in ipairs(workspace.Songs:GetChildren()) do
	songs[c.Name] = c.Value.Value
end
function random.Song()
	local choices = {}
	for id, weight in pairs(songs) do
		for _ = 1, weight do
			table.insert(choices, id)
		end
	end

	return choices[math.random(1, #choices)]
end
local anims = {}
for _, c in ipairs(workspace.Anims:GetChildren()) do
	anims[c.Name] = c.Value.Value
end
function random.Anim()
	local choices = {}
	for id, weight in pairs(anims) do
		for _ = 1, weight do
			table.insert(choices, id)
		end
	end

	return choices[math.random(1, #choices)]
end
function random.Body(plr)
	local limbs = random.Limbs()
	local dummy = game.ReplicatedStorage.Dummy:Clone()

	for _, c in ipairs(dummy:GetChildren()) do
		if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
			local cleanedName = string.gsub(c.Name, "%s+", "")

			if limbs[cleanedName] then
				c.BrickColor = limbs[cleanedName]
				if math.random(1, 32) == 1 then
					c.Material = random.Material()
				end
			end
		end
	end
	dummy.Head.face.Texture = random.Face()
	if math.random(1, charmodds) == 1 then
		local gui = random.Billboard()
		dummy.Head.BillboardGui.ImageLabel.Image = gui
		dummy.Head.BillboardGui.ImageLabel.Visible = true
		dummy.Name = "Charming " .. dummy.Name
	end
	if math.random(1, auraodds) == 1 then
		local choice = math.random(1,3)
		if choice == 1 then
			local color = random.AuraColor()
			for _, c in ipairs(dummy:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					local highlight = Instance.new("Highlight")
					highlight.FillColor = color
					highlight.Parent = c
				end
			end
			dummy.Name = "Highlighted " .. dummy.Name
		elseif choice == 2 then
			local color = random.AuraColor()
			for _, c in ipairs(dummy:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					local highlight = Instance.new("SelectionBox")
					highlight.Adornee = c
					highlight.Parent = c
					highlight.Color3 = color
				end
			end
			dummy.Name = "Selected " .. dummy.Name
		elseif choice == 3 then
			local color = random.AuraColor()
			for _, c in ipairs(dummy:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
					local highlight = game.ReplicatedStorage.ParticleEmitter:Clone()
					highlight.Parent = c
					highlight.Color = ColorSequence.new(color)
				end
			end
			dummy.Name = "Sparkling " .. dummy.Name
		end
		
	end
	if math.random(1, fire) == 1 then
		local firecolor = random.AuraColor()
		local fire = Instance.new("Fire")
		fire.Parent = dummy.Head
		fire.Color = firecolor
		dummy.Name = "Fiery " .. dummy.Name
	end
	local randomSong = random.Song()
	randomSong = workspace.Songs:FindFirstChild(randomSong):Clone()
	if math.random(1, 622) == 1 then
		if math.random(1,2) == 1 then
			randomSong.PlaybackSpeed = .75
		else
			randomSong.PlaybackSpeed = 1.25
		end
	end
	randomSong.Parent = dummy.Head
	local randomAnim = random.Anim()
	randomAnim = workspace.Anims:FindFirstChild(randomAnim):Clone()
	randomAnim.Parent = dummy
	local num = ds:GetAsync("Global")
	if num then
		dummy.GlobalId.Value = num
		ds:SetAsync("Global", num + 1)
	else
		dummy.GlobalId.Value = 0
		ds:SetAsync("Global", 1)
	end
	
	--dummy.Parent = workspace
	dummy.Owner.Value = plr
	local data = workspace.PlayerData:FindFirstChild(plr.Name)
	if data.Value ~= "" then
		data.Value = data.Value .. "***"
	end
	data.Value = data.Value .. po.pack(dummy)
	return dummy
end


return random
