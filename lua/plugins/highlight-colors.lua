return {
  'brenoprata10/nvim-highlight-colors',
  event = 'BufReadPre',
  opts = {
    render = 'background', -- or 'foreground' or 'first_column'
    enable_named_colors = true,
    enable_tailwind = false, -- set true if you ever use Tailwind
  },
}
