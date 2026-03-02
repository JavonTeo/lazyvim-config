return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      -- find
      { "<leader>/", false },
      { "<leader>:", false },
      { "<leader><space>", false },
      { "<leader>fB", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>fR", false },
      -- search
      { "<leader>sf", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>sG", false },
      { "<leader>sl", false },
      { "<leader>sM", false },
      { "<leader>sq", false },
      -- git
      { "<leader>gl", false },
    },
  },
}
