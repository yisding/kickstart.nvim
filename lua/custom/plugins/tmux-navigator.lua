-- Seamless navigation between Neovim splits and tmux panes.
--
-- Pairs with the vim-tmux-navigator tmux plugin (see ~/.config/tmux/tmux.conf):
-- pressing <C-h/j/k/l> moves between Neovim windows, and transparently crosses
-- into adjacent tmux panes when there's no split in that direction.

-- Set before the plugin is sourced so it doesn't install its own <C-hjkl> maps;
-- we define them below (with descriptions) so they override kickstart's
-- <C-w>-based window keymaps in init.lua.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }

vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Navigate left (window/tmux pane)' })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Navigate down (window/tmux pane)' })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Navigate up (window/tmux pane)' })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Navigate right (window/tmux pane)' })
