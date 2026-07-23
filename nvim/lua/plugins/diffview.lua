return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("conf.diffview")
  end,
}
