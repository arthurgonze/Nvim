return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<C-\\>', desc = 'Toggle terminal' },
    { '<leader>tf', desc = 'Toggle floating terminal' },
    { '<leader>th', desc = 'Toggle horizontal terminal' },
  },
  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    shade_terminals = true,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    local Terminal = require('toggleterm.terminal').Terminal

    -- Floating terminal shortcut
    local float_term = Terminal:new { direction = 'float' }
    vim.keymap.set('n', '<leader>tf', function()
      float_term:toggle()
    end, { desc = '[T]oggle [F]loating terminal' })

    -- Horizontal terminal shortcut
    local h_term = Terminal:new { direction = 'horizontal' }
    vim.keymap.set('n', '<leader>th', function()
      h_term:toggle()
    end, { desc = '[T]oggle [H]orizontal terminal' })
  end,
}
