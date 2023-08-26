--!strict

-- ******************************* --
-- 			AX3NX / AXEN		   --
-- ******************************* --

---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

---- Imports ----

local SecureCast = require(ReplicatedStorage.SecureCast)

---- Settings ----

local MAXIMUM_LATENCY = 0.8 -- 800 ms

---- Constants ----

local Events = ReplicatedStorage.Events
local SimulateEvent = Events.Simulate

---- Variables ----

---- Private Functions ----

---- Public Functions ----

---- Initialization ----

--> Only call once per context
SecureCast.Initialize()

---- Connections ----

Players.PlayerAdded:Connect(function(Player: Player)
	Player.CharacterAdded:Connect(function(Character)
		RunService.PostSimulation:Wait()
		Character.Parent = workspace.Characters
	end)
end)

ReplicatedStorage.Events.Simulate.OnServerEvent:Connect(function(Player: Player, Origin: Vector3, Direction: Vector3, Timestamp: number)
	local Latency = (workspace:GetServerTimeNow() - Timestamp)
	if (Latency < 0) or (Latency > MAXIMUM_LATENCY) then
		return
	end
	
	SimulateEvent:FireAllClients(Player, "Bullet", Origin, Direction)
	SecureCast.Cast(Player, "Bullet", Origin, Direction, os.clock() - Latency)
end)
