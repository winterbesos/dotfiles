require("github-theme").setup({
  colorscheme = "dark",
  options = {
    styles = {
      function_style = "italic",
    },
    darken = {
      sidebars = {
        list = {"qf", "vista_kind", "terminal", "packer"},
      }
    }
  },

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  specs = {hint = "orange", error = "#ff0000"},

  groups = {
    github_dark = {
      Error = { fg = '#FF0000' },
    },
    all = {
      ErrorMsg = { link = 'Error' },
    },
  },


  -- Overwrite the highlight groups
  -- overrides = function(c)
  --   return {
  --     htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
  --     DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
  --     -- this will remove the highlight groups
  --     TSField = {},
  --   }
  -- end
})
