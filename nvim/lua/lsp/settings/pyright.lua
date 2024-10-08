return {
  settings = {
    python = {
      pythonPath = "python",
      analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          extraPaths = { vim.fn.getcwd() .. "/libs" },
          autoSearchPaths = true,
          typeCheckingMode = "basic",
      },
    },
  }
}
