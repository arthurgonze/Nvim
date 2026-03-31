return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      signature = {
        enabled = false,
      },
    },
    presets = {
      -- bottom_search = true, -- classic search bar at bottom
      -- command_palette = true, -- command line + popupmenu together
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    routes = {
      -- suppress annoying "written" message on save
      {
        filter = { event = 'msg_show', kind = '', find = 'written' },
        opts = { skip = true },
      },
    },
  },
}
