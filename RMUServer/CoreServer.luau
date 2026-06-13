local ANTI_CHEAT_BAN_CONFIG = {
	Duration = -1,
	Message = 'Anti-Cheat has detected your irregular behavior.\nReason: [FLAG_REASON]',
	ApplyToUniverse = true,
	ExcludeAltAccounts = false,
	ApplyDeviceBlock = false,
};

local VOTE_DURATION = 30;

local ReplicatedStorage = game:GetService('ReplicatedStorage');
local RMUtil = ReplicatedStorage:WaitForChild('RMUtil');
local Config = require(RMUtil:WaitForChild('Config'));
local GlobalFolder = RMUtil:WaitForChild('Global')
local Players = game:GetService('Players');
local LastVote = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('Global'):WaitForChild('LastVote');
local ClientCore = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('ClientCore');
local RequestLogs = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('Request');

local Function = RMUtil:WaitForChild('Function');
local Remote = RMUtil:WaitForChild('Remote');

type Kick = {
	Target: string,
	Reason: string
}

type Ban = {
	Target: string,
	Duration: number,
	Reason: string,
	ExcludeAltAccounts: boolean,
	ApplyDeviceBlock: boolean,
}

type CallVote = {
	Title: string,
	Description: string,
	Answer1: string,
	Answer2: string,
}

type Bring = {
	Target: string,
	To: string
};

type TeleportPlayer = {
	Target: string,
	Id: number,
	JobId: string,	
};

type ViewPlayerLogs = {
	Target: string,
	Type: string
};

type ExecuteCommand = {
	Target: string,
	Script: string
};

ClientCore.OnServerEvent:Connect(function(player , reason: string)
	Players:BanAsync({
		UserIds = {player.UserId},
		Duration = ANTI_CHEAT_BAN_CONFIG.Duration,
		DisplayReason = ANTI_CHEAT_BAN_CONFIG.Message:gsub("[FLAG_REASON]",tostring(reason)),
		PrivateReason = "RMU ANTI CHEAT - "..tostring(reason),
		ExcludeAltAccounts = ANTI_CHEAT_BAN_CONFIG.ExcludeAltAccounts,
		ApplyDeviceBlock = ANTI_CHEAT_BAN_CONFIG.ApplyDeviceBlock,
	})
end)

local Actions = {
	Kick = function(args: Kick)
		local Target: Player = Players:FindFirstChild(args.Target);
		Target:Kick(args.Reason);
	end,
	
	Ban = function(args: Ban)
		local Target: Player = Players:GetPlayerByUserId(args.Target);
		if Target then
			Target:Kick("You have been banned from this game.\nExploiting")
		end
		Players:BanAsync({
			UserIds = {
				args.Target
			},
			Duration = args.Duration,
			DisplayReason = args.Reason,
			PrivateReason = "RMU BAN - "..args.Reason,
			ExcludeAltAccounts = args.ExcludeAltAccounts,
			ApplyDeviceBlock = args.ApplyDeviceBlock
		})
	end,
	
	CallVote = function(args: CallVote)
		local remote = Instance.new('RemoteEvent');
		local votes = {};
		
		remote.Name = "CallVote";
		
		remote:SetAttribute('Title',args.Title)
		remote:SetAttribute('Description',args.Description);
		remote:SetAttribute('Answer1',args.Answer1);
		remote:SetAttribute('Answer2',args.Answer2);
		remote:SetAttribute('Votes',0)
		remote.Parent = GlobalFolder;
		
		remote.OnServerEvent:Connect(function(plr: Player ,opt: number)
			if opt ~= 1 and opt ~= 2 then
				return
			end;
			
			if not votes[plr] then
				remote:SetAttribute('Votes',remote:GetAttribute('Votes') + 1)
				votes[plr] = opt;
			end;
		end);
		
		local End = function()
			remote:Destroy();

			local a,b = 0 , 0;
			for i,v in next , votes do
				if v==1 then
					a+=1;
				else
					b+=1;
				end;
			end;
			
			if a > b then
				LastVote.Value = args.Answer1;
				return 1;
			else
				LastVote.Value = args.Answer2;
				return 2;
			end
		end;
		
		local Time = tick();
		
		repeat task.wait() until tick() - Time > VOTE_DURATION or remote:GetAttribute('Votes') >= #Players:GetPlayers();
		
		return End();
	end,
	
	Bring = function(args: Bring)

		local Target: Player = Players:FindFirstChild(args.Target);
		local To: Player = Players:FindFirstChild(args.To);
		
		local main: Vector3 = To.Character:FindFirstChild('HumanoidRootPart').Position;

		if Target then
			
			Target.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(main);
		elseif args.Target == "( Everyone )" then
			for i,v in next , Players:GetPlayers() do
				if v ~= To then
					if v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
						v.Character:FindFirstChild('HumanoidRootPart').CFrame = CFrame.new(main);
					end
				end
			end
		end;
	end,
	
	TeleportPlayer = function(args: TeleportPlayer)
		local Target: Player = Players:FindFirstChild(args.Target);
		local jobid = (args.JobId:byte() and args.JobId) or nil;
		if jobid then
			game:GetService('TeleportService'):TeleportToPlaceInstance(args.Id,jobid,Target);
		else
			game:GetService('TeleportService'):Teleport(args.Id,Target);
		end
	end,
	
	ViewPlayerLogs = function(args: ViewPlayerLogs)
		local Target: Player = Players:FindFirstChild(args.Target);
		
		local code = RequestLogs:InvokeClient(Target);
		
		if args.Type == "RMU Logs" then
			return code.RMU;
		else
			return code.console;
		end
	end,
};

local cmds = {};

for i,v in next , Config.Commands do
	cmds[v.Name] = v;
end;

local Respone = function(Player: Player,message: string , args , ...)
	if not Config.Authority[Player.UserId] and not table.find(Config.Authority,Player.UserId) then
		return 0
	end;

	if cmds[message] and cmds[message].LockedUsers and (not cmds[message].LockedUsers[Player.UserId] and not table.find(cmds[message].LockedUsers,Player.UserId)) then
		return 0;
	end;

	if Actions[message] then
		return Actions[message](args,...);
	end;
end;

Remote.OnServerEvent:Connect(Respone);
Function.OnServerInvoke = Respone;