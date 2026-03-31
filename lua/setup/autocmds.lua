-- Attach LSP
local lsp_attach_group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_attach_group,
  callback = function(event)
    local function map(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Key mappings table: {keys, function, description, [mode]}
    local mappings = {
      { 'grn', vim.lsp.buf.rename, '[R]e[n]ame' },
      { 'gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' } },
      {
        'grr',
        function()
          require('telescope.builtin').lsp_references()
        end,
        '[G]oto [R]eferences',
      },
      {
        'gri',
        function()
          require('telescope.builtin').lsp_implementations()
        end,
        '[G]oto [I]mplementation',
      },
      {
        'grd',
        function()
          require('telescope.builtin').lsp_definitions()
        end,
        '[G]oto [D]efinition',
      },
      { 'grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration' },
      {
        'gO',
        function()
          require('telescope.builtin').lsp_document_symbols()
        end,
        'Open Document Symbols',
      },
      {
        'gW',
        function()
          require('telescope.builtin').lsp_dynamic_workspace_symbols()
        end,
        'Open Workspace Symbols',
      },
      {
        'grt',
        function()
          require('telescope.builtin').lsp_type_definitions()
        end,
        '[G]oto [T]ype Definition',
      },
      { 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition' },
      { 'K', vim.lsp.buf.hover, 'Hover Documentation' },
      { '<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction' },
      { '<leader>n', vim.lsp.buf.rename, '[R]e[n]ame' },
    }
    for _, m in ipairs(mappings) do
      map(m[1], m[2], m[3], m[4])
    end

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Load project-local config
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load project-local .nvim.lua',
  group = vim.api.nvim_create_augroup('project-local-config', { clear = true }),
  callback = function()
    local config_file = vim.fn.getcwd() .. '/.nvim.lua'
    if vim.fn.filereadable(config_file) == 1 then
      dofile(config_file)
    end
  end,
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      vim.schedule(function()
        vim.cmd 'normal! zz'
      end)
    end
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'wincmd L',
})

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- No auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

-- Show cursorline only in active window (enable)
local cursorline_group = vim.api.nvim_create_augroup('active_cursorline', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = cursorline_group,
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Show cursorline only in active window (disable)
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = cursorline_group,
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
