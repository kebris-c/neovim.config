vim.g.mapleader = ','  -- coma como tecla líder
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local dap = require('dap')

map('n', '<F12>', function()
  require('keymap_helper').show_custom_keymaps()
end, { desc = "Mostrar keymaps personalizados" })
map('n', '<F2>', ':NERDTreeToggle<CR>', opts)
map('n', '<F3>', ':Stdheader<CR>', opts)
map('n', '<F5>', ':Norminette<CR>', opts)
map('n', '<F6>', ':!cc -Wall -Wextra -pedantic -g3 % -o a.out && echo "Compiled without errors." || echo "Compilation failed."<CR>', opts)
map('n', '<F7>', ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").run_valgrind()<CR>', opts)
map('n', '<F8>', ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").highlight_errors()<CR>', opts)
map('n', '<F9>', ':lua require("tools.valgrind").clear_highlights()<CR>', opts)

-- Lldb Mapping
map('n', '<leader>dd', dap.continue, { desc = "Debug: Start/Continue" })
map('n', '<leader>do', dap.step_over, { desc = "Debug: Step Over" })
map('n', '<leader>di', dap.step_into, { desc = "Debug: Step Into" })
map('n', '<leader>du', dap.step_out, { desc = "Debug: Step Out" })
map('n', '<leader>db', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
map('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Conditional Breakpoint" })
map('n', '<leader>dr', dap.repl.open, { desc = "Debug: Open REPL" })
map('n', '<leader>dl', dap.run_last, { desc = "Debug: Run Last" })

