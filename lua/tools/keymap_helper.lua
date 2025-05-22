local M = {}

-- Helper function to check if a mapping was user-defined (skip plugin noise if needed)
local function is_user_mapping(lhs)
  -- You can customize this to filter plugin mappings
  return not lhs:match("<Plug>")
end

local function show_custom_keymaps()
  local keymaps_file = vim.fn.expand("~/.config/nvim/lua/config/keymaps.lua")
  local lines = vim.fn.systemlist("grep -n -E 'vim\\.keymap\\.set|vim\\.api\\.nvim_set_keymap' " .. keymaps_file)
  
  if vim.v.shell_error ~= 0 then
    print("No se encontraron keymaps personalizados.")
    return
  end

  print("Tus keymaps definidos en keymaps.lua:")
  for _, line in ipairs(lines) do
    print(line)
  end
end

-- Exponer función para mapping
return {
  show_custom_keymaps = show_custom_keymaps
}

return M