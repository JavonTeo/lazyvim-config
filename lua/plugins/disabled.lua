return {
	-- disable in favour of explorer.lua
	{ "folke/snacks.nvim", 
		opts = {
			explorer = { enabled = false },
		},
		keys = {
			{ "<leader>fe", false},
			{ "<leader>fE", false},
		},
	},
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false }
}
