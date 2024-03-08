local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "pyright",
  "angularls",
  "rust_analyzer",
  "hls",
  "eslint",
  "ruff_lsp",
  "jsonls",
  "cmake",
  "zls",
  "gopls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
    inlay_hints = {
      enabled = true,
    },
  }
end
