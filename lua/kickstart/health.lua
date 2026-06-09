--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. kickstart.nvim requires Neovim 0.12+ (it uses the built-in vim.pack plugin manager)", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.12') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. kickstart.nvim requires Neovim 0.12+ (it uses the built-in vim.pack plugin manager)", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  -- `rg` (ripgrep) is required by Telescope `live_grep` and `grep_string`
  -- The `tree-sitter` CLI is required by nvim-treesitter (main branch) to build parsers
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg', 'tree-sitter' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    vim.health.info('System Information: ' .. vim.inspect(vim.uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
