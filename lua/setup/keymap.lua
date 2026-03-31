vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disables <Space> as a normal/visual key, so it only works as leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap jk to esc
-- vim.keymap.set({ 'n', 'v', 'i' }, 'jk', '<Esc>')
-- vim.keymap.set('t', 'jk', '<C-\\><C-n>')

-- Quickly remove search highlight with <leader><space> (now <Space><Space>)
vim.keymap.set('n', '<space><space>', ':noh<cr>', { desc = 'Remove search highlight' })

-- Makes 'j'/'k' move by visual lines when no count is given
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move cursor right/left in insert mode with Ctrl+l/h.
vim.keymap.set('i', '<c-l>', '<Right>', { desc = 'Move to right on insert mode' })
vim.keymap.set('i', '<c-h>', '<Left>', { desc = 'Move to left on insert mode' })
vim.keymap.set('i', '<c-j>', '<Down>', { desc = 'Move to down on insert mode' })
vim.keymap.set('i', '<c-k>', '<Up>', { desc = 'Move to Up on insert mode' })

-- Move selected lines up/down in visual mode with J/K.
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Scroll half-page down/up and center cursor.
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Next/previous search result and center cursor.
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Paste over selection without overwriting the default register.
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Delete to black hole register (doesn't overwrite yank buffer).
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- In insert mode, Ctrl+c acts as <Esc>.
vim.keymap.set('i', '<C-c>', '<Esc>')

-- Format file or selection using LSP with <leader>f.
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('v', '<leader>f', vim.lsp.buf.format)

-- Replace word under cursor throughout file.
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Open terminal in vertical split.
vim.keymap.set('n', '<leader>tn', ':vs term://bash<CR>')
