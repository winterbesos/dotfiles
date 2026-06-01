return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    local prettier_ft = {
      "javascript", "javascriptreact", "typescript", "typescriptreact",
      "vue", "css", "scss", "less", "html", "json", "jsonc",
      "yaml", "markdown", "graphql",
    }

    local formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofumpt" },
    }
    for _, ft in ipairs(prettier_ft) do
      formatters_by_ft[ft] = { "prettierd" }
    end

    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
      -- format-on-save is intentionally NOT enabled globally:
      -- vue (vue_ls) and dart (dartls) already wire their own BufWritePre.
      -- Use :Format / :FormatSync / <leader>f for everything else.
    })
  end,
}
