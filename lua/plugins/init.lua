-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load "nvim-colorizer.lua"
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "Exafunction/codeium.nvim",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "xiyaowong/telescope-emoji.nvim",
    },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
    init = function() end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  }, -- Remove the `use` here if you're using folke/lazy.nvim.
  -- AI garbage
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    cmd = "Codeium",
    config = function()
      require("codeium").setup {}
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    cmd = "Neogit",
    config = true,
  },
  {
    "nvim-treesitter/nvim-tree-docs",
    config = true,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "1.2.2",
    config = function()
      require("git-conflict").setup {}

      vim.api.nvim_create_autocommand("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
          vim.keymap.set("n", "cww", function()
            engage.conflict_buster()
            create_buffer_local_mappings()
          end)
        end,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = {
          icon = " ",
          color = "warning",
          alt = { "FUCK", "SHIT", "BAD" },
        },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
    },
    cmd = { "TodoTelescope", "TodoTrouble", "TodoQuickFix", "TodoLocList" },
  },
  {
    "m-demare/hlargs.nvim",
    opts = { color = "#ffb86c" },
    event = { "BufReadPost" },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>cr",
        function()
          require("ssr").open()
        end,
        mode = { "n", "v" },
        desc = "Advanced Replace",
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>gl",
        "<cmd>LazyGit<cr>",
        desc = "Open LazyGit",
      },
      {
        "<leader>gf",
        "<cmd>LazyGitFilter<cr>",
        desc = "Open LazyGitFilter",
      },
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      {
        "<leader>gg",
        "<cmd>Git<cr>",
        desc = "Open Git fugitive",
      },
      {
        "<leader>gs",
        "<cmd>Gvdiffsplit!<cr>",
        desc = "Open Conflict Split",
      },
    },
  },
  {
    "ryanoasis/vim-devicons",
    config = true,
  },
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "folke/twilight.nvim",
    config = true,
  },
  {
    "piersolenski/telescope-import.nvim",
    requires = "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").load_extension "import"
    end,
    keys = {
      {
        "<leader>im",
        "<cmd>Telescope import<cr>",
        desc = "Import",
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  }
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
