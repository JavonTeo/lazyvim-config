return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")

      -- set up python debug adaptor. Automatically done w dap-python
      local python_path = "/home/javon.teo/miniforge3/envs/quartz/bin/python"
      require("dap-python").setup(python_path)
      require("dap-python").test_runner = "pytest"

      -- set up cpptools debugger
      local cpptools_path =
        "/home/javon.teo/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = cpptools_path,
      }

      -- set icons
      -- dapbreakpoint guifd #993939, #e06c75
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#e83341", bg = "#31353f" })
      local dap_signs = {
        DapBreakpoint = { text = "🛑", texthl = "DapBreakpoint" },
      }
      for sign_name, sign_desc in pairs(dap_signs) do
        vim.fn.sign_define(sign_name, sign_desc)
      end
      -- NOTE: deprecated highlight.create, use api.nvim_set_hl
      -- vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
      -- vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)
      -- vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
      -- vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
      -- vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
      -- vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
      -- vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

      -- event listeners
      local dapui = require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "folke/lazydev.nvim" },
    opts = {
      element_mappings = {
        breakpoints = {
          expand = "<2-LeftMouse>",
          open = { "<CR>", "o" },
        },
        stacks = {
          expand = "<2-LeftMouse>",
          open = { "<CR>", "o" },
        },
      },
    },
    keys = {
      {
        "<leader>Du",
        function()
          require("dapui").toggle()
        end,
        desc = "Dapui toggle",
      },
      {
        "<leader>Db",
        function()
          require("dap").toggle_breakpoint()
          require("dapui").elements.breakpoints.render()
        end,
        desc = "Breakpoint (Dap)",
      },
      {
        "<leader>Dc",
        function()
          require("dap").continue()
          -- WARN: using this commented method in replacement of listener doesnt cause the console to autorender upon launch
          -- local windows = require("dapui.windows")
          -- local windowsOpen = false
          -- if windows and windows.layouts and #windows.layouts > 0 then
          --   for i = 1, #windows.layouts do
          --     if windows.layouts[i]:is_open() then
          --       windowsOpen = true
          --     end
          --     break
          --   end
          -- end
          -- if not windowsOpen then
          --   require("dapui").open()
          -- end
        end,
        desc = "Continue (Dap)",
      },
      {
        "<leader>Dn",
        function()
          require("dap").step_over()
        end,
        desc = "Next (Dap)",
      },
      {
        "<leader>Dq",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Stop session (Dap)",
      },
    },
    config = function(_, opts)
      require("dapui").setup(opts)
      require("lazydev").setup({
        library = { "nvim-dap-ui" },
      })
      -- set theme of dapui windows
      local function get_inactive_hl(theme_name, hl_group)
        local current_theme = vim.g.colors_name
        vim.cmd("silent! colorscheme " .. theme_name)
        local hl_data = vim.api.nvim_get_hl(0, { name = hl_group, link = true })
        vim.cmd("silent! colorscheme " .. current_theme)
        return hl_data
      end
      local vim_normal_hlgroup = get_inactive_hl("moonfly", "Normal")
      -- print(vim.inspect(vim_normal_hlgroup)) -- DEBUG code: check if empty
      vim.api.nvim_set_hl(0, "DapUiNormal", vim_normal_hlgroup)

      -- clean up DAP session/dapui just before quitting neovim
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          local ok, dap = pcall(require, "dap")
          if ok and dap.session() then
            dap.terminate()
          end

          pcall(function()
            require("dapui").close()
          end)
        end,
      })
    end,
  },
}
