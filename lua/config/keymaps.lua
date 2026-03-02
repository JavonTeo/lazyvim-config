-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

map({ "n", "x" }, "<leader>gb", "<nop>")
map({ "n", "x" }, "<leader>gB", "<nop>")
map({ "n", "x" }, "<leader>gY", "<nop>")
map("n", "<leader>lw", "<cmd>set wrap!<CR>")
