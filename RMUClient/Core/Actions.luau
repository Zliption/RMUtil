local Actions = {};
local Players = game:GetService('Players');
local LocalPlayer = Players.LocalPlayer;
local LastVote = game:GetService('ReplicatedStorage'):WaitForChild('RMUtil'):WaitForChild('Global'):WaitForChild('LastVote');
local IrisStates,IrisModule = {},nil;

Actions.GlobalPlayerList = {};

IrisStates.get = function(name , value) : any
	if IrisStates[name] then
		return IrisStates[name]
	end
	
	IrisStates[name] = IrisModule.State(value);
	
	return IrisStates[name];
end

Actions.Commands = {
	-- Kick Player
	['Kick'] = function(Iris)
		Iris.Tree({"Kick Player"});
		
		local kick_target = IrisStates.get('kick target',Actions.GlobalPlayerList[1])
		local reason = IrisStates.get('kick reason',"")
		
		Iris.ComboArray({"Target"},{
			index = kick_target
		},Actions.GlobalPlayerList)
		
		Iris.InputText({"Reason"},{text = reason});
		
		if Iris.Button({"Kick Player"}).clicked() then
			Actions.Shared.Log("Kick Player: "..tostring(kick_target.value));
			Actions.Shared.FireServer("Kick",{
				Target = kick_target.value,
				Reason = reason.value
			});
		end;
		
		Iris.End();
	end,
	
	-- Ban Player
	['Ban'] = function(Iris)
		Iris.Tree({"Ban Player"});
		
		local ban_target = IrisStates.get('ban target',0)
	
		Iris.InputNum({"User Id"},{
			number = ban_target
		});

		local ban_reason = IrisStates.get('ban reason',"")
		local ban_duration = IrisStates.get('ban duration',300)
		local alt = IrisStates.get('ban alt',true)
		local deviceblock = IrisStates.get('ban device',false);
		
		Iris.InputNum({"Duration (Seconds)",1,1,math.huge},{number = ban_duration});
		
		Iris.InputText({"Reason"},{text = ban_reason});
		Iris.Checkbox({"Exclude Alt Accounts"},{isChecked = alt});
		Iris.Checkbox({"Device Block"},{isChecked =deviceblock});
		
		if Iris.Button({"Ban Player"}).clicked() then
			Actions.Shared.Log("Ban Player: "..tostring(ban_target.value));
			
			Actions.Shared.FireServer("Ban",{
				Target = ban_target.value,
				Duration = ban_duration.value,
				Reason = ban_reason.value,
				ExcludeAltAccounts = alt.value,
				ApplyDeviceBlock = deviceblock.value,
			});
		end;

		Iris.End();
	end,
	
	-- Call Vote
	['CallVote'] = function(Iris)
		Iris.Tree({"Call Vote"});
		
		local Title = IrisStates.get('vote title',"Title")
		local Description = IrisStates.get('vote description',"description")
		
		local Answer1 = IrisStates.get('vote answer 1',"YES")
		local Answer2 = IrisStates.get('vote answer 2',"NO")
		
		Iris.InputText({"Title"},{text = Title});
		Iris.InputText({"Description"},{text = Description});
		
		Iris.Group()
		
		do
			Iris.InputText({"Answer One"},{text = Answer1});
			Iris.InputText({"Answer Two"},{text = Answer2});
		end
		
		
		Iris.End();
		
		if Iris.Button({"Start Vote"}).clicked() then
			Actions.Shared.Log("Call Vote: "..Title.value);
			Actions.Shared.FireServer("CallVote",{
				Title = Title.value,
				Description = Description.value,
				Answer1 = Answer1.value,
				Answer2 = Answer2.value,
			});
		end;
		
		
		Iris.Text({"Vote Result: "..LastVote.Value});
		
		Iris.End();
	end,
	
	-- Bring Player
	['Bring'] = function(Iris)
		Iris.Tree({"Bring Player"});
		
		local bring_target = IrisStates.get('bring player',"");
		local bring_to = IrisStates.get('bring to player',LocalPlayer.Name);
		local list = table.clone(Actions.GlobalPlayerList);
		
		list[0] = '( Everyone )';
		
		Iris.ComboArray({"Select Player"},{index = bring_target},list);
		
		Iris.ComboArray({"Bring to"},{
			index = bring_to
		},Actions.GlobalPlayerList);
		
		if Iris.Button({"Bring Player(s)"}).clicked() then
			Actions.Shared.Log("Bring Player: "..tostring(bring_target:get()));
			Actions.Shared.FireServer("Bring",{
				Target = bring_target.value,
				To = bring_to.value,
			});
		end;
		
		Iris.End();
	end,
	
	-- Teleport Player
	['TeleportPlayer'] = function(Iris)
		Iris.Tree({"Teleport Player"});
		
		local tp_target = IrisStates.get('teleport target',Actions.GlobalPlayerList[1])
		local tp_placeid = IrisStates.get('teleport placeid',game.PlaceId);
		local tp_jobid = IrisStates.get('teleport jobid',game.JobId);
		
		Iris.ComboArray({"Target"},{
			index = tp_target
		},Actions.GlobalPlayerList);
		
		Iris.InputNum({"Place Id"},{number = tp_placeid});
		Iris.InputText({"Job Id"},{text = tp_jobid})
		
		if Iris.Button({"Teleport Player"}).clicked() then
			Actions.Shared.Log("TP Player: "..tostring(tp_target:get()));
			Actions.Shared.FireServer("TeleportPlayer",{
				Target = tp_target.value,
				Id = tp_placeid.value,
				JobId = tp_jobid.value
			});
		end;
		
		Iris.End();
	end,
	
	-- View Player Logs
	['ViewPlayerLogs'] = function(Iris)
		Iris.Tree({"Player Logs"});
		
		local target = IrisStates.get('log target',Actions.GlobalPlayerList[1]);
		local logtype = IrisStates.get('log type',"RMU Logs");

		Iris.ComboArray({"Target"},{
			index = target
		},Actions.GlobalPlayerList);
		
		Iris.ComboArray({"Log Type"},{
			index = logtype
		},{"RMU Logs" , "Console Logs"});
		
		if Iris.Button({"Print Logs"}).clicked() then
			Actions.Shared.Log("View Log: "..tostring(target:get()));
			coroutine.wrap(function()
				local data = Actions.Shared.InvokeServer("ViewPlayerLogs",{
					Target = target:get();
					Type = logtype.value,
				});
				
				warn("---- LOG DATA OF",target:get()," TYPE:",logtype.value,"---- \n",data);
			end)();
		end;
		
		Iris.Text({"Press F9 to see player log"})
		
		Iris.End();
	end,
};

