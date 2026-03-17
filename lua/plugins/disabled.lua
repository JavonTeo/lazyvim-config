return {
  -- disable in favour of explorer.lua
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      scroll = { enabled = false },
    },
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  -- disable to remove bufferline (top buffers)
  { "akinsho/bufferline.nvim", enabled = false },
}
