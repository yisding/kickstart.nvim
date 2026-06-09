-- overseer.lua
--
-- Task runner: discovers the tasks your project already defines and runs
-- them in the background, with a panel to watch their output.
--
-- Tasks are found by "template providers". The built-in ones cover
-- package.json scripts (npm/yarn/pnpm/bun), Makefiles, just, mix, rake,
-- VS Code tasks.json, and more. You can also define your own for tools like
-- `uv run`: see https://github.com/stevearc/overseer.nvim/blob/master/doc/guides.md

vim.pack.add { 'https://github.com/stevearc/overseer.nvim' }

require('overseer').setup {}

vim.keymap.set('n', '<leader>or', '<Cmd>OverseerRun<CR>', { desc = '[O]verseer: pick and [r]un a task' })
vim.keymap.set('n', '<leader>oo', '<Cmd>OverseerToggle<CR>', { desc = '[O]verseer: toggle the task list' })
