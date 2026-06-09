-- neotest.lua
--
-- Run tests from inside Neovim: nearest test, whole file, or the project,
-- with pass/fail signs next to each test and a summary tree.
--
-- Tests are discovered and run by language-specific adapters. Kickstart sets
-- up pytest/unittest for Python and vitest for JS/TS; there are adapters for
-- most other runners too: https://github.com/nvim-neotest/neotest#supported-runners

vim.pack.add {
  -- neotest dependencies
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-neotest/neotest',
  -- adapters
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/marilari88/neotest-vitest',
}

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-python' {
      -- When debugging a test, also stop at breakpoints in the code under
      -- test, not just in the test itself
      dap = { justMyCode = false },
    },
    require 'neotest-vitest',
    -- Using jest instead? https://github.com/nvim-neotest/neotest-jest
  },
}

vim.keymap.set('n', '<leader>Tt', function() neotest.run.run() end, { desc = '[T]est: run nearest [t]est' })
vim.keymap.set('n', '<leader>Tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est: run current [f]ile' })
vim.keymap.set('n', '<leader>Ts', function() neotest.summary.toggle() end, { desc = '[T]est: toggle [s]ummary tree' })
vim.keymap.set('n', '<leader>To', function() neotest.output.open { enter = true, auto_close = true } end, { desc = '[T]est: show [o]utput' })
-- Debug the nearest test with DAP - requires `kickstart.plugins.debug`
vim.keymap.set('n', '<leader>Td', function() neotest.run.run { strategy = 'dap' } end, { desc = '[T]est: [d]ebug nearest test' })
