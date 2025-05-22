local dap = require('dap')

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode', -- o el path absoluto si no está en $PATH
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- Si usas macOS:
    -- runInTerminal = false,
  },
}

-- Para C, lo mismo que C++
dap.configurations.c = dap.configurations.cpp