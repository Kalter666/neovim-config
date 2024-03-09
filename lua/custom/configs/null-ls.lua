local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local b = null_ls.builtins
local sources = {

  -- webdev stuff
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "javascript", "typescript", "json" } }, -- so prettier works only on these filetypes
  b.diagnostics.vacuum,
  b.diagnostics.stylelint,
  -- Luav
  b.formatting.stylua,
  b.diagnostics.selene,

  -- python
  b.diagnostics.mypy,

  -- go
  b.formatting.gofmt,
  b.diagnostics.revive,

  -- other
  b.diagnostics.actionlint,
  b.diagnostics.buf,
  b.diagnostics.hadolint,
  b.diagnostics.markdownlint,
  b.diagnostics.sqlfluff,
  b.formatting.d2_fmt,
}

null_ls.setup {
  debug = false,
  sources = sources,
  debounce = 500,
  -- on_attach = function(client, bufnr)
  --   if client.supports_method "textDocument/formatting" then
  --     vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  --
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.buf.format { bufnr = bufnr }
  --       end,
  --     })
  --   end
  -- end,
}
