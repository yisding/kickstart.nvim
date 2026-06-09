-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Configures the debuggers for TypeScript/JavaScript, Python, and Go out of
-- the box, and can be extended to other languages as well. That's why it's
-- called kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  -- A single-window UI for nvim-dap: scopes, breakpoints, watches, and the
  -- REPL live in one window with a winbar to switch between them. (The older
  -- multi-window alternative is rcarriga/nvim-dap-ui.)
  'https://github.com/igorlfs/nvim-dap-view',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/mfussenegger/nvim-dap-python',
  'https://github.com/leoluz/nvim-dap-go',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', function() require('dap-view').toggle() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {
    function(config) require('mason-nvim-dap').default_setup(config) end,
    -- Don't auto-configure these two; they get tailored setups below
    python = function() end, -- configured by nvim-dap-python
    js = function() end, -- configured by hand, see the pwa-node adapter below
  },

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'delve', -- Go
    'python', -- installs debugpy
    'js', -- installs js-debug-adapter (VS Code's javascript debugger)
  },
}

-- Dap view setup
-- From inside the dap-view window, press `g?` to list its keymaps.
-- For more information, see |:help dap-view.txt|
require('dap-view').setup {
  -- Open the debugging view when a session starts, close it when it ends
  auto_toggle = true,
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

-- Install python specific config
-- nvim-dap-python registers launch/attach configurations, finds your
-- project's virtualenv, and can debug a single test with
-- `require('dap-python').test_method()`. The argument is the python that
-- *hosts* debugpy - here, the one Mason installed alongside it.
local debugpy = vim.fn.expand '$MASON/packages/debugpy/venv'
require('dap-python').setup(vim.fn.has 'win32' == 1 and debugpy .. '/Scripts/pythonw.exe' or debugpy .. '/bin/python')

-- Install TypeScript/JavaScript specific config
-- The adapter is VS Code's debugger (vscode-js-debug), which Mason installs
-- as `js-debug-adapter`. It must be registered under the name `pwa-node`,
-- and `host`/`port` must be set exactly like this, or it silently fails.
dap.adapters['pwa-node'] = {
  type = 'server',
  host = '127.0.0.1',
  port = '${port}',
  executable = { command = 'js-debug-adapter', args = { '${port}' } },
}
local js_attach = {
  type = 'pwa-node',
  request = 'attach',
  name = 'Attach to running process (node --inspect)',
  processId = require('dap.utils').pick_process,
  cwd = '${workspaceFolder}',
}
dap.configurations.javascript = {
  { type = 'pwa-node', request = 'launch', name = 'Launch current file', program = '${file}', cwd = '${workspaceFolder}' },
  js_attach,
}
dap.configurations.typescript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch current file (tsx)',
    program = '${file}',
    cwd = '${workspaceFolder}',
    -- Node can't run .ts files by itself; tsx does the on-the-fly compiling.
    -- Add it to your project with `npm install -D tsx` (the debugger finds it
    -- in node_modules/.bin). For ts-node projects, replace 'tsx' below.
    runtimeExecutable = 'tsx',
  },
  js_attach,
}

-- Install golang specific config
require('dap-go').setup {
  delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    detached = vim.fn.has 'win32' == 0,
  },
}
