return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        -- c/cpp formats via clangd LSP by default
      },
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
      },
    },
  },
}
