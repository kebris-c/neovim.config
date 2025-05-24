-- ═══════════════════════════════════════════════════════════════════════════════
-- DEBUG ADAPTER PROTOCOL CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════
-- Professional debugging setup for developers who've evolved beyond printf archaeology

local dap = require('dap')

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ LLDB ADAPTER CONFIGURATION - The Modern C/C++ Debug Interface              │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- LLDB: Because GDB is like using a Nokia 3310 in the smartphone era

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode',  -- Make sure this is in your PATH or provide absolute path
  name = "lldb"             -- Identifier for this adapter configuration
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ C++ DEBUG CONFIGURATION - Object-Oriented Bug Hunting                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Configuration for debugging C++ applications with the sophistication they deserve

dap.configurations.cpp = {
  {
    name = "Launch C++ Application",        -- Human-readable session name
    type = "lldb",                          -- Links to the adapter defined above
    request = "launch",                     -- Start a new process (vs attach to existing)
    program = function()
      -- Interactive executable selection (because hardcoding paths is for amateurs)
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',            -- Current working directory for the debugged process
    stopOnEntry = false,                   -- Don't pause at program entry (we're not savages)
    args = {},                             -- Command line arguments (empty by default)
    
    -- Platform-specific configurations
    -- macOS users: uncomment the line below if terminal debugging causes issues
    -- runInTerminal = false,
    
    -- Environment variables for the debugged process (customize as needed)
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end,
  },
  {
    -- Additional configuration for core dump analysis
    name = "Analyze Core Dump",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable that generated core: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,                    -- Stop immediately for core analysis
    args = {},
    coreFile = function()
      return vim.fn.input('Path to core file: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ C DEBUG CONFIGURATION - Procedural Bug Extermination                       │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- C debugging inherits C++ configuration because code reuse is a beautiful thing

dap.configurations.c = dap.configurations.cpp

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ CUSTOM DEBUG COMMANDS - Quality of Life Improvements                       │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Additional utilities for enhanced debugging experience

-- Quick launcher for most common use case (debugging ./a.out)
vim.api.nvim_create_user_command('DebugDefault', function()
  if vim.fn.filereadable('./a.out') == 1 then
    dap.run({
      name = "Quick Debug a.out",
      type = "lldb",
      request = "launch", 
      program = vim.fn.getcwd() .. '/a.out',
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    })
    print("🚀 Debugging ./a.out - May the source be with you")
  else
    vim.notify("❌ ./a.out not found. Compile first, debug second.", vim.log.levels.ERROR)
  end
end, { desc = "Debug ./a.out if it exists" })

-- Debug with command line arguments
vim.api.nvim_create_user_command('DebugWithArgs', function()
  local program = vim.fn.input('Executable path: ', './a.out')
  local args_input = vim.fn.input('Arguments (space-separated): ')
  local args = {}
  
  -- Parse arguments (simple space splitting - good enough for most cases)
  if args_input ~= "" then
    for arg in args_input:gmatch("%S+") do
      table.insert(args, arg)
    end
  end
  
  dap.run({
    name = "Debug with Arguments",
    type = "lldb",
    request = "launch",
    program = program,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = args,
  })
  
  print(string.format("🎯 Debugging %s with args: %s", program, args_input))
end, { desc = "Debug executable with custom arguments" })
