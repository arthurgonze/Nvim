return {
  'mrjones2014/smart-splits.nvim',
  keys = {
    { '<C-h>', mode = 'n', desc = 'Move focus to the left window' },
    { '<C-j>', mode = 'n', desc = 'Move focus to the lower window' },
    { '<C-k>', mode = 'n', desc = 'Move focus to the upper window' },
    { '<C-l>', mode = 'n', desc = 'Move focus to the right window' },
    { '<A-h>', mode = 'n', desc = 'Resize split left' },
    { '<A-j>', mode = 'n', desc = 'Resize split down' },
    { '<A-k>', mode = 'n', desc = 'Resize split up' },
    { '<A-l>', mode = 'n', desc = 'Resize split right' },
  },
  config = function()
    local ss = require 'smart-splits'

    -- Moving between splits
    vim.keymap.set('n', '<C-h>', ss.move_cursor_left, { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-j>', ss.move_cursor_down, { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', ss.move_cursor_up, { desc = 'Move focus to the upper window' })
    vim.keymap.set('n', '<C-l>', ss.move_cursor_right, { desc = 'Move focus to the right window' })

    -- Resizing splits
    vim.keymap.set('n', '<A-h>', ss.resize_left, { desc = 'Resize split left' })
    vim.keymap.set('n', '<A-j>', ss.resize_down, { desc = 'Resize split down' })
    vim.keymap.set('n', '<A-k>', ss.resize_up, { desc = 'Resize split up' })
    vim.keymap.set('n', '<A-l>', ss.resize_right, { desc = 'Resize split right' })
  end,
}
