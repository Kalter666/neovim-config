local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
  servers = {
    on_attach = on_attach,
    capabilities = capabilities,
    checkOnSave = {
      command = "clippy",
    }
  },
}

return options
