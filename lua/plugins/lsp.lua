return {
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- Setup capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      -- Setup mason
      require("mason").setup()
      require("mason-lspconfig").setup()

      -- Register ty server (not yet in nvim-lspconfig by default)
      local configs = require("lspconfig.configs")
      if not configs.ty then
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ty"
        configs.ty = {
          default_config = {
            cmd = { mason_bin, "server" },
            filetypes = { "python" },
            root_dir = function(fname)
              return require("lspconfig.util").root_pattern("pyproject.toml", "ty.toml", ".git")(fname)
                or vim.fn.fnamemodify(fname, ":h")
            end,
            single_file_support = true,
            settings = {
              ty = {
                diagnosticMode = "workspace",
              },
            },
          },
        }
      end

      -- Setup servers (only ty is used for Python, not pyright/basedpyright/pylsp)
      local servers = {
        clangd = {},
        ruff = {},
        html = {},
        cssls = {},
        jsonls = {},
        biome = {},
        ty = {},
        ts_ls = {},
        markdownlint = {},
        -- lua_ls = {
        -- settings = {
        -- Lua = {
        --   diagnostics = {
        --     globals = { "vim" }, -- for lsp recognize `vim` global
        --   },
        -- },
        -- },
        -- },
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "prettierd",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -- NOTE: not sure why putting this in when I already have the above lua_ls config is required for desired effect
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- vim.lsp.config("cssls", {
      --   filetypes = {
      --     "css",
      --     "scss",
      --     "less",
      --     "javascript",
      --     "javascriptreact",
      --     "typescript",
      --     "typescriptreact",
      --     "vue",
      --   },
      -- })

      -- Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local fzf = require("fzf-lua")

          map("gd", fzf.lsp_definitions, "[G]oto [D]efinition")
          map("gr", fzf.lsp_references, "[G]oto [R]eferences")
          -- map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          border = "rounded", -- Enables borders for the main menu
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      -- Border styling for the menus
      local pmenu_hl_group = vim.api.nvim_get_hl(0, { name = "Pmenu" })
      pmenu_hl_group.fg = "#96967e"
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", pmenu_hl_group)
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if not vim.g.format_on_save then
          return nil
        end
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        markdown = { "markdownlint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  -- Vue LSP config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local vue_language_server_path = vim.fn.expand("$MASON/packages")
        .. "/vue-language-server"
        .. "/node_modules/@vue/language-server"
      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      local ts_ls_config = {
        init_options = {
          plugins = {
            vue_plugin,
          },
        },
        filetypes = tsserver_filetypes,
        on_attach = function(client)
          local existing_capabilities = client.server_capabilities
          if vim.bo.filetype == "vue" then
            existing_capabilities.semanticTokensProvider.full = false
          else
            existing_capabilities.semanticTokensProvider.full = true
          end
        end,
      }
      local vue_ls_config = {}
      vim.lsp.config("vue_ls", vue_ls_config)
      vim.lsp.config("ts_ls", ts_ls_config)
      vim.lsp.enable({ "ts_ls", "vue_ls" })
    end,
  },
}
