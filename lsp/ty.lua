-- Get virtual env if active otherwise get the unreal python
local function get_python_path()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  if venv_path then
    return venv_path .. '/scripts/python.exe'
  end
  return 'C:\\Program Files\\Epic Games\\UE_5.6.0\\Engine\\Binaries\\ThirdParty\\Python3\\Win64\\python.exe'
end

return {
  cmd = { 'D:\\language-servers\\tylsp\\Scripts\\ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
  environment = {
    python = get_python_path(),
  },
}
