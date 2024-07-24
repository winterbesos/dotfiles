-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "rcarriga/nvim-notify" -- notify

  -- Telescope
  use { "nvim-telescope/telescope.nvim" }
  use { "nvim-telescope/telescope-project.nvim" }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'arch -arm64 make'
  }
  use "nvim-telescope/telescope-ui-select.nvim"
  use "nvim-telescope/telescope-rg.nvim"

  use "MattesGroeger/vim-bookmarks"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  -- use "nvim-telescope/telescope-dap.nvim"
  use "mfussenegger/nvim-dap"
  use "nvim-neotest/nvim-nio"
  use {
    'rcarriga/nvim-dap-ui',
    requires = {{'mfussenegger/nvim-dap'}, {'nvim-neotest/nvim-nio'}}
  }


  -- Treesittetr
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "nvim-treesitter/nvim-treesitter-textobjects"  -- enhance texetobject selection
  use "romgrk/nvim-treesitter-context" -- show class/function at the top

  use "nvim-tree/nvim-tree.lua" -- file explore
  use "nvim-tree/nvim-web-devicons"

  use "nvim-lualine/lualine.nvim" -- status line
  use {
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  } -- welcome page
  use "folke/todo-comments.nvim" -- todo comments
  use "folke/which-key.nvim" -- which  key
  use 'echasnovski/mini.nvim'

  -- Git
  use "lewis6991/gitsigns.nvim"
  use 'sindrets/diffview.nvim'

  -- UI
  -- Colorschemes
  use { "catppuccin/nvim", as = "catppuccin" }
  use "projekt0n/github-nvim-theme"

  -- Terminal
  use "akinsho/toggleterm.nvim" -- toggle terminal

  -- LSP
  use "williamboman/mason-lspconfig.nvim" -- enable LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "kosayoda/nvim-lightbulb" -- code action
  use "ray-x/lsp_signature.nvim" -- show function signature when typing

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  -- use "jsfaint/gen_tags.vim"
  use "ray-x/cmp-treesitter"
  use "f3fora/cmp-spell" -- spell check
  use "ethanholz/nvim-lastplace" -- auto return back to the last modified positon when open a file
  use "nvim-pack/nvim-spectre" -- search and replace pane
  use "tpope/vim-repeat" --  . command enhance
  use "tpope/vim-surround" -- vim surround

  -- Language
  use "tpope/vim-rails"
  use "mattn/webapi-vim"
  use "winterbesos/vim-blue"

  use "github/copilot.vim"
  use "vim-test/vim-test"
end)
