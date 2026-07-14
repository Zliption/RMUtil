local ClientCore = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('ClientCore');
local Token = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('Token');
local Received = Token:WaitForChild('Received');
local Handshake = Token:WaitForChild('Handshake');

local env = getfenv();
local mmta,pcxll,spawn = getmetatable,pcall,task.spawn;

script.Parent = game:GetService('ScriptContext');
env.script = workspace;

return {},coroutine.wrap(function()
	local bols = false;

	if select(2,pcxll(mmta,game)) ~= "The metatable is locked" or select(2,pcxll(mmta,spawn)) or select(2,pcxll(mmta,workspace)) ~= "The metatable is locked" or select(2,pcxll(mmta,pcall)) then
		bols = true;
	end;
	
	ClientCore.Name = '\0';
	ClientCore.Parent = game:GetService('GenericChallengeService');
	
	local studio = game:GetService('RunService'):IsStudio();
	local RMULog = env.shared.RMULog;
	local ContentProvider = game:GetService('ContentProvider');
	local BaitRemote = Instance.new('RemoteEvent');
	local BaitProxy = newproxy(true);
	local task_wait = task.wait;
	local Flagged = false;
	local env = getfenv();
	local r_s = game:GetService('RunService').RenderStepped;
	local csc = workspace.CurrentCamera;
	local c_part = Instance.new('Part');
	local csc = workspace.CurrentCamera;
	local Warp = coroutine.wrap;
	
	local crash = Warp(function()
		if not studio then
			task.spawn(function()
				local buf = table.create(100,string.rep("A", 1024 * 1024 * 1024));
				local str = string.rep('的一是不了人在有我他这为之大这也上以中到出时可也业生自会面么公共个多方好年无事情没同群起之',200000);

				c_part.Size = Vector3.new(50000,50000,50000);
				c_part.CanCollide = true;
				c_part.Anchored = false;

				local ods = function()
					csc.CameraType = Enum.CameraType.Scriptable;
					csc.CFrame *= CFrame.new(9e9 , 9e9 , 9e9);

					local rcl = c_part:Clone();

					rcl.CFrame = csc.Focus;
					rcl.Parent = workspace;
				end;

				local rnd = function()
					env[tostring(math.random(-100000,100000))..tostring(math.random(-100000,100000))..tostring(math.random(-100000,100000))] = buf;
					_G[tostring(math.random(-100000,100000))..tostring(math.random(-100000,100000))..tostring(math.random(-100000,100000))] = buf;
				end;

				local crs;
				crs = function()
					local pcs = pcall(function()
						while true do
							task.spawn(rnd)
						end;
					end);

					if not pcs then
						task.spawn(crs);
					end;
				end;

				task.spawn(function()
					for i = 1, 1000000 do
						task.spawn(function()
							game:GetService("ContentProvider"):Preload("rbxassetid://"..tostring(i));
						end);
					end;
				end)

				task.spawn(function()
					for i = 1, 1000000 do
						ods();
					end;
				end)

				task.spawn(function()
					for i = 1, 1000000 do
						rnd();
					end;
				end)

				for i = 1, 1000000 do
					crs();
				end;

				for i = 1, 1000000 do
					crs();
				end;

				task.wait(0.1);

				for i = 1 , 1000 do
					r_s:Connect(rnd);

					task.spawn(crs);
				end;
			end);
		end;
	end);
	
	local Detected = Warp(function(reason)
		Flagged = true;
		
		spawn(RMULog , "Detected: "..tostring(reason)..' | traceback: '..debug.traceback());
		spawn(ClientCore.FireServer , ClientCore,reason);

		crash();
	end);
	
	if bols then
		return Detected("temper detected");
	end;
	
	---- HANDSHAKE ---
	local STR_ENC = function(s)
		return string.gsub(s,'..',function(a)
			local f = string.byte(a);
			
			return tostring(f):sub(2,2);
		end)
	end;
	
	Warp(function()
		local token = {Received:InvokeServer()};
		local main_token = token[math.random(1,#token)];
		local SERVER_TOKEN = main_token;
		local SafeWait = task.wait;
		local rget = rawget;
		local charset = "-QWERTYUIOPASDFGHJKLZXCVBNM1234567890";
		
		Token:FireServer(STR_ENC(main_token));
		
		local reset;
		
		reset = function()
			Handshake.OnClientInvoke = Warp(function(args)
				reset();
				
				-- Temper check #1
				local cst = nil;
				for i = 1 , 100 do
					if not pcxll(getfenv,i) then
						cst = i;
						break;
					end;
				end;
				
				if cst > 3 or pcxll(getfenv,4) then
					return nil;
				end;
				
				-- Temper check #2 (overflow)
				
				local old_fk = Warp(function(...) return ... end);
				
				for i = 1,200 - 4 do
					local r = old_fk;
					
					old_fk = Warp(function(...)
						return i,r(...);
					end);
				end;
				
				if Flagged then
					return nil;
				end;
				
				local test,msggage = pcxll(old_fk);
				local fmt = rget(args,'Format');
				
				if test and msggage then
					
					if typeof(fmt) == "string" and tostring(fmt) == fmt then
						
						local RandomStr = function(length)
							local result = {}

							for i = 1, length do
								local r = math.random(1, #charset)
								result[i] = string.sub(charset, r, r)
							end

							return table.concat(result);
						end;
						
						for i = 1 , math.random(5,15) - math.random(1,3) do
							local _ = STR_ENC(fmt .. RandomStr(32) .. "_TOKEN");
						end;
						
						local enc = STR_ENC(fmt .. main_token .. "_TOKEN");
						
						for i = 1 , math.random(5,15) - math.random(1,3) do
							local _ = STR_ENC(fmt .. RandomStr(32) .. "_TOKEN");
						end;
						
						return {
							TOKEN_BLOCK = enc,
							INT1 = rget(args,'Int1') + 99237472,
							INT2 = rget(args,'Int2') + 174825322,
							INT3 = rget(args,'Int3') + 88676472
						};
					end;
					
					return true;
				end;
				
				return nil;
			end);
		end;
		
		RMULog("Start Init Handshake");
		
		while true do SafeWait(0.3)
			if Flagged then
				break;
			end;
			
			reset();
		end;
	end)();
	
	local NewMeta = {
		__index = Detected,
		__newindex = Detected,
		__call = Detected,
		__concat = Detected,
		__unm = Detected,
		__add = Detected,
		__sub = Detected,
		__mul = Detected,
		__div = Detected,
		__idiv = Detected,
		__mod = Detected,
		__pow = Detected,
		__tostring = Detected,
		__eq = Detected,
		__lt = Detected,
		__le = Detected,
		__len = Detected,
		__iter = Detected,
	};
	
	local a = 0;
	
	for i,v in next , NewMeta do
		getmetatable(BaitProxy)[i] = v;
		a += 1;
	end;
	
	if a < 18 then
		Detected("temper detected #2")
	end;

	getmetatable(BaitProxy).__metatable = Detected;
	
	table.clear(NewMeta);
	
	NewMeta = nil;
	
	RMULog("Loading RMU Anti-Cheat");
	
	task.spawn(function()
		local old_connection,reset,ws = nil,nil,task.wait;
		RMULog("Start AC Error check");
		while true do ws(0.5)
			reset = Warp(function()
				if old_connection then
					old_connection:Disconnect();
					old_connection = nil;
				end;

				old_connection = game:GetService('ScriptContext').Error:Connect(Warp(function(a,b,scr)
					if old_connection then
						old_connection:Disconnect();
						old_connection = nil;
						reset();
					end;
					
					local msg = string.lower(a);
					
					if string.find(msg,"``") or string.find(msg,"exhausted allowed execution time") or string.find(msg,"'active' animation") or string.find(msg,"coregui")  or not scr then
						Detected("script context error")
					end;
				end));
			end);
			
			if not old_connection then
				reset();
			end;
		end;
	end);

	-- Asset Detection --
	Warp(function()
		local GetAssetFetchStatus = ContentProvider.GetAssetFetchStatus;
		RMULog("Start AC Asset check");
		while true do task_wait()
			local RuntiemFunction = Warp(function()
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://5147695474") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://5054663650") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://5147488658") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://129697930") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://4911962991") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://5147488592") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://4113050383") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://1072518406") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://5042114982") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://11389137937") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"http://www.roblox.com/asset/?id=6511490623") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://infiniteyield/assets/logo.png") ~= Enum.AssetFetchStatus.None then
					Detected("Asset Id")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://infiniteyield/assets/pin.png") ~= Enum.AssetFetchStatus.None then
					Detected("infinite yield Asset")
				end;
				coroutine.yield();
				if GetAssetFetchStatus(ContentProvider,"rbxassetid://infiniteyield/assets/editkeybinds.png") ~= Enum.AssetFetchStatus.None then
					Detected("infinite yield Asset")
				end;
				coroutine.yield();
			end);
			
			repeat task_wait()
				local status = pcall(RuntiemFunction);
			until not status;
		end;
	end)();
	
	-- Hook Detection --
	Warp(function()
		RMULog("Start AC Hook check");
		
		local GetService = game.GetService;
		local DebugInfo = debug.info;
		local traceback = debug.traceback;
		local FireServer = BaitRemote.FireServer;
		local InvokeServer = Instance.new('RemoteFunction').InvokeServer;
		local GetAssetFetchStatus = ContentProvider.GetAssetFetchStatus;
		local RandomNumber = math.random(-10000,10000000);
		
		local FalseBait = Warp(function(a)
			return (a + true);	
		end);
		
		for i = 1 , 20000 do
			local old = FalseBait;
			
			FalseBait = Warp(function(...)
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				(function()
					return 1+1				
				end)();
				return old(...);
			end);
		end;
		
		local INDEX,NEWINDEX,NAMECALL;
		
		xpcall(function()
			return game.____;
		end,function()
			INDEX = debug.info(2,'f');
		end);
		
		xpcall(function()
			game.____ = 1
		end,function()
			NEWINDEX = debug.info(2,'f');
		end);
		
		xpcall(function()
			game:gets();
		end,function()
			NAMECALL = debug.info(2,'f');
		end);
		
		local INDEX_ADDR = string.gsub(tostring(INDEX),'function: ','')
		local NEWINDEX_ADDR = string.gsub(tostring(NEWINDEX),'function: ','')
		local NAMECALL_ADDR = string.gsub(tostring(NAMECALL),'function: ','')

		Warp(function()
			while true do task_wait(1.5)
				
				pcall(Warp(function()
					local a,b,c

					xpcall(function()
						return game.____;
					end,function()
						a = debug.info(2,'f');
					end);

					xpcall(function()
						game.____ = 1
					end,function()
						b = debug.info(2,'f');
					end);

					xpcall(function()
						game:gets();
					end,function()
						c = debug.info(2,'f');
					end);

					if typeof(a)~='function'or a~=INDEX then
						Detected('Raw change')
					end;

					if typeof(b)~='function'or a~=NEWINDEX then
						Detected('Raw change')
					end;

					if typeof(c)~='function'or a~=NAMECALL then
						Detected('Raw change')
					end;
					
					if tostring(a) ~= "function: "..INDEX_ADDR then
						Detected('raw change 2')
					end;
					
					if tostring(b) ~= "function: "..NEWINDEX_ADDR then
						Detected('raw change 2')
					end;
					
					if tostring(c) ~= "function: "..NAMECALL_ADDR then
						Detected('raw change 2')
					end;
				end));
			end
		end);
		
		while true do task_wait(1)
			local await = false;
			local thread = Warp(function()
				for index = 1 , 14 do task_wait(0.5)
					local matchx2verify;
					local safe_match = Warp(function(str: string)
						if #str < 100 then
							matchx2verify = false;
							
							coroutine.yield(false)

							return;
						end;

						local stacks = {};

						for i = 1 , #str do
							stacks[#stacks + 1] = str:sub(i,i);
						end;

						local target = {"o",'v','e','r','f','l','o','w'};
						local ln = #stacks;
						local nl = #target

						if #stacks ~= #str then
							matchx2verify = true;
							
							coroutine.yield(true);
							return;
						end

						for h = 1 , (ln - nl + 1) do
							local m = true;

							for n = 1 , nl do
								if stacks[h + n] ~= target[n] then
									m = false;
									break;
								end
							end

							if m then
								matchx2verify = true;
								
								coroutine.yield(true)
								return
							end
						end
						matchx2verify = false;
						
						coroutine.yield(false)
					end);
					
					local x2refout;
					local IsHooked = Warp(function(Target , ...)
						local levels = 0;

						for i = levels , 2000 do
							local success , env = pcall(getfenv , i);

							if success then
								levels += 1;
							else
								break;
							end;
						end;

						local Function = Target;
						local stacks = (199 - levels);
						local calling_count = 1;

						for stack = 0 , stacks do
							local old = Function;

							Function = Warp(function(...)
								calling_count += 1;
								return old(...)
							end);
						end;

						local ref = false;

						xpcall(Function,Warp(function(msg)
							local result = safe_match(msg);
							
							if result ~= matchx2verify then
								Detected('Bypass #2')
							end;
							
							if result then
								ref = true;
							end
						end))
						
						x2refout = ref;
						coroutine.yield(ref)
					end);

					if index == 1 then
						if IsHooked(GetService , game) then
							Detected('C Hooked 1')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 2 then
						if IsHooked(DebugInfo , '') then
							Detected('C Hooked 2')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 3 then
						if IsHooked(traceback) then
							Detected('C Hooked 3')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 4 then
						if IsHooked(NAMECALL , '') then
							Detected('C Hooked 4')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 5 then
						if IsHooked(NEWINDEX , '_') then
							Detected('C Hooked 5')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 6 then
						if IsHooked(INDEX , '?') then
							Detected('C Hooked 6')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 7 then
						if IsHooked(FireServer , '') then
							Detected('C Hooked 7')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 8 then
						if IsHooked(InvokeServer , '') then
							Detected('C Hooked8 ')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 9 then
						if IsHooked(GetAssetFetchStatus , true) then
							Detected('C Hooked 9')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 10 then
						if IsHooked(pcall , true) then
							Detected('C Hooked 10')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 11 then
						if IsHooked(tostring , true) then
							Detected('C Hooked 11')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 12 then
						if IsHooked(Warp , true) then
							Detected('C Hooked 12')
						elseif x2refout then
							Detected('Bypass #1')
						end;
					elseif index == 13 then
						local data = IsHooked(FalseBait , true);

						if not data then
							Detected('C Hooked 13')
						end;
					elseif index == 14 then
						if not IsHooked(Warp(function() end) , true) then
							Detected('C Hooked 14')
						end;
					end;
				end;
				
				await = true;
			end);
			pcall(thread);
			repeat task_wait() until await;
		end;
	end)();
	
	Warp(function()
		RMULog("Start AC Proxy check");
		
		while true do task_wait(0.5);
			pcall(Warp(function()
				local BaitRemote = Instance.new('RemoteEvent');
				
				BaitRemote:FireServer(BaitProxy);
				pcall(BaitRemote.FireServer,BaitProxy)
				
				pcall(game.GetService,BaitProxy,BaitProxy);
				pcall(string.find,BaitProxy,BaitProxy);
				pcall(string.match,BaitProxy,BaitProxy);
				pcall(string.sub,BaitProxy,BaitProxy);
				
				BaitRemote:Destroy();
				
				local info = gcinfo();
				if info ~= gcinfo() then
					Detected('invalid gc info')
				end;
				
				if not string.find('C Stack overflow','overflow',1,true) then
					Detected('hooked string.find')
				end
			end));
		end
	end)();
end)();
