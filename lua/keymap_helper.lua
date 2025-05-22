local M = {}

-- Helper function to check if a mapping was user-defined (skip plugin noise if needed)
local function is_user_mapping(lhs)
  -- You can customize this to filter plugin mappings
  return not lhs:match("<Plug>")
end

function M.show_keymaps()
  local file = vim.fn.expand("~/.config/nvim/lua/config/keymaps.lua") -- ajusta ruta
  local grep_cmd = "grep -E 'map\\(' " .. file

  local handle = io.popen(grep_cmd)
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    print("No mappings found in keymap.lua")
  else
    vim.api.nvim_echo({{ "Keymaps found in keymap.lua:", "Normal" }}, false, {})
    print(result)
  end
end

return M

