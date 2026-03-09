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
                "basedpyright",
                "ruff",
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
                pyright = {
                    -- We must explicitly disable pyright since the lazyvim python extra enables it by default
                    mason = false,
                    autostart = false,
                },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = "basic",  -- Much better defaults than Pyright
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                extraPaths = { "." },
                            },
                        },
                        python = {
                            venvPath = ".",
                            pythonPath = vim.fn.has("win32") == 1 and ".venv/Scripts/python.exe" or ".venv/bin/python",
                        },
                    },
                },
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
