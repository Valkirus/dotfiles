-- =============================================================================
-- DAP: Debug Adapter Protocol — VS Code-style debugging for all languages
-- Adapters: codelldb (C++/Rust), debugpy (Python), js-debug-adapter (Node/React)
-- =============================================================================
return {
    -- Core DAP engine
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "mfussenegger/nvim-dap-python",
            "jay-babu/mason-nvim-dap.nvim",
        },
        keys = {
            -- VS Code-style F-key bindings
            { "<F5>",  function() require("dap").continue() end,          desc = "Debug: Continue" },
            { "<F10>", function() require("dap").step_over() end,         desc = "Debug: Step Over" },
            { "<F11>", function() require("dap").step_into() end,         desc = "Debug: Step Into" },
            { "<F12>", function() require("dap").step_out() end,          desc = "Debug: Step Out" },
            -- Breakpoints
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                                               desc = "Toggle Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,            desc = "Conditional Breakpoint" },
            { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,    desc = "Log Point" },
            -- DAP UI
            { "<leader>du", function() require("dapui").toggle() end,     desc = "Toggle DAP UI" },
            { "<leader>de", function() require("dapui").eval() end,       desc = "Eval Expression", mode = { "n", "v" } },
            -- Session management
            { "<leader>dr", function() require("dap").run_last() end,     desc = "Re-run Last" },
            { "<leader>dq", function() require("dap").terminate() end,    desc = "Terminate Session" },
            { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Auto-open/close DAP UI when debugging starts/ends
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            -- ---------------------------------------------------------------
            -- Helper: safely get Mason package install path
            -- ---------------------------------------------------------------
            local function get_mason_path(pkg_name, suffix)
                local ok, registry = pcall(require, "mason-registry")
                if not ok then return nil end
                local pkg_ok, pkg = pcall(function() return registry.get_package(pkg_name) end)
                if not pkg_ok or not pkg then
                    vim.notify("[DAP] Mason package '" .. pkg_name .. "' not found. Run :MasonInstall " .. pkg_name, vim.log.levels.WARN)
                    return nil
                end
                return pkg:get_install_path() .. (suffix or "")
            end

            -- ---------------------------------------------------------------
            -- C++ / Rust: codelldb (installed via Mason)
            -- ---------------------------------------------------------------
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = function()
                        local ext = vim.fn.has("win32") == 1 and ".exe" or ""
                        return get_mason_path("codelldb", "/extension/adapter/codelldb" .. ext)
                    end,
                    args = { "--port", "${port}" },
                },
            }

            for _, lang in ipairs({ "c", "cpp", "rust" }) do
                dap.configurations[lang] = {
                    {
                        name = "Launch executable",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                        args = {},
                    },
                    {
                        name = "Attach to PID",
                        type = "codelldb",
                        request = "attach",
                        pid = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            -- ---------------------------------------------------------------
            -- Python: debugpy (installed via Mason)
            -- ---------------------------------------------------------------
            -- Use the project virtualenv for debugpy if it exists
            local function get_python()
                if vim.fn.has("win32") == 1 then
                    if vim.fn.executable(".venv/Scripts/python.exe") == 1 then
                        return vim.fn.getcwd() .. "/.venv/Scripts/python.exe"
                    end
                else
                    if vim.fn.executable(".venv/bin/python") == 1 then
                        return vim.fn.getcwd() .. "/.venv/bin/python"
                    end
                end
                return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end

            require("dap-python").setup(get_python())

            -- ---------------------------------------------------------------
            -- Node.js / React: js-debug-adapter (installed via Mason)
            -- Path is resolved lazily when a debug session actually starts
            -- ---------------------------------------------------------------
            for _, adapter_type in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
                dap.adapters[adapter_type] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        args = function()
                            local path = get_mason_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js")
                            return path and { path, "${port}" } or {}
                        end,
                    },
                }
            end

            for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
                dap.configurations[lang] = {
                    {
                        name = "Launch Node.js File",
                        type = "pwa-node",
                        request = "launch",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                        protocol = "inspector",
                        console = "integratedTerminal",
                    },
                    {
                        name = "Attach to Node.js Process",
                        type = "pwa-node",
                        request = "attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                        sourceMaps = true,
                    },
                    {
                        name = "Debug Jest Tests",
                        type = "pwa-node",
                        request = "launch",
                        runtimeExecutable = "node",
                        runtimeArgs = {
                            "./node_modules/jest/bin/jest.js",
                            "--runInBand",
                        },
                        rootPath = "${workspaceFolder}",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                    },
                    {
                        name = "Launch Chrome (React)",
                        type = "pwa-chrome",
                        request = "launch",
                        url = "http://localhost:3000",
                        webRoot = "${workspaceFolder}/src",
                        sourceMaps = true,
                    },
                }
            end

            -- Also apply to NestJS
            dap.configurations["typescript"] = dap.configurations["typescript"] or {}
            table.insert(dap.configurations["typescript"], {
                name = "Launch NestJS",
                type = "pwa-node",
                request = "launch",
                runtimeExecutable = "node",
                runtimeArgs = { "--require", "ts-node/register" },
                args = { "${workspaceFolder}/src/main.ts" },
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                console = "integratedTerminal",
            })
        end,
    },

    -- DAP UI: Side panels, watches, callstack, etc.
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        opts = {
            icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
            layouts = {
                {
                    elements = {
                        { id = "scopes",     size = 0.4 },
                        { id = "breakpoints", size = 0.2 },
                        { id = "stacks",     size = 0.2 },
                        { id = "watches",    size = 0.2 },
                    },
                    size = 40,
                    position = "left",
                },
                {
                    elements = {
                        { id = "repl",    size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
                    size = 12,
                    position = "bottom",
                },
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "rounded",
                mappings = { close = { "q", "<Esc>" } },
            },
        },
    },

    -- Virtual text showing variable values inline while debugging
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
            commented = true,
            only_first_definition = false,
            all_references = true,
        },
    },

    -- Python-specific DAP integration
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = "python",
    },

    -- Mason integration to auto-install debug adapters
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
        opts = {
            ensure_installed = { "codelldb", "debugpy", "js-debug-adapter" },
            automatic_installation = true,
            handlers = {}, -- Let each adapter configure itself in the dap config above
        },
    },
}
