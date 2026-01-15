
local uname_o = vim.fn.system("uname -o"):lower()

if uname_o:match("android") or vim.env.TERMUX_VERSION then
	PLATFORM = "android"
else
	PLATFORM = "linux"
end

print("Neovim platform:", PLATFORM)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	-- automatically check for plugin updates
	checker = { enabled = true },

	{
		"folke/noice.nvim",
		event = "VeryLazy",

		config = function()
			require("plugins.noice")
			require("plugins.notify")
		end,

		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--	`nvim-notify` is only needed, if you want to use the notification view.
			--	If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},

	{ -- telescope
		"nvim-telescope/telescope.nvim", tag = '0.1.8',

		dependencies = {
			"nvim-lua/plenary.nvim"
		}
	},

	{ -- lualine
		"nvim-lualine/lualine.nvim",

		dependencies = {
			'nvim-tree/nvim-web-devicons'
		},

		config = function()
			require("plugins.lualine")
		end
	},

	{ -- oil
		"stevearc/oil.nvim",

		dependencies = {
			"echasnovski/mini.icons"
		},

		config = function()
			require("plugins.oil")
		end
	},

	{ -- LSP
		"VonHeikemen/lsp-zero.nvim", branch = "v4.x",

		config = function()
			require("plugins.lsp")
		end,

		dependencies = {
			-- LSP Support
			'neovim/nvim-lspconfig',
			--- Uncomment these if you want to manage LSP servers from neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			--- Autocompletion
				'hrsh7th/nvim-cmp',
				'hrsh7th/cmp-nvim-lsp',
			--- Snippets
			"L3MON4D3/LuaSnip",
		}
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			--"ibhagwan/fzf-lua",              -- optional
			--"echasnovski/mini.pick",         -- optional
		},
		config = true
	},

	{
		"tiagovla/tokyodark.nvim",
		opts = {
			transparent_background = true, -- set background to transparent
			gamma = 1.00, -- adjust the brightness of the theme
			terminal_colors = true, -- enable terminal colors
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd [[colorscheme tokyodark]]
		end,
	},

	{
		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons"
		},

		config = function()
			local startify = require("alpha.themes.startify")
			-- available: devicons, mini, default is mini
			-- if provider not loaded and enabled is true, it will try to use another provider
			startify.file_icons.provider = "devicons"
			require("alpha").setup(startify.config)
		end,
	},

	{
		"m4xshen/hardtime.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim"
		},
		opts = {}
	},

	--[[{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<F12>",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},]]--

	{ "mfussenegger/nvim-dap" },
	{ -- gitsigns
		"lewis6991/gitsigns.nvim",

		config = function()
			require("plugins.gitsigns")
		end
	},

	{
		"michaelb/sniprun",
		enabled = "android" ~= PLATFORM,
		build = "sh install.sh" 
	},

	{
		"mistricky/codesnap.nvim",
		enabled = "android" ~= PLATFORM,
		build = 'make',

		config = function()
			if PLATFORM == "android" then
				return
			end

			require("plugins.codesnap")
		end
	},

	{
		"nvim-treesitter/nvim-treesitter",
		enabled = "android" ~= PLATFORM,

		config = function()
			if PLATFORM == "android" then
				return
			end

			require("plugins.treesitter")
		end,
		build = ':TSUpdate'
	},

	{
		"nvim-treesitter/playground",
		enabled = "android" ~= PLATFORM,

		dependencies = {
			"nvim-treesitter/nvim-treesitter"
		},
	},

	{ "mbbill/undotree" },
	{ "David-Kunz/gen.nvim" },
})
