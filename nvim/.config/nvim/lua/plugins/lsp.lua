return {
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "vtsls",
                "eslint-lsp",
                "prettier",
                "clangd",
                "pyright",
                "ruff",
                "codelldb", -- used for debugging C++ and Rust
                "dockerfile-language-server",
                "docker-compose-language-service",
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                vtsls = {},
                eslint = {},
                pyright = {},
                ruff = {},
                dockerls = {},
                docker_compose_language_service = {},
                clangd = {
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                        "--offset-encoding=utf-16", -- Crucial for null-ls/copilot compatibility
                    },
                },
            },
        },
    },
}
