local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "rust",
    "zig",
    "jsdoc",
    "comment",
    "ispc",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "json-lsp",
    "eslint-lsp",

    -- c/cpp stuff
    "clang-format",
    "rust-analyzer",
    "selene",
    "sqlfluff",
    "haskell-language-server",
    "pyright",
    "mypy",
    "zls",
    "ruff-lsp",
    "shellcheck",
    "vacuum",
    "actionlint",
    "buf",
    "cpplint",
    "hadolint",
    "markdownlint",
    "revive",
    "stylelint",
    "cmake-language-server",
    "yaml-language-server",
    "gopls",
    "angular-language-server",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
