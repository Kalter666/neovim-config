local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "javascript", "typescript" } }, -- so prettier works only on these filetypes
  b.diagnostics.eslint_d,
  b.diagnostics.vacuum,
  b.diagnostics.stylelint,
  -- Luav
  b.formatting.stylua,
  b.diagnostics.selene,

  -- cpp
  b.formatting.clang_format,
  b.diagnostics.cpplint,

  -- python
  b.diagnostics.mypy,
  b.formatting.ruff,

  -- go
  b.formatting.gofmt,
  b.diagnostics.revive,

  -- rust
  b.formatting.rustfmt.with {
    extra_args = function(params)
      local Path = require "plenary.path"
      local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

      if cargo_toml:exists() and cargo_toml:is_file() then
        for _, line in ipairs(cargo_toml:readlines()) do
          local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
          if edition then
            return { "--edition=" .. edition }
          end
        end
      end
      -- default edition when we don't find `Cargo.toml` or the `edition` in it.
      return { "--edition=2021" }
    end,
  },

  -- haskell
  b.formatting.fourmolu,

  -- other
  b.code_actions.refactoring,
  b.code_actions.shellcheck,
  b.diagnostics.semgrep,
  b.diagnostics.actionlint,
  b.diagnostics.buf,
  b.diagnostics.hadolint,
  b.diagnostics.markdownlint,
  b.diagnostics.sqlfluff,
  b.builtins.formatting.d2_fmt,
}

null_ls.setup {
  debug = true,
  sources = sources,
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
