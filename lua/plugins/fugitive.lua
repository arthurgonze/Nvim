return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G' },
  keys = {
    { '<leader>gs', '<cmd>Git<CR>', desc = '[G]it [S]tatus' },
    { '<leader>gd', '<cmd>Gdiffsplit<CR>', desc = '[G]it [D]iff' },
    { '<leader>gb', '<cmd>Git blame<CR>', desc = '[G]it [B]lame' },
    { '<leader>gl', '<cmd>Git log<CR>', desc = '[G]it [L]og' },
    { '<leader>gp', '<cmd>Git push<CR>', desc = '[G]it [P]ush' },
  },
}
