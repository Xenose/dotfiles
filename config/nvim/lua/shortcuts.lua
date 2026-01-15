local builtin = require('telescope.builtin')

vim.g.mapleader = " "

-- allows us to bring up the file manager
vim.keymap.set("n", "<leader>pv", ':Oil<CR>');

--[[
-- This allows visual mode to mode blocks of code
-- using the J and K keys.
]]--
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--[[
-- These keybindings allows for neovim
-- to move between tabs using the h and l keys
-- when \ (leader) is pressed  
]]--
vim.keymap.set("n", "<leader>h", ":tabp<CR>")
vim.keymap.set("n", "<leader>l", ":tabn<CR>")

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Pane changing
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

--[[
-- Setting up SnipRun allowing use to run small parts
-- of code in the NeoVim editor.
--
-- link to home page :: https://michaelb.github.io/sniprun
]]--pg pgn
vim.keymap.set("v", "<leader>cr", vim.cmd.SnipRun, {silent = true})
vim.keymap.set("n", "<leader>cr", vim.cmd.SnipRun, {silent = true})
vim.keymap.set("n", "<leader>cc", vim.cmd.SnipClose, {silent = true})

--[[
-- llvm models
-- ollama
]]--
-- vim.keymap.set({ 'n', 'v' }, '<leader>aa', ':Gen Ask<CR>')

-- Telescope shortcuts
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
