-- =============================================================================
-- Neotest: IDE-tier test runner panel for all languages
-- Adapters: pytest (Python), jest/vitest (JS/TS), rust (Cargo), gtest (C++)
-- =============================================================================
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Adapters
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
            "rouge8/neotest-rust",
            "alfaix/neotest-gtest",
        },
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end,                                           desc = "Run Nearest Test" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,                         desc = "Run Test File" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                      desc = "Re-run Last Test" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                    desc = "Toggle Test Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end,    desc = "Show Test Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                               desc = "Toggle Output Panel" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                       desc = "Debug Nearest Test" },
            { "<leader>tq", function() require("neotest").run.stop() end,                                          desc = "Stop Test Run" },
        },
        opts = function()
            return {
                adapters = {
                    -- --------------------------------------------------------
                    -- Python: pytest
                    -- --------------------------------------------------------
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                        python = function()
                            if vim.fn.has("win32") == 1 then
                                if vim.fn.executable(".venv/Scripts/python.exe") == 1 then
                                    return vim.fn.getcwd() .. "/.venv/Scripts/python.exe"
                                end
                            else
                                if vim.fn.executable(".venv/bin/python") == 1 then
                                    return vim.fn.getcwd() .. "/.venv/bin/python"
                                end
                            end
                            return vim.fn.exepath("python3") or "python"
                        end,
                        args = { "--no-header", "-rN" },
                    }),

                    -- --------------------------------------------------------
                    -- JavaScript / TypeScript: Jest and Vitest
                    -- --------------------------------------------------------
                    require("neotest-jest")({
                        jestCommand = function()
                            -- Detect Vitest vs Jest based on package.json
                            if vim.fn.filereadable(vim.fn.getcwd() .. "/vitest.config.ts") == 1
                                or vim.fn.filereadable(vim.fn.getcwd() .. "/vitest.config.js") == 1 then
                                return "npx vitest run"
                            end
                            return "npx jest"
                        end,
                        jestConfigFile = function()
                            -- Find jest/vitest config relative to file being tested
                            local file = vim.fn.expand("%:p")
                            if string.find(file, "/packages/") then
                                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                            end
                            return vim.fn.getcwd() .. "/jest.config.ts"
                        end,
                        env = { CI = true },
                        cwd = function() return vim.fn.getcwd() end,
                    }),

                    -- --------------------------------------------------------
                    -- Rust: Cargo test
                    -- --------------------------------------------------------
                    require("neotest-rust")({
                        args = { "--no-capture" },
                        dap_adapter = "codelldb",
                    }),

                    -- --------------------------------------------------------
                    -- C++: Google Test (requires CTest or gtest_discover_tests)
                    -- --------------------------------------------------------
                    require("neotest-gtest").setup({}),
                },

                -- UI Configuration
                status = { virtual_text = true, signs = true },
                output = { open_on_run = true },
                quickfix = { open = false },
                icons = {
                    child_indent = "│",
                    child_prefix = "├",
                    collapsed = "─",
                    expanded = "╮",
                    failed = "✗",
                    final_child_indent = " ",
                    final_child_prefix = "╰",
                    non_collapsible = "─",
                    passed = "✓",
                    running = "◌",
                    running_animated = { "◐", "◓", "◑", "◒" },
                    skipped = "○",
                    unknown = "?",
                    watching = "👁",
                },
                summary = {
                    animated = true,
                    enabled = true,
                    expand_errors = true,
                    follow = true,
                    mappings = {
                        attach = "a",
                        clear_marked = "M",
                        clear_target = "T",
                        debug = "d",
                        debug_marked = "D",
                        expand = { "<CR>", "<2-LeftMouse>" },
                        expand_all = "e",
                        jumpto = "i",
                        mark = "m",
                        next_failed = "J",
                        only_shown = "f",
                        output = "o",
                        prev_failed = "K",
                        run = "r",
                        run_marked = "R",
                        short = "O",
                        stop = "u",
                        target = "t",
                        watch = "w",
                    },
                },
            }
        end,
    },
}
