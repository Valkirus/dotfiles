-- force 4 spaces tab dynamically across all files to override any `ftplugin` defaults (which often force 2 spaces for JSON/Lua)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})
