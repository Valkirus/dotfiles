-- =============================================================================
-- Snippets Configuration
-- LuaSnip: already included by LazyVim, we just configure it here
-- friendly-snippets: VS Code snippet pack (React, TS, Python, Rust, etc.)
-- Custom: NestJS + Next.js snippets loaded from lua/snippets/
-- =============================================================================
return {
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = {
            -- Community snippet packs (includes React, TS, Python, Rust, HTML, etc.)
            "rafamadriz/friendly-snippets",
        },
        opts = function(_, opts)
            -- Load friendly-snippets (VS Code format packs)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Load our custom snippet files from lua/snippets/
            -- These are in LuaSnip's native Lua format (most powerful)
            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets",
            })

            -- Also load any VS Code-format snippet files from the snippets/ dir
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets/vscode",
            })

            opts.history = true
            opts.delete_check_events = "TextChanged"
            opts.region_check_events = "CursorMoved"

            return opts
        end,
        keys = {
            -- Jump forward through snippet placeholders with Tab
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            -- Jump backward through placeholders with Shift-Tab
            { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
            { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
            -- Expand or jump with Ctrl-k (alternative to Tab)
            {
                "<C-k>",
                function()
                    local ls = require("luasnip")
                    if ls.expand_or_jumpable() then ls.expand_or_jump() end
                end,
                mode = { "i", "s" },
                silent = true,
            },
            -- Cycle through choices in a snippet choice node
            {
                "<C-l>",
                function()
                    local ls = require("luasnip")
                    if ls.choice_active() then ls.change_choice(1) end
                end,
                mode = { "i", "s" },
            },
        },
    },
}
