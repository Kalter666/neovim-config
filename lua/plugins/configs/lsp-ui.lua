local LspUI = require("LspUI")
local lsp_ui_config = require("LspUI.config")

lsp_ui_config.hover_setup({
  enable = true,
})


lsp_ui_config.inlay_hint_setup({
  enable= true,
})

LspUI.setup()
