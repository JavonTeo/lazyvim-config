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
      { "<leader>sf", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sG", false },
      { "<leader>sl", false },
      { "<leader>sM", false },
      { "<leader>sq", false },
      -- git
      { "<leader>gl", false },
    },
  },
}
