-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })

-- Fix: Windows terminal emulators send BOTH <c-/> AND <c-_> for a single Ctrl+/ keypress.
-- LazyVim maps both separately, which causes Snacks to open TWO terminals at once.
-- We override both to use the exact same cached terminal object (_term) to prevent this.
local _term = nil
local function toggle_term()
  if _term and _term:buf_valid() then
    _term:toggle()
  else
    _term = Snacks.terminal(nil, { cwd = LazyVim.root() })
  end
end
vim.keymap.set({ "n", "t" }, "<c-/>", toggle_term, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", toggle_term, { desc = "which_key_ignore" })
