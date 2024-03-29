local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      {
        "C-h",
        "<cmd> TmuxNavigateLeft <cr>",
        desc = "Tmux Navigate Left",
      },
      {
        "C-j",
        "<cmd> TmuxNavigateDown <cr>",
        desc = "Tmux Navigate Down",
      },
      {
        "C-k",
        "<cmd> TmuxNavigateUp <cr>",
        desc = "Tmux Navigate Up",
      },
      {
        "C-l",
        "<cmd> TmuxNavigateRight <cr>",
        desc = "Tmux Navigate Right",
      },
    },
  },
  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- {
  --   "mhartington/formatter.nvim",
  --   event = "VeryLazy",
  --   opts = function()
  --     return require "custom.configs.formatter"
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "VeryLazy",
  --   config = function()
  --     require "custom.configs.lint"
  --   end,
  -- },
  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  {
    "mg979/vim-visual-multi",
  },
  -- {
  --   "nvimdev/guard.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "nvimdev/guard-collection" },
  --   config = function()
  --     require("custom.configs.guard").setup {
  --       fmt_on_save = true,
  --       lsp_as_default_formatter = true,
  --     }
  --   end,
  -- },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      return require "custom.configs.rust-tools"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      crates.show()
    end,
  },
  {
    "mrcjkb/haskell-tools.nvim",
    ft = { "haskell", "cabal", "lhaskell", "cabalproject" },
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "terrastruct/d2-vim",
    ft = { "d2" },
    event = "VeryLazy",
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
}

return plugins
