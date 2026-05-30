require "nvchad.options"

require("nvchad.configs.lspconfig").defaults()

-- Relative number
vim.opt.relativenumber = true
vim.opt.number = true

-- Visual Block Ctrl+Q
vim.keymap.set('n', '<C-q>', '<C-v>')

-- Wilder
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    highlights = {
      border = 'Normal', -- highlight to use for the border
    },
    -- 'single', 'double', 'rounded' or 'solid'
    -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
    border = 'rounded',
  })
))
-- Wilder

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Escape key to Ctrl \ + Ctrl N
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

-- Use zsh for terminal
vim.opt.shell = '/run/current-system/sw/bin/zsh'

-- Will use system clipboard
vim.opt.clipboard = "unnamedplus"
-- These two lines will fix space issues when pasting
vim.opt.autoindent = false

local servers = { "html", "cssls", "nixd", "nil_ls" }
vim.lsp.enable(servers)

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 17,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- https://nvchad.com/docs/recipes/ 
-- This will make nvim remeber last cursor position
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- Show Nvdash when all buffers are closed
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})
-- read :h vim.lsp.config for changing options of lsp servers 


-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
