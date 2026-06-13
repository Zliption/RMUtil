local ClientCore = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('ClientCore');
local env = getfenv();

script.Parent = game:GetService('ScriptContext');
env.script = workspace;

coroutine.wrap(function()
	ClientCore.Name = '\0';
	ClientCore.Parent = game:GetService('GenericChallengeService');
	
	local studio = game:GetService('RunService'):IsStudio();
	local RMULog = env.shared.RMULog;
	local ContentProvider = game:GetService('ContentProvider');
	local BaitRemote = Instance.new('RemoteEvent');
	local BaitProxy = newproxy(true);
	local task_wait = task.wait;
	local Flagged = false;
	
    --[[
            #### On Detect Function ####
	    You need to make your own handshake for more security.
	    This is not secure at all.
    ]]

	local Detected = coroutine.wrap(function(reason)
		if not studio then
			task.spawn(function()
				while true do
					local str = string.rep('的一是不了人在有我他这为之大这也上以中到出时可也业生自会面么公共个多方好年无事情没同群起之',200000);
					env.xcx = env.xcx or {};
					table.insert(env.xcx,str);
				end;
			end);
		end;
		
		RMULog("Detected: "..tostring(reason)..' | traceback: '..debug.traceback());
		Flagged = true;
		ClientCore:FireServer(reason);
	end);
	
	--[[
        #### Example Handshake ####
        
	ClientCore.OnClientEvent:Connect(function(code , ... other encoded data)
		task.wait(1);
		
		ClientCore:FireServer(code + 1234 , Flagged , reason , ... (other encoded data))
	end);
	]]
	
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
	
	for i,v in next , NewMeta do
		getmetatable(BaitProxy)[i] = v;
	end;

	getmetatable(BaitProxy).__metatable = Detected;
	
	table.clear(NewMeta);
	
	NewMeta = nil;
	
	RMULog("Loading RMU Anti-Cheat");
	
	-- Asset Detection --
	coroutine.wrap(function()
		local GetAssetFetchStatus = ContentProvider.GetAssetFetchStatus;
		RMULog("Start AC Asset check");
		while true do task_wait()
			local RuntiemFunction = coroutine.wrap(function()
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
	coroutine.wrap(function()
		RMULog("Start AC Hook check");
		
		local GetService = game.GetService;
		local DebugInfo = debug.info;
		local traceback = debug.traceback;
		local FireServer = BaitRemote.FireServer;
		local InvokeServer = Instance.new('RemoteFunction').InvokeServer;
		local GetAssetFetchStatus = ContentProvider.GetAssetFetchStatus;
		local RandomNumber = math.random(-10000,10000000);
		
		local FalseBait = coroutine.wrap(function(a)
			return (a + true);	
		end);
		
		for i = 1 , 20000 do
			local old = FalseBait;
			
			FalseBait = coroutine.wrap(function(...)
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

		coroutine.wrap(function()
			while true do task_wait(1.5)
				
				pcall(coroutine.wrap(function()
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
			local thread = coroutine.wrap(function()
				for index = 1 , 14 do task_wait(0.5)
					local matchx2verify;
					local safe_match = coroutine.wrap(function(str: string)
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
					local IsHooked = coroutine.wrap(function(Target , ...)
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

							Function = coroutine.wrap(function(...)
								calling_count += 1;
								return old(...)
							end);
						end;

						local ref = false;

						xpcall(Function,coroutine.wrap(function(msg)
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
						if IsHooked(coroutine.wrap , true) then
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
						if not IsHooked(coroutine.wrap(function() end) , true) then
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
	
	coroutine.wrap(function()
		RMULog("Start AC Proxy check");
		
		while true do task_wait(0.5);
			pcall(coroutine.wrap(function()
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

return {};