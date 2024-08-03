return {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu", "--suggest-missing-includes", "--pch-storage=memory", "--cross-file-rename", "--clang-tidy", "--header-insertion=iwyu", "--suggest-missing-includes", "--pch-storage=memory", "--cross-file-rename" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".clangd", "compile_flags.txt", ".git"),
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  settings = {
    ccls = {
      completion = {
        filterAndSort = false,
      },
    },
  },
}
