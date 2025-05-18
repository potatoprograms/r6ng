local ContentProvider = game:GetService("ContentProvider")

local function playAnimation(plr)
	local char = plr.Character
	if not char then return end

	local head = char:FindFirstChild("Head")
	local sound = head and head:FindFirstChildOfClass("Sound")

	if sound then
		sound:Play()

		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end

		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		local anim = char:FindFirstChildOfClass("Animation")
		if not anim then
			warn("No Animation found in character!")
			return
		end

		-- Preload the animation asset first
		ContentProvider:PreloadAsync({anim})

		-- Now load the animation track
		local animTrack = animator:LoadAnimation(anim)
		animTrack.Looped = false

		animTrack:Play(0.1, 5, 1)

		humanoid.WalkSpeed = 0
		humanoid.JumpHeight = 0
		if anim:FindFirstChildOfClass("Animation") then
			local animation = anim:FindFirstChildOfClass("Animation")
			local animTrack = animator:LoadAnimation(animation)
			animTrack.Looped = true
			animTrack:Play(0.1, 5, 1)
		else
			animTrack.Looped = true
		end
		-- Freeze near end
		--local freezeTime = animTrack.Length - 0.05
		--task.delay(freezeTime, function()
			--if animTrack.IsPlaying then
			--	animTrack:AdjustSpeed(0)
			--	animTrack.TimePosition = animTrack.Length - 0.01
		--	end
		--end)

	end
end

game.ReplicatedStorage.PlaySound.OnServerEvent:Connect(function(plr)
	playAnimation(plr)
end)


game.ReplicatedStorage.StopSound.OnServerEvent:Connect(function(plr)
	local char = plr.Character
	local head = char:FindFirstChild("Head")
	local sound = head and head:FindFirstChildOfClass("Sound")
	local ws = 16
	local jh = 7.2

	if sound then
		sound:Stop()
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = ws
		humanoid.JumpHeight = jh

		for i, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	end
end)
