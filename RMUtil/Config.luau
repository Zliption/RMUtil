return {
	Commands = {
		{
			Name = "Kick",
		},
		{
			Name = "Ban",
			LockedUsers = {
				-- Only allow these users to use the command (User Id) --
				1
			},
		},
		{
			Name = "CallVote",
		},
		{
			Name = "Bring"
		},
		{
			Name = "TeleportPlayer"
		},
		{
			Name = "ViewPlayerLogs"
		}
	},
	Authority = {
		1,
		-- UserId Here --
	},
	Keybind = Enum.KeyCode.F2,
	Version = '1.0.0',
	Contributors = {'Zliption'}
};