-- =============================================================================
-- UI Enhancements: JetBrains-style layout + polished status line
-- edgy.nvim: Structured panel layout (left=tree, bottom=term/debug, right=outline)
-- lualine: Enhanced status with git, macro, LSP progress, overseer status
-- noice.nvim: Cleaner command line and notification system
-- =============================================================================
return {
    -- -------------------------------------------------------------------------
    -- Edgy: Window layout manager (JetBrains-style panels)
    -- -------------------------------------------------------------------------
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 3 -- Global status line
            vim.opt.splitkeep = "screen"
        end,
        keys = {
            { "<leader>ue", "<cmd>lua require('edgy').toggle()<cr>", desc = "Toggle Edgy Layout" },
        },
        opts = {
            -- Bottom panel: Terminal, Trouble
            bottom = {
                {
                    ft = "toggleterm",
                    size = { height = 0.3 },
                    filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
                },
                {
                    ft = "noice",
                    size = { height = 0.3 },
                    filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
                },
                { ft = "lazyterm",  title = "Terminal",  size = { height = 0.3 }, filter = function(buf) return not vim.b[buf].lazyterm_cmd end },
                {
                    ft = "trouble",
                    filter = function(_, win) return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics" end,
                    title = "Diagnostics",
                    size = { height = 0.3 },
                },
                {
                    ft = "qf",
                    title = "QuickFix",
                    size = { height = 0.3 },
                },
                {
                    ft = "OverseerList",
                    title = "Tasks",
                    size = { height = 0.3 },
                },
            },

            -- Left panel: File Explorer
            left = {
                {
                    title = "Explorer",
                    ft = "neo-tree",
                    filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
                    size = { height = 0.6 },
                },
            },

            -- Right panel: Code outline (Aerial)
            right = {
                {
                    title = "Code Outline",
                    ft = "aerial",
                    size = { width = 0.2 },
                },
            },

            -- Appearance
            animate = { enabled = true, fps = 60 },
            wo = {
                winbar = true,
                winfixwidth = true,
                winfixheight = false,
                winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
                spell = false,
                signcolumn = "no",
            },
        },
    },

    -- -------------------------------------------------------------------------
    -- Aerial: Code outline (shown in edgy's right panel)
    -- -------------------------------------------------------------------------
    {
        "stevearc/aerial.nvim",
        opts = {
            attach_mode = "global",
            backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
            show_guides = true,
            layout = {
                resize_to_content = false,
                win_opts = {
                    winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
                    signcolumn = "yes",
                    statuscolumn = " ",
                },
            },
            guides = {
                mid_item = "├╴",
                last_item = "└╴",
                nested_top = "│  ",
                whitespace = "   ",
            },
        },
        keys = {
            { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Code Outline (Aerial)" },
        },
    },

    -- -------------------------------------------------------------------------
    -- Lualine: Enhanced status bar
    -- -------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            -- Add macro recording indicator
            local function macro_recording()
                local reg = vim.fn.reg_recording()
                return reg ~= "" and ("⏺ @" .. reg) or ""
            end

            -- Add Overseer task status if available
            local function overseer_status()
                local ok, overseer = pcall(require, "overseer")
                if not ok then return "" end
                local tasks = overseer.task_list.list_tasks({ unique = true })
                local running = vim.tbl_filter(function(t) return t.status == "RUNNING" end, tasks)
                local failed = vim.tbl_filter(function(t) return t.status == "FAILURE" end, tasks)
                if #failed > 0 then return " " .. #failed .. " failed" end
                if #running > 0 then return " " .. #running .. " running" end
                return ""
            end

            opts.sections = opts.sections or {}
            opts.sections.lualine_x = opts.sections.lualine_x or {}

            -- Prepend our custom components
            table.insert(opts.sections.lualine_x, 1, { macro_recording, color = { fg = "#f38ba8" } })
            table.insert(opts.sections.lualine_x, 2, { overseer_status })

            return opts
        end,
    },

    -- -------------------------------------------------------------------------
    -- Noice: Better command line and notifications
    -- -------------------------------------------------------------------------
    {
        "folke/noice.nvim",
        opts = function(_, opts)
            opts.presets = vim.tbl_extend("force", opts.presets or {}, {
                bottom_search = false,      -- show search in a normal cmdline
                command_palette = true,     -- position the cmdline and popupmenu together
                long_message_to_split = true,
                inc_rename = true,          -- Enable inc-rename integration
                lsp_doc_border = true,
            })

            -- Add LSP progress to the mini section (bottom right, not noisy)
            opts.lsp = vim.tbl_extend("force", opts.lsp or {}, {
                progress = {
                    enabled = true,
                    format = "lsp_progress",
                    format_done = "lsp_progress_done",
                    throttle = 1000 / 30,
                    view = "mini",
                },
                hover = { enabled = true, silent = false },
                signature = { enabled = true, auto_open = { enabled = true } },
            })

            return opts
        end,
    },
}
