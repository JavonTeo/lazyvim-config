-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.diagnostic.enable(false)

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus" -- unset LazyVim's clipboard setting
-- vim.schedule(function() -- and schedule...
--   vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
-- end)

vim.opt.tabstop = 4 -- number of spaces that <Tab> counts for
vim.opt.shiftwidth = 4 -- number of spaces for each indent level
vim.opt.smartindent = true -- smart autoindenting on new lines
vim.opt.autoindent = true -- copy indent from current line when starting new one

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 20