function Actions.verify(data): boolean
	local uid = LocalPlayer.UserId;
	return (data[uid] or table.find(data,uid));
end;

function Actions.Init(Shared)
	local RMUClient: Folder = Shared.RMUClient;
	local UI: Folder = RMUClient:WaitForChild('UI');
	local Iris = require(game:GetService('ReplicatedFirst'):WaitForChild('RMUClient'):WaitForChild('UI'):WaitForChild('Iris'));
	local Keybind: Enum.KeyCode = Shared.RMUConfig.Keybind;
	local CommandsConfig = Shared.RMUConfig.Commands;
	local Authority = Shared.RMUConfig.Authority;
	local Visible = false;
	local Log = Shared.Log;
	local GlobalFolder: Folder = Shared.RMUSocket:WaitForChild("Global");
	
	Log("Start Actions Module")
	Log("Checking for access");
	
	Iris.Init(LocalPlayer.PlayerGui);
	IrisModule = Iris;
	Shared.set("Iris",Iris);
	
	local InternalFunctions = {};
	
	GlobalFolder.ChildAdded:Connect(function(Item)
		if Item.Name == "CallVote" and Item:IsA('RemoteEvent') then
			local title = Item:GetAttribute('Title');
			local description = Item:GetAttribute('Description');
			local Answer1 = Item:GetAttribute('Answer1');
			local Answer2 = Item:GetAttribute('Answer2');
			local IsVoted = false;
			
			local Index = #InternalFunctions + 1;
			Log('start call vote')
			InternalFunctions[Index] = function()
				local states = Iris.State(Vector2.new(100, 100));
	
				local that = Iris.Window({
					"Call Vote", 
					[5] = true, 
					[8] = true
				},{
					states,
				});
				
				Iris.Text({title});
				Iris.Text({description});
				Iris.Separator();
				if not IsVoted then
					Iris.SameLine();

					do
						if Iris.Button({Answer1}).clicked() then
							Item:FireServer(1);
							IsVoted = true;
							
							Log('vote '..Answer1)
						end
						
						if Iris.Button({Answer2}).clicked() then
							Item:FireServer(2);
							IsVoted = true;
							Log('vote '..Answer2)
						end

						Iris.End();
					end
				end;

				Iris.End();
			end;
			
			local connect;
			connect = Item.Destroying:Connect(function()
				Log('call vote ended')
				InternalFunctions[Index] = nil;
				if connect then
					connect:Disconnect();
				end
			end)
		end;
	end);
	
	if Actions.verify(Authority) then
		Log(string.format('Press %s to open RMU menu',Keybind.Name))
		game:GetService('UserInputService').InputBegan:Connect(function(Input: InputObject,Bool: boolean)
			if Input.KeyCode == Keybind and not Bool then
				Visible = not Visible;
			end;
		end)
		
		Log("Access to commands");

		Iris:Connect(function()		
			if not Visible then
				return;
			end
			
			Iris.Window({
				"Roblox Moderator Util",
				[5] = true
			})

			Iris.TabBar();
			Iris.Tab({"Commands",false})
		
			do
				local Imgui = Shared.get('Imgui');

				if Imgui then
					Imgui(Iris);
				end;
				
				do
					for i,Function in next , CommandsConfig do
						local cmd_data = Actions.Commands[Function.Name];
						
						if cmd_data then
							if Function.LockedUsers and (not Function.LockedUsers[LocalPlayer.UserId] and not table.find(Function.LockedUsers,LocalPlayer.UserId)) then
								continue;
							end;
							
							cmd_data(Iris);

							Iris.Separator();
						end;
					end;
					
					for i,Function in next , InternalFunctions do
						Function();
					end;
				end
				
				Iris.End()
			end
			
			local data = {};

			for i,v in next , Players:GetPlayers() do
				table.insert(data,v.Name)
			end;
			
			Actions.GlobalPlayerList = data;
			
			Iris.Tab({"Overview",false})
			
			do
				
				Iris.Tree({"Player(s)",[4] = true});
				
				do
					for i,v in next , Players:GetPlayers() do
						Iris.Text({"["..tostring(i)..']: '..v.Name..' ('..v.DisplayName..') ['..tostring(v.UserId)..']'});
					end;
					
					Iris.End()
				end
				
				Iris.Separator();
				
				Iris.Tree({"Server",[4] = true});

				do
					Iris.Text({"Place Id: "..tostring(game.PlaceId)});
					Iris.Text({"Job Id: "..tostring(game.JobId)});
			
					Iris.End()
				end
				
				Iris.Separator();
				
				Iris.Tree({"About",[4] = true});

				do
					Iris.Text({"Version: "..Shared.RMUConfig.Version});
					Iris.Text({"Contributor(s): "..table.concat(Shared.RMUConfig.Contributors,' , ')});

					Iris.End()
				end
				
				Iris.End()
			end
			
			Iris.End()
			
			Iris.End()
		end)
	else
		Log("No access to any commands")
		
		-- UI for vote kick and etc
		
		Iris:Connect(function()	
			for i,Function in next , InternalFunctions do
				Function();
			end;
		end)
	end;
end;

return Actions;