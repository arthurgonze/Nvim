local function set_python_path(path)
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'basedpyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

local function get_python_path()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  if venv_path then
    return venv_path .. '/scripts/python.exe'
  end
  return 'C:/Program Files/Epic Games/UE_5.7/Engine/Binaries/ThirdParty/Python3/Win64/python.exe'
end

local function get_current_ue_python_stub()
  local ok, unreal_nvim = pcall(require, 'unreal-nvim')
  if not ok then return '' end
  local ue_project = unreal_nvim.find_uproject()
  if ue_project then
    local ue_folder = ue_project:match '^(.*[\\/])'
    return ue_folder .. 'Intermediate\\PythonStub'
  end
  return ''
end

local function get_ue_python_plugins()
  local ok, unreal_nvim = pcall(require, 'unreal-nvim')
  if not ok then return {} end
  local folders = {}
  local ue_project = unreal_nvim.find_uproject()
  if ue_project then
    local ue_folder = ue_project:match '^(.*[\\/])'
    local ue_plugins = ue_folder .. 'Plugins\\'
    local handle = vim.loop.fs_scandir(ue_plugins)
    while true do
      local name, t = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if t == 'directory' then
        local plugin_folder = ue_plugins .. name .. '\\Content\\Python'
        local stat = vim.loop.fs_stat(plugin_folder)
        if stat ~= nil and stat.type == 'directory' then
          table.insert(folders, plugin_folder)
        end
      end
    end
  end
  return folders
end

-- Called lazily at server start, not at file load time
local function get_extra_paths()
  local paths = {
    get_current_ue_python_stub(),
    'C:/venvs/python_extras/Lib/site-packages',
  }
  vim.list_extend(paths, get_ue_python_plugins())
  return paths
end

return {
  cmd = { 'D:\\language-servers\\basedpyright\\Scripts\\basedpyright-langserver.exe', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  before_init = function(_, config)
    -- Settings are computed here, after plugins are loaded
    config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
      python = {
        pythonPath = get_python_path(),
      },
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          diagnosticSeverityOverrides = {
            reportUnannotatedClassAttribute = false,
            reportUnusedCallResult = false,
            reportAny = false,
          },
          autoImportCompletions = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          extraPaths = get_extra_paths(),
        },
      },
    })
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      client:exec_cmd {
        command = 'basedpyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      }
    end, { desc = 'Organize Imports' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
      desc = 'Reconfigure basedpyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
  end,
}
