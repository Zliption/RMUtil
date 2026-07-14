local ANTI_CHEAT_BAN_CONFIG = {
	Duration = -1,
	Message = 'RMU Has detected your irregular behavior.\nReason: [FLAG_REASON]',
	ApplyToUniverse = true,
	ExcludeAltAccounts = false,
	ApplyDeviceBlock = false,
};

local VOTE_DURATION = 30;
local MAX_HANDSHAKE = 30;

local ReplicatedStorage = game:GetService('ReplicatedStorage');
local RMUtil = ReplicatedStorage:WaitForChild('RMUtil');
local Config = require(RMUtil:WaitForChild('Config'));
local GlobalFolder = RMUtil:WaitForChild('Global')
local Players = game:GetService('Players');
local RMUtil = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil');

local LastVote = RMUtil:WaitForChild('Global'):WaitForChild('LastVote');
local ClientCore = RMUtil:WaitForChild('ClientCore');
local RequestLogs = RMUtil:WaitForChild('Request');

local ANTI_CHEAT_REPLICATE = {
	Token = RMUtil:WaitForChild('Token'),
	Received = RMUtil:WaitForChild('Token'):WaitForChild('Received'),
	Handshake = RMUtil:WaitForChild('Token'):WaitForChild('Handshake'),
};

local ANTI_CHEAT_TOKENS = {
	TOKENS = {},
	PLAYERS = {},
	ACTIVATED = {},
};

local charset = "-QWERTYUIOPASDFGHJKLZXCVBNM1234567890";
local RandomStr = function(length)
	local result = {}

	for i = 1, length do
		local r = math.random(1, #charset)
		result[i] = string.sub(charset, r, r)
	end

	return table.concat(result)
end

local STR_ENC = function(s)
	return string.gsub(s,'..',function(a)
		local f = string.byte(a);

		return tostring(f):sub(2,2);
	end);
end;

-- Anti-Cheat Replicate Setup --
ANTI_CHEAT_REPLICATE.Received.OnServerInvoke = function(PLAYER)
	if ANTI_CHEAT_TOKENS.ACTIVATED[PLAYER] or ANTI_CHEAT_TOKENS.TOKENS[PLAYER] then
		return false;
	end;
	
	local C1,C2,C3 = RandomStr(32),RandomStr(32),RandomStr(32);
	
	ANTI_CHEAT_TOKENS.TOKENS[PLAYER] = {C1,C2,C3};
	
	return C1,C2,C3;
end;

ANTI_CHEAT_REPLICATE.Token.OnServerEvent:Connect(function(PLAYER,SELECT)
	if not ANTI_CHEAT_TOKENS.ACTIVATED[PLAYER] and ANTI_CHEAT_TOKENS.TOKENS[PLAYER] and SELECT then
		for i,v in next , ANTI_CHEAT_TOKENS.TOKENS[PLAYER] or {} do
			if STR_ENC(v) == SELECT then
				ANTI_CHEAT_TOKENS.ACTIVATED[PLAYER] = v;
				
				return true;
			end;
		end;
	end
end);

local Function = RMUtil:WaitForChild('Function');
local Remote = RMUtil:WaitForChild('Remote');

task.spawn(function()
	local PLAYER_HANDSHAKE_UPDATE = {};
	
	Players.PlayerAdded:Connect(function(plr)
		PLAYER_HANDSHAKE_UPDATE[plr] = tick();
	end);
	
	Players.PlayerRemoving:Connect(function(plr)
		PLAYER_HANDSHAKE_UPDATE[plr] = nil;
	end)
	
	while true do task.wait(5)
		for i, v in next , Players:GetPlayers() do
			if ANTI_CHEAT_TOKENS.ACTIVATED[v] then
				if PLAYER_HANDSHAKE_UPDATE[v] and PLAYER_HANDSHAKE_UPDATE[v] > tick() + MAX_HANDSHAKE then
					v:Kick("Connection Lost.")	
				end;
				
				task.spawn(function()
					local Int1,Int2,Int3,Format = math.random(100,10000),math.random(100,10000),math.random(100,10000),RandomStr(16);
					
					local Response = ANTI_CHEAT_REPLICATE.Handshake:InvokeClient(v,{
						Int1 = Int1,
						Int2 = Int2,
						Int3 = Int3,
						Format = Format,
					});
					
					local TARGET_TOKEN = STR_ENC(Format .. ANTI_CHEAT_TOKENS.ACTIVATED[v] .. "_TOKEN");
					
					if Response and typeof(Response) == 'table' then
						if Response.TOKEN_BLOCK == TARGET_TOKEN then
							if Response.INT1 == Int1 + 99237472 and Response.INT2 == Int2 + 174825322 and Response.INT3 == Int3 + 88676472 then
								PLAYER_HANDSHAKE_UPDATE[v] = tick();
							end;
						end;
					else
						v:Kick("Invalid response from client.");
					end;
				end);
			end;
		end;
	end;
end);

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

type Unban = {
	Target: string,
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

local on_ban = function(player , reason: string)
	Players:BanAsync({
		UserIds = {player.UserId},
		Duration = ANTI_CHEAT_BAN_CONFIG.Duration,
		DisplayReason = ANTI_CHEAT_BAN_CONFIG.Message:gsub("[FLAG_REASON]",tostring(reason)),
		PrivateReason = "RMU ANTI CHEAT - "..tostring(reason),
		ExcludeAltAccounts = ANTI_CHEAT_BAN_CONFIG.ExcludeAltAccounts,
		ApplyDeviceBlock = ANTI_CHEAT_BAN_CONFIG.ApplyDeviceBlock,
	});
	
	ClientCore:FireClient(player);
end;

ClientCore.OnServerEvent:Connect(on_ban);

local Actions = {
	Kick = function(args: Kick)
		local Target: Player = Players:FindFirstChild(args.Target);
		Target:Kick(args.Reason);
	end,
	
	Ban = function(args: Ban)
		local Target: Player = Players:GetPlayerByUserId(args.Target);
	
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
	
	Unban = function(args: Unban)
		Players:UnbanAsync({
			UserIds = {tonumber(args.Target)},	
			ApplyToUniverse = true,
		})
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

