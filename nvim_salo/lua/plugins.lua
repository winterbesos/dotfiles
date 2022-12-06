-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "rcarriga/nvim-notify" -- notify
  use "kyazdani42/nvim-web-devicons" -- icons

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'arch -arm64 make'
  }
  use "nvim-telescope/telescope-ui-select.nvim"
  use "nvim-telescope/telescope-rg.nvim"
  use "MattesGroeger/vim-bookmarks"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  use "nvim-telescope/telescope-dap.nvim"


  -- Treesittetr
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
  } -- enhance texetobject selection
  use "romgrk/nvim-treesitter-context" -- show class/function at the top

  use {
    "kyazdani42/nvim-tree.lua",
  } -- file explore
  use "tpope/vim-rails"
  use "nvim-lualine/lualine.nvim" -- status line
  use {
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  } -- welcome page
  use "folke/todo-comments.nvim" -- todo comments

  -- UI
  -- Colorschemes
  use { "catppuccin/nvim", as = "catppuccin" }
  use "projekt0n/github-nvim-theme"

end)
