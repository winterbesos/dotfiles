return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
      -- formatters (conform.nvim) + linters (nvim-lint)
      ensure_installed = {
        "stylua",        -- lua formatter
        "goimports",     -- go imports/formatter
        "gofumpt",       -- go stricter formatter
        "golangci-lint", -- go linter (replaces null-ls golangci_lint diagnostics)
        "prettierd",     -- js/ts/vue/css/html/json/yaml/md formatter
      },
      run_on_start = true,
    })
  end,
}
