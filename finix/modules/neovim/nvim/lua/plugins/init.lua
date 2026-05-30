return {

      {
          "stevearc/conform.nvim",
           -- event = 'BufWritePre', -- uncomment for format on save
          opts = require "configs.conform",
      },

  -- These are some examples, uncomment them if you want to see them work!
       {
         "neovim/nvim-lspconfig",
          config = function()
            require "configs.lspconfig"
         end,
       },

       {
          'vyfor/cord.nvim',
          build = ':Cord update',
          lazy = false,
  -- opts = {}
       },

      {
         'gelguy/wilder.nvim',
          lazy = false,
      },

      {
        "rmagatti/auto-session",
        lazy = false,
    
       ---enables autocomplete for opts
       ---@module "auto-session"
       ---@type AutoSession.Config
       opts = {
         suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
         -- log_level = 'debug',
       },
      },


  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

   {
   	"nvim-treesitter/nvim-treesitter",
   	opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
   		ensure_installed = {
   			"vim", "lua", "vimdoc",
        "html", "css", "bash", "nix",
   		},
   	},
   },
}

