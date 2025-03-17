
--- Package List ---
-- * aura-neovim		: https://github.com/techtuner/aura-neovim
-- * gitsigns.nvim	: https://github.com/lewis6991/gitsigns.nvim
-- * lsp-zero.nvim	: https://github.com/VonHeikemen/lsp-zero.nvim
-- * noice.nvim		: https://github.com/folke/noice.nvim
-- * nvim-notify		: https://github.com/rcarriga/nvim-notify
-- * oil.nvim			: https://github.com/stevearc/oil.nvim
-- * sniprun			: https://github.com/michaelb/sniprun
-- * telescope.nvim	: https://github.com/nvim-telescope/telescope.nvim
-- * tokyodark.nvim	: https://github.com/tiagovla/tokyodark.nvim
-- * treesitter		: https://github.com/nvim-treesitter
-- * alpha-nvim		: https://github.com/goolord/alpha-nvim
-- * neogit				: https://github.com/NeogitOrg/neogit

-- Core configurations
require("pkgmng")
require("options")
require("shortcuts")

-- Plugin configurations
require("plugins.lsp")
require("plugins.treesitter")
require("plugins.lualine")
require("plugins.oil")
require("plugins.noice")
require("plugins.codesnap")
require("plugins.notify")
require("plugins.gitsigns")
--require("plugins.nvim-cmp")

-- Nice to have plugin, but not needed.
require("plugins.gen")
