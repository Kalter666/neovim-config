---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["C-h"] = { "<cmd> TmuxNavigateLeft<cr>", "navigate left" },
    ["C-l"] = { "<cmd> TmuxNavigateRight<cr>", "navigate right" },
    ["C-k"] = { "<cmd> TmuxNavigateUp<cr>", "navigate up" },
    ["C-j"] = { "<cmd> TmuxNavigateDown<cr>", "navigate down" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

M.dap = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint<CR>",
      "Toggle breakpoint",
    },
    ["<leader>dus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debug sidebar",
    },
  },
}

return M
