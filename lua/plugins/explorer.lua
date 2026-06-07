return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>yy",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "[Y]azi",
      },
      {
        "<leader>ycd",
        "<cmd>Yazi cwd<cr>",
        desc = "[Y]azi current dir",
      },
      {
        "<leader>yr",
        "<cmd>Yazi toggle<cr>",
        desc = "[Y]azi [R]esume last session",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
