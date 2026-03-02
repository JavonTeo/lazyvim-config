return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    end,
  },
}
