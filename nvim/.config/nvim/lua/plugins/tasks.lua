-- =============================================================================
-- Tasks & Project Management
-- Overseer: Build/run tasks from tasks.json or custom templates
-- Persistence: Auto-save and restore sessions per project directory
-- =============================================================================
return {
    -- -------------------------------------------------------------------------
    -- Overseer: VS Code tasks.json-compatible task runner
    -- -------------------------------------------------------------------------
    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerRun",
            "OverseerToggle",
            "OverseerBuild",
            "OverseerRestartLast",
            "OverseerLoadBundle",
            "OverseerSaveBundle",
            "OverseerOpen",
            "OverseerClose",
            "OverseerQuickAction",
            "OverseerTaskAction",
            "OverseerClearCache",
        },
        keys = {
            { "<leader>ot", "<cmd>OverseerToggle<cr>",      desc = "Task Panel" },
            { "<leader>or", "<cmd>OverseerRun<cr>",         desc = "Run Task" },
            { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "Build Task" },
            { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Re-run Last Task" },
            { "<leader>oa", "<cmd>OverseerTaskAction<cr>",  desc = "Task Action" },
            { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
        },
        opts = {
            -- Read VS Code tasks.json automatically
            templates = { "builtin", "vscode" },

            -- Task panel appearance (bottom panel, like VS Code's terminal)
            task_list = {
                direction = "bottom",
                min_height = 12,
                max_height = 25,
                default_detail = 1,
                bindings = {
                    ["?"] = "ShowHelp",
                    ["g?"] = "ShowHelp",
                    ["<CR>"] = "RunAction",
                    ["<C-e>"] = "Edit",
                    ["o"] = "Open",
                    ["<C-v>"] = "OpenVsplit",
                    ["<C-s>"] = "OpenSplit",
                    ["<C-f>"] = "OpenFloat",
                    ["<C-q>"] = "OpenQuickFix",
                    ["p"] = "TogglePreview",
                    ["<C-l>"] = "IncreaseDetail",
                    ["<C-h>"] = "DecreaseDetail",
                    ["L"] = "IncreaseAllDetail",
                    ["H"] = "DecreaseAllDetail",
                    ["["] = "DecreaseWidth",
                    ["]"] = "IncreaseWidth",
                    ["{"] = "PrevTask",
                    ["}"] = "NextTask",
                    ["<C-k>"] = "ScrollOutputUp",
                    ["<C-j>"] = "ScrollOutputDown",
                    ["q"] = "Close",
                },
            },

            -- Confirm before running potentially destructive tasks
            confirm = {},

            -- Show task status in lualine (StatusLine integration)
            component_aliases = {
                default = {
                    { "display_duration", detail_level = 2 },
                    "on_output_summarize",
                    "on_exit_set_status",
                    "on_complete_notify",
                    "on_complete_dispose",
                },
                default_vscode = {
                    "default",
                    "on_result_diagnostics",
                    "on_result_diagnostics_quickfix",
                },
            },
        },
    },

    -- -------------------------------------------------------------------------
    -- Auto-session: Auto-save & restore projects (LazyVim extra enhancer)
    -- Reopens buffers, terminals, and layout when you open a project directory
    -- -------------------------------------------------------------------------
    {
        "folke/persistence.nvim",
        opts = {
            -- Auto restore session only if nvim was started with a directory
            options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
        },
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Session" },
        },
    },
}
