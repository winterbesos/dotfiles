return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      -- replaces null_ls.builtins.diagnostics.golangci_lint
      go = { "golangcilint" },
    }

    local grp = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = grp,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
