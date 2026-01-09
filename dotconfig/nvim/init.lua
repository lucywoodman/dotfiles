-- Minimal Neovim config
-- =====================================================

-- Leader key (set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- Core Settings
-- =============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Cursor
opt.cursorline = true
opt.guicursor = "n-v:block,i-c-ci:ver25" -- cursor shapes: block normal, bar insert

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Soft wrap
opt.wrap = true
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- File handling
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false  -- lualine shows mode

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Final newline
opt.fixendofline = true

-- Hidden files in netrw
vim.g.netrw_list_hide = ""

-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

-- =============================================================================
-- Keymaps
-- =============================================================================

local keymap = vim.keymap.set

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })
