return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.3", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "honza/vim-snippets"
  },
  config = function()
    require("luasnip.loaders.from_snipmate").lazy_load({
      paths = { vim.fn.stdpath("data") .. "/lazy/vim-snippets" },
    })
  end
}
