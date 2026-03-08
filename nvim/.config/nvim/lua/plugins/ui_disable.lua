return {
  -- "editor.inlayHints.enabled": "off"
  -- LazyVim enables inlay hints by default, we disable them here
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
  -- "editor.stickyScroll.enabled": false
  -- LazyVim uses Snacks for this or nvim 0.10 treesitter context
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false, -- Disables sticky scroll context lines
  },
}
