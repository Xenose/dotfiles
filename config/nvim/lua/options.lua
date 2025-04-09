-- Ignore this value
vim = vim or {}

-- Start of the actual settings
vim.opt.guicursor = "i-ci:hor30-iCursor-blinkwait200-blinkon100-blinkoff150"
vim.opt.spell = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.scrolloff = 8
vim.opt.scrolloff = 8
vim.opt.updatetime = 20
vim.opt.list = true
vim.opt.listchars = { tab = ' > ', space = '·' }
vim.opt.expandtab = false
vim.api.nvim_set_hl(0, "Comment", { fg = "#FF66CC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5dc5f8" })

-- Make header files for C to C files for vim
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.h",
	callback = function()
		vim.bo.filetype = "c"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "fortran", "f90", "f95" },
	callback = function()
		vim.opt_local.expandtab = true   -- Use spaces instead of tabs
		vim.opt_local.tabstop = 2         -- Set tab width to 2 spaces
		vim.opt_local.shiftwidth = 2      -- Set shift width to 2 spaces
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "py" },
	callback = function()
		vim.opt_local.expandtab = true   -- Use spaces instead of tabs
		vim.opt_local.tabstop = 4         -- Set tab width to 2 spaces
		vim.opt_local.shiftwidth = 4      -- Set shift width to 2 spaces
	end,
})

vim.diagnostic.config({
  virtual_text = {
    severity = {
			min = vim.diagnostic.severity.INFO,
			max = vim.diagnostic.severity.ERROR
		}
  }
})
