return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "kiennt63/harpoon-files.nvim",
        dependencies = { { "ThePrimeagen/harpoon", branch = "harpoon2" } },
        icon = "",
        opts = {
          max_length = 7,
          separator_left = " ",
          separator_right = "",
          reverse_order = true,
        },
      },
      "nvim-tree/nvim-web-devicons",
      "ecthelionvi/neocomposer.nvim",
    },
    config = function()
      local mode = {
        "mode",
        fmt = function(str)
          return str
        end,
      }
      local harpoon_files = require("harpoon_files")
      require("lualine").setup({
        options = {
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
            "alpha",
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16,
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { require("NeoComposer.ui").status_recording },
          },
          lualine_x = { harpoon_files.lualine_component },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "fugitive" },
      })
    end,
  },

  -- Breadcrumbs
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = true,
          separator = " ",
          hide_keyword = true,
          show_file = true,
          folder_level = 5,
          color_mode = true,
        },
        hover = {
          enable = true,
        },
        lightbulb = {
          enable = false, -- disable lightbulb to avoid clutter
        },
      })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },
      config = {
        header = {
          "",
          "",
          "",
          "",
          "",
          "",
        },
        center = {
          {
            action = function()
              require("persistence").load()
            end,
            desc = " Restore Session",
            icon = "󰁯 ",
            key = "s",
          },
          { action = "FzfLua files", desc = " Find File", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          { action = "FzfLua oldfiles", desc = " Recent Files", icon = " ", key = "r" },
          { action = "FzfLua live_grep", desc = " Find Text", icon = " ", key = "g" },
          { action = "e $MYVIMRC", desc = " Config", icon = " ", key = "c" },
          { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    },
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },

  -- Better UI for notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      background_colour = "#000000",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Noice (better UI for messages, cmdline, popupmenu)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        hover = {
          enabled = true, -- use Lspsaga hover_doc instead
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        -- Suppress "No Information Available" hover notifications
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      {
        "<leader>N",
        function()
          vim.cmd("Noice fzf")
        end,
        desc = "Show Noice",
      },
    },
  },

  -- Todo comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "<leader>y", group = "yazi" },
          { "<leader>t", group = "toggle" },
          { "<leader>w", group = "windows" },
          { "<leader>", group = "visits" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },
}
