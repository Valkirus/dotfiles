-- =============================================================================
-- Refactoring & Intelligent Navigation
-- inc-rename: Live, preview-as-you-type variable renaming (like VS Code F2)
-- refactoring.nvim: Extract function/variable, inline code (like IntelliJ)
-- fzf-lua: Enhanced telescope alternative with hidden file search
-- =============================================================================
return {
    -- -------------------------------------------------------------------------
    -- inc-rename: Visual live-updating rename (replaces default LSP rename)
    -- -------------------------------------------------------------------------
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        -- NOTE: Do NOT set input_buffer_type = "dressing" — it conflicts with noice.nvim
        -- and causes <Enter> to be swallowed (preview shows but rename never commits)
        opts = {},
        keys = {
            {
                "<leader>rr",
                function()
                    -- Populate the command line with the current word so the user
                    -- can edit the name inline. noice handles the display.
                    return ":" .. "IncRename " .. vim.fn.expand("<cword>")
                end,
                expr = true,
                desc = "Rename (inc-rename)",
            },
        },
    },

    -- -------------------------------------------------------------------------
    -- refactoring.nvim: Extract functions, variables, inline code
    -- -------------------------------------------------------------------------
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = true,
        keys = {
            -- Visual mode: Extract highlighted code to function
            {
                "<leader>re",
                function() require("refactoring").refactor("Extract Function") end,
                mode = "v",
                desc = "Extract Function",
            },
            {
                "<leader>rE",
                function() require("refactoring").refactor("Extract Function To File") end,
                mode = "v",
                desc = "Extract Function to File",
            },
            -- Visual mode: Extract to variable
            {
                "<leader>rv",
                function() require("refactoring").refactor("Extract Variable") end,
                mode = "v",
                desc = "Extract Variable",
            },
            -- Normal mode: Inline variable (remove unnecessary variable)
            {
                "<leader>ri",
                function() require("refactoring").refactor("Inline Variable") end,
                mode = { "n", "v" },
                desc = "Inline Variable",
            },
            -- Extract block of code (normal mode)
            {
                "<leader>rb",
                function() require("refactoring").refactor("Extract Block") end,
                mode = "n",
                desc = "Extract Block",
            },
            {
                "<leader>rB",
                function() require("refactoring").refactor("Extract Block To File") end,
                mode = "n",
                desc = "Extract Block to File",
            },
            -- Debug print helpers (very useful for fast debugging)
            {
                "<leader>rp",
                function() require("refactoring").debug.print_var({ below = false }) end,
                mode = { "n", "v" },
                desc = "Debug Print Variable",
            },
            {
                "<leader>rP",
                function() require("refactoring").debug.printf({ below = false }) end,
                mode = "n",
                desc = "Debug Printf",
            },
            {
                "<leader>rc",
                function() require("refactoring").debug.cleanup({}) end,
                mode = "n",
                desc = "Cleanup Debug Prints",
            },
        },
        opts = {
            prompt_func_return_type = {
                go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false,
            },
            prompt_func_param_type = {
                go = false, java = false, cpp = false, c = false, h = false, hpp = false, cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = true,
        },
    },

    -- -------------------------------------------------------------------------
    -- fzf-lua: Telescope alternative configured to search hidden files
    -- (while still respecting .gitignore)
    -- -------------------------------------------------------------------------
    {
        "ibhagwan/fzf-lua",
        optional = true,
        opts = {
            files = {
                -- Search hidden files but respect .gitignore
                fd_opts = "--color=never --type f --hidden --follow --exclude .git",
                rg_opts = "--color=never --files --hidden --follow --glob '!.git'",
            },
            grep = {
                -- Ripgrep: search hidden files but exclude .git
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden -g '!.git'",
            },
            lsp = {
                -- Workspace-wide symbol search
                symbols = {
                    symbol_style = 1, -- Show kind icon + name
                    symbol_icons = nil, -- Use LazyVim default icons
                },
                code_actions = { previewer = "codeaction_native" },
            },
        },
    },

    -- Also configure telescope if it is used instead of fzf-lua
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function(_, opts)
            local telescopeConfig = require("telescope.config")
            local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
            -- Search hidden files but exclude .git
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")

            opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
                vimgrep_arguments = vimgrep_arguments,
            })
            opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
                find_files = {
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
            })
            return opts
        end,
    },
}
