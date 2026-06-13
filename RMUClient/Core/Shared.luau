local Shared = {
	Logs = {},
	CNCharacters = "的一是不了人在有我他这为之大这也上以中到出时可也业生自会面么公共个多方好年无事情没同群起之";
};

function Shared:RandomString()
	local a = {};
	
	for i = 0, 10 do
		local ran = math.random(1,#Shared.CNCharacters)
		table.insert(a,string.sub(Shared.CNCharacters,ran,ran))
	end;
	
	return table.concat(a)
end;

Shared.Modules = {};
Shared.ReplicatedStorage = game:GetService('ReplicatedStorage');
Shared.RMUSocket = Shared.ReplicatedStorage:WaitForChild('RMUtil');
Shared.Function = Shared.RMUSocket:WaitForChild('Function');
Shared.Remote = Shared.RMUSocket:WaitForChild('Remote');
Shared.Request = Shared.RMUSocket:WaitForChild('Request');
Shared.RMUClient = game:GetService('ReplicatedFirst'):WaitForChild('RMUClient');

-- Load Config --

local ConfigScript = Shared.RMUSocket:WaitForChild('Config');
local Config = table.clone(require(ConfigScript));

ConfigScript.Parent = nil;
ConfigScript:Destroy();

Shared.RMUConfig = Config;
Shared.set = function(i,v)
	Shared[i] = v;
end;

Shared.get = function(i)
	return Shared[i];
end;

Shared.Log = function(message)
	table.insert(Shared.Logs,tostring(message));
	print('[RMU]:',message);
end;

getfenv().shared.RMULog = Shared.Log;
getfenv().shared.SAVE_LOG = function()
	return table.concat(Shared.Logs,'\n');
end;

Shared.Request.OnClientInvoke = function()
	local log_his = game:GetService('LogService'):GetLogHistory();
	local data = {};
	
	for i,v in next , log_his do
		table.insert(data,v.message);
	end;
	
	return {
		RMU = getfenv().shared.SAVE_LOG(),
		console = table.concat(data,'\n');
	};
end

-- Load Modules --
for i,v in next , script.Parent:GetChildren() do
	if v == script then
		continue;
	end;

	local Module = require(v);

	Module.Shared = Shared;

	if Module.Init then
		Module.Init(Shared);
	end;

	Shared.Modules[v.Name] = Module;

	v.Name = Shared:RandomString();
end;

-- Connection --

Shared.FireServer = function(Name, ...)
	Shared.Remote:FireServer(Name,...);
end;

Shared.InvokeServer = function(...)
	return Shared.Function:InvokeServer(...);
end

task.delay(1,function()
	Shared.RMUClient.Name = Shared:RandomString();
end)

return Shared;

