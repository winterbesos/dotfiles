return { 
  "mfussenegger/nvim-dap", 
  tag = "0.10.0",
  dependencies = {
    "suketa/nvim-dap-ruby"
  },
  config = function()
    require("dap-ruby").setup()
  end
}
