-- Unreal
return {
  'PlayKigai/Unreal-Nvim',
  -- ft = { 'cpp', 'c', 'h', 'hpp', 'cs', 'ini', 'uproject', 'uplugin' },
  cmd = { 'Unreal' },
  config = function()
    vim.api.nvim_create_user_command('Unreal', function()
      require('unreal-nvim').setup()
    end, {})
    -- require('unreal-nvim').setup {
    -- engine_path = "C:\\Program Files\\Epic Games\\UE_5.6.1", -- optional
    -- auto_register_clangd = true -- if true, tries to auto-configure clangd for Unreal (needs nvim-lspconfig)
    -- }
  end,
}
