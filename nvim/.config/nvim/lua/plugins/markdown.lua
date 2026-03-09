return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      {
        "<leader>mp",
        mode = "n",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[
        " Do not close the preview tab when switching to other buffers
        let g:mkdp_auto_close = 0
        
        " Sync the scrolling in the browser with your cursor in Neovim
        let g:mkdp_echo_preview_url = 1
        
        " Thai font support is handled natively by your web browser,
        " but we can ensure standard rendering features are enabled.
      ]])
    end,
  },
}
