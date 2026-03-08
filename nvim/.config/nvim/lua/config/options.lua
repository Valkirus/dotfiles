-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- VS Code specific editor preferences
opt.tabstop = 4 -- "editor.tabSize": 4
opt.shiftwidth = 4
opt.expandtab = true

opt.number = true
opt.relativenumber = true -- "editor.lineNumbers": "relative"

opt.wrap = true
opt.linebreak = true

-- Simulate "files.autoSave": "afterDelay"
-- Neovim triggers CursorHold and CursorHoldI events which we can bind to write
opt.updatetime = 1000 -- Matches standard VSCode delay before save (in ms)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

opt.guifont = "JetBrainsMono Nerd Font,Dank Mono:h16" -- "editor.fontFamily", "editor.fontSize"

-- Disable UI Clutter to match VS Code config
opt.list = false -- "editor.renderWhitespace": "none"
opt.cursorline = false -- "editor.renderLineHighlight": "none"
opt.colorcolumn = ""

-- OSC 52 Clipboard syncing for dev containers / SSH
-- This works natively in Neovim 0.10+
opt.clipboard = "unnamedplus" -- use system clipboard
if vim.env.SSH_TTY or vim.env.WSL_DISTRO_NAME or vim.env.REMOTE_CONTAINERS then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
