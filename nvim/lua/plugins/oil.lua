return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- not lazy: oil works best as the netrw replacement / default dir handler
  lazy = false,
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-h>"] = false, -- keep TmuxNavigateLeft
        ["<C-l>"] = false, -- keep TmuxNavigateRight
      },
    })
    -- `-` opens the parent dir as an editable buffer (oil's signature flow).
    -- <leader>e stays on NvimTree (sidebar); the two coexist.
    vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })
  end,
}
