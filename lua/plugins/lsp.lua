return {

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ["*"] = {
          keys = {
            {
              "<leader>td",
              function()
                if vim.diagnostic.is_enabled() then
                  vim.diagnostic.enable(false)
                  vim.notify("Diagnostics disabled globally", vim.log.levels.INFO)
                else
                  vim.diagnostic.enable(true)
                  vim.notify("Diagnostics enabled globally", vim.log.levels.INFO)
                end
              end,
              desc = "[T]oggle [D]iagnostics",
              has = "diagnostic",
            },
          },
        },
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        clangd = {},
        ruff = {},
        html = {},
        cssls = {},
        jsonls = {},
        biome = {},
      },
    },
  },
}

